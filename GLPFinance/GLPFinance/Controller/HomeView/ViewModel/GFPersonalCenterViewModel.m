//
//  GFPersonalCenterViewModel.m
//  GLPFinance
//
//  Created by 鲍利成 on 2016/12/16.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import "GFPersonalCenterViewModel.h"
#import "GFPersonalCenterApiManager.h"

@implementation GFPersonalCenterViewModel
-(RACSignal *)uploadImageSignal:(UIImage *)image
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GFPersonalCenterApiManager shareManager] uploadImage:image callback:^(NSDictionary *data) {
            if (data) {
                NSString *url = [data objectForKey:@"FileData"];
                [subscriber sendNext:url];
            }else{
                [subscriber sendNext:nil];
            }
            [subscriber sendCompleted];
        }];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"上传头像信号销毁");
        }];
    }];
}

-(RACSignal *)resetHeadImage:(NSString *)url
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GFPersonalCenterApiManager shareManager] resetHeadImage:url callback:^(NSDictionary *data) {
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
            NSLog(@"设置头像信号销毁");
        }];
    }];
}
@end
