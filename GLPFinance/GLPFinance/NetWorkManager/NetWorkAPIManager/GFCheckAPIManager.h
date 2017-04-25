//
//  GFCheckAPIManager.h
//  GLPFinance
//
//  Created by 鲍利成 on 2016/12/15.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetWorkRequestManager.h"

@interface GFCheckAPIManager : NSObject
+(instancetype)shareManager;


/**
 获取指定页的审核列表

 @param pageNum 第几页
 @param size 一页的记录数
 @param conditions 过滤条件
 @param callback 回调函数
 */
-(void)requestCheckListWithPageNum:(NSInteger)pageNum WithPageSize:(NSInteger)size WithFilterCondition:(NSDictionary *)conditions callback:(APIRequstCallBack)callback;


/**
 获取审核详情信息

 @param itemId 项目id
 @param callback 回调函数
 */
-(void)requestBasicInfoWithItemId:(NSInteger)itemId callback:(APIRequstCallBack)callback;


/**
 获取上传材料信息

 @param itemId 项目id
 @param callback 回调函数
 */
-(void)requestUploadMaterialWithItemId:(NSInteger)itemId callback:(APIRequstCallBack)callback;


/**
 审核资料

 @param status 审核状态
 @param pid 项目id
 @param reason 原因
 @param commitId 表单提交id
 @param caneditList 审批项
 @param callback 回调函数
 */
-(void)audit:(NSInteger)status projectId:(NSInteger)pid reason:(NSString *)reason commitId:(NSInteger)commitId canedit:(NSArray *)caneditList callback:(APIRequstCallBack)callback;
@end
