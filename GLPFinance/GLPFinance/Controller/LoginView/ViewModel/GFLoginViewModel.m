//
//  GFLoginViewModel.m
//  GLPFinance
//
//  Created by 鲍利成 on 2016/11/23.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import "GFLoginViewModel.h"
#import "GFLoginApiManager.h"

@implementation GFLoginViewModel
-(RACSignal *)LoginButtonEnableSignal
{
    return [RACSignal combineLatest:@[RACObserve(self, phone),RACObserve(self, password)] reduce:^id{
        return @(![AppUtils isNullStr:self.phone] && ![AppUtils isNullStr:self.password]);
    }];
}

-(RACSignal *)login
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GFLoginApiManager shareManager] login:self.phone password:self.password callback:^(NSDictionary *data) {
            [subscriber sendNext:data];
            [subscriber sendCompleted];
        }];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"登录信号销毁");
        }];
    }];
}

-(BOOL)validateData:(NSString *)mobile password:(NSString *)password
{
    if (![AppUtils isMobile:mobile]) {
        [AppUtils showInfo:@"手机号不合法"];
        return NO;
    }
    
    if ([AppUtils isNullStr:password]) {
        [AppUtils showInfo:@"密码不能为空"];
        return NO;
    }
    return YES;
}
@end
