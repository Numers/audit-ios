//
//  GFCheckListViewModel.m
//  GLPFinance
//
//  Created by 鲍利成 on 2016/12/15.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import "GFCheckListViewModel.h"
#import "GFCheckAPIManager.h"

@implementation GFCheckListViewModel
-(RACSignal *)checkListWithPageNum:(NSInteger)page WithPageSize:(NSInteger)size WithFilterCondition:(NSDictionary *)conditions
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GFCheckAPIManager shareManager] requestCheckListWithPageNum:page WithPageSize:size WithFilterCondition:conditions callback:^(NSDictionary *data) {
            [subscriber sendNext:data];
            [subscriber sendCompleted];
        }];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"审核列表信号销毁");
        }];
    }];
}

-(NSString *)dateStrFromTime:(NSTimeInterval)time
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss\nyyyy-MM-dd"];
    NSDate *transferDate = [NSDate dateWithTimeIntervalSince1970:time];
    return [formatter stringFromDate:transferDate];
}
@end
