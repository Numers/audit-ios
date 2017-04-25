//
//  GFCheckDetailsViewModel.m
//  GLPFinance
//
//  Created by 鲍利成 on 2016/12/16.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import "GFCheckDetailsViewModel.h"
#import "GFCheckAPIManager.h"
#import "CheckItem.h"

@implementation GFCheckDetailsViewModel
-(instancetype)initWithCheckItem:(CheckItem *)checkItem
{
    self = [super init];
    if (self) {
        _item = checkItem;
    }
    return self;
}

-(RACSignal *)requestBasicInfoSignal
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        if (_item) {
            [[GFCheckAPIManager shareManager] requestBasicInfoWithItemId:_item.itemId callback:^(id data) {
                [subscriber sendNext:data];
                [subscriber sendCompleted];
            }];
        }else{
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        }
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"审核详情信号量销毁");
        }];
    }];
}

-(RACSignal *)requestUploadMaterialInfoSignal
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        if (_item) {
            [[GFCheckAPIManager shareManager] requestUploadMaterialWithItemId:_item.itemId callback:^(id data) {
                [subscriber sendNext:data];
                [subscriber sendCompleted];
            }];
        }else{
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        }
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"上传材料信号量销毁");
        }];
    }];
}

-(RACSignal *)audit:(AuditStatus)status reason:(NSString *)reason commitId:(NSInteger)commitId canedit:(NSArray *)caneditList
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        if (_item) {
            [[GFCheckAPIManager shareManager] audit:status projectId:_item.pid reason:reason commitId:commitId canedit:caneditList callback:^(id data) {
                [subscriber sendNext:data];
                [subscriber sendCompleted];
            }];
        }else{
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        }
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"审核信号销毁");
        }];
    }];
}
@end
