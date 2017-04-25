//
//  GFResetPasswordViewModel.m
//  GLPFinance
//
//  Created by 鲍利成 on 2016/11/28.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import "GFResetPasswordViewModel.h"
#import "GFResetPasswordApiManager.h"

@implementation GFResetPasswordViewModel
/**
 确认按钮是否可点击信号
 
 @return 信号量
 */
-(RACSignal *)comfirmButtonEnableSignal
{
    return [RACSignal combineLatest:@[RACObserve(self, phone),RACObserve(self, validateCode),RACObserve(self, resetPassword)] reduce:^id{
        return @(![AppUtils isNullStr:self.phone] && ![AppUtils isNullStr:self.validateCode] && ![AppUtils isNullStr:self.resetPassword]);
    }];
}


/**
 密码重置信号
 
 @return 信号量
 */
-(RACSignal *)resetPasswordSignal
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GFResetPasswordApiManager shareManager] resetPasswordWithMobile:self.phone code:self.validateCode newPassword:self.resetPassword callback:^(NSDictionary *data) {
            if (data) {
                NSInteger flag = [[data objectForKey:@"flag"] integerValue];
                if (flag == 1) {
                    [subscriber sendNext:@(YES)];
                }else{
                    [subscriber sendNext:@(NO)];
                }
            }
            [subscriber sendCompleted];
        }];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"重置密码信号销毁");
        }];
    }];
}

-(RACSignal *)validateCodeSignal
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GFResetPasswordApiManager shareManager] sendMessageWithMobile:self.phone callback:^(NSDictionary *data) {
            if (data) {
                NSInteger flag = [[data objectForKey:@"flag"] integerValue];
                if (flag == 1) {
                    [subscriber sendNext:@(YES)];
                }else{
                    [subscriber sendNext:@(NO)];
                }
            }
            [subscriber sendCompleted];
        }];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"获取验证码信号销毁");
        }];
    }];
}

-(BOOL)codeBtnValidate
{
    if ([AppUtils isNullStr:self.phone]) {
        [AppUtils showInfo:@"手机号不能为空"];
        return NO;
    }
    
    if (![AppUtils isMobile:self.phone]) {
        [AppUtils showInfo:@"手机号不合法"];
        return NO;
    }
    
    return YES;
}

-(BOOL)validateData
{
    if ([AppUtils isNullStr:self.phone]) {
        [AppUtils showInfo:@"手机号不能为空"];
        return NO;
    }
    
    if (![AppUtils isMobile:self.phone]) {
        [AppUtils showInfo:@"手机号不合法"];
        return NO;
    }
    
    if ([AppUtils isNullStr:self.validateCode]) {
        [AppUtils showInfo:@"验证码不能为空"];
        return NO;
    }
    
    if ([AppUtils isNullStr:self.resetPassword]) {
        [AppUtils showInfo:@"新密码不能为空"];
        return NO;
    }
    return YES;
}
@end
