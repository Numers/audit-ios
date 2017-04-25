//
//  GFCheckDetailsViewModel.h
//  GLPFinance
//
//  Created by 鲍利成 on 2016/12/16.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    Compeletely = 1,
    Overruled = 2,
    Reject = 3
}AuditStatus;
@class CheckItem;
@interface GFCheckDetailsViewModel : NSObject
@property(nonatomic, strong) CheckItem *item;

-(instancetype)initWithCheckItem:(CheckItem *)checkItem;
/**
 请求审核详情信号
 @return 信号量
 */
-(RACSignal *)requestBasicInfoSignal;


/**
 请求上传材料信号

 @return 信号量
 */
-(RACSignal *)requestUploadMaterialInfoSignal;


/**
 审核信号

 @param status 审核状态
 @param reason 原因(可为nil)
 @param commitId 表单提交id
 @param caneditList 审批项
 @return 信号量
 */
-(RACSignal *)audit:(AuditStatus)status reason:(NSString *)reason commitId:(NSInteger)commitId canedit:(NSArray *)caneditList;
@end
