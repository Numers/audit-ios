//
//  GFLoginApiManager.m
//  GLPFinance
//
//  Created by 鲍利成 on 2016/12/14.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import "GFLoginApiManager.h"

@implementation GFLoginApiManager
+(instancetype)shareManager
{
    static GFLoginApiManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[GFLoginApiManager alloc] init];
        }
    });
    return manager;
}

-(void)login:(NSString *)mobile password:(NSString *)password callback:(APIRequstCallBack)callback
{
    NSDictionary *paras = [NSDictionary dictionaryWithObjectsAndKeys:mobile,@"mobile",[AppUtils getMd5_32Bit:password],@"password", nil];
    [[NetWorkRequestManager shareManager] post:GF_Login_API parameters:paras callback:callback isNotify:YES];
}
@end
