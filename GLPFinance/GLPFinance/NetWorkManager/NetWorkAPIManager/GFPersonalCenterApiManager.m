//
//  GFPersonalCenterApiManager.m
//  GLPFinance
//
//  Created by 鲍利成 on 2016/12/16.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import "GFPersonalCenterApiManager.h"

@implementation GFPersonalCenterApiManager
+(instancetype)shareManager
{
    static GFPersonalCenterApiManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[GFPersonalCenterApiManager alloc] init];
        }
    });
    return manager;
}

-(void)uploadImage:(UIImage *)image callback:(APIRequstCallBack)callback
{
    [[NetWorkRequestManager shareManager] uploadImage:image uri:GF_UploadPicture_API parameters:nil callback:callback isNotify:YES];
}

-(void)resetHeadImage:(NSString *)url callback:(APIRequstCallBack)callback
{
    NSDictionary *paras = [NSDictionary dictionaryWithObjectsAndKeys:url,@"url", nil];
    [[NetWorkRequestManager shareManager] post:GF_HeadImageSet_API parameters:paras callback:callback isNotify:YES];
}
@end
