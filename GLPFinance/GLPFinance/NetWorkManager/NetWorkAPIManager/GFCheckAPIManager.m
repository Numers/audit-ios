//
//  GFCheckAPIManager.m
//  GLPFinance
//
//  Created by 鲍利成 on 2016/12/15.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import "GFCheckAPIManager.h"

@implementation GFCheckAPIManager
+(instancetype)shareManager
{
    static GFCheckAPIManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[GFCheckAPIManager alloc] init];
        }
    });
    return manager;
}

-(void)requestCheckListWithPageNum:(NSInteger)pageNum WithPageSize:(NSInteger)size WithFilterCondition:(NSDictionary *)conditions callback:(APIRequstCallBack)callback
{
    NSMutableDictionary *paras;
    if (conditions) {
        paras = [NSMutableDictionary dictionaryWithDictionary:conditions];
    }else{
        paras = [NSMutableDictionary dictionary];
    }
    
    [paras setObject:[NSNumber numberWithInteger:pageNum] forKey:@"last_id"];
    [paras setObject:[NSNumber numberWithInteger:size] forKey:@"pagesize"];

    [[NetWorkRequestManager shareManager] post:GF_CheckList_API parameters:paras callback:callback isNotify:YES];
}

-(void)requestBasicInfoWithItemId:(NSInteger)itemId callback:(APIRequstCallBack)callback
{
    NSDictionary *paras = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:itemId],@"id", nil];
    [[NetWorkRequestManager shareManager] post:GF_CheckInfo_API parameters:paras callback:callback isNotify:YES];
}

-(void)requestUploadMaterialWithItemId:(NSInteger)itemId callback:(APIRequstCallBack)callback
{
    NSDictionary *paras = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:itemId],@"id", nil];
    [[NetWorkRequestManager shareManager] post:GF_UploadMaterialInfo_API parameters:paras callback:callback isNotify:YES];
}

-(void)audit:(NSInteger)status projectId:(NSInteger)pid reason:(NSString *)reason commitId:(NSInteger)commitId canedit:(NSArray *)caneditList callback:(APIRequstCallBack)callback
{
    NSMutableDictionary *paras = [NSMutableDictionary dictionaryWithObjectsAndKeys:@(status),@"type",@(pid),@"project_id",@(commitId),@"commit_id",caneditList,@"canedit", nil];
    if (![AppUtils isNullStr:reason]) {
        [paras setObject:reason forKey:@"reason"];
    }
    [[NetWorkRequestManager shareManager] post:GF_Audit_API parameters:paras callback:callback isNotify:YES];
}
@end
