//
//  GFFeedbackViewModel.m
//  GLPFinance
//
//  Created by 鲍利成 on 2016/12/16.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import "GFFeedbackViewModel.h"
#import "GFFeedbackApiManager.h"

@implementation GFFeedbackViewModel
/**
 提交按钮是否可点击信号
 
 @return 信号量
 */
-(RACSignal *)comfirmButtonEnableSignal
{
    return [RACSignal combineLatest:@[RACObserve(self, email),RACObserve(self, content)] reduce:^id{
        return @(![AppUtils isNullStr:self.email] && ![AppUtils isNullStr:self.content]);
    }];
}


/**
 提交反馈信号
 
 @return 信号量
 */
-(RACSignal *)submitFeedbackSignal
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GFFeedbackApiManager shareManager] feedback:self.email content:self.content callback:^(NSDictionary *data) {
            if (data) {
                NSInteger flag = [[data objectForKey:@"flag"] integerValue];
                if (flag == 1) {
                    [subscriber sendNext:@(YES)];
                }else{
                    [subscriber sendNext:@(NO)];
                }
                [subscriber sendCompleted];
            }
        }];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"提交反馈信号销毁");
        }];
    }];
}

/**
 检验反馈数据
 
 @param email 邮箱
 @param content 反馈内容
 @return YES/通过  NO/不通过
 */
-(BOOL)validateData:(NSString *)email content:(NSString *)content
{
    if (![AppUtils isEmail:email]) {
        [AppUtils showInfo:@"邮箱格式不合法"];
        return NO;
    }
    
    if ([AppUtils isNullStr:content]) {
        [AppUtils showInfo:@"反馈内容不能为空"];
        return NO;
    }
    return YES;
}
@end
