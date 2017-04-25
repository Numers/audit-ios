//
//  GFResetPasswordApiManager.m
//  GLPFinance
//
//  Created by 鲍利成 on 2016/12/16.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import "GFResetPasswordApiManager.h"

@implementation GFResetPasswordApiManager
+(instancetype)shareManager
{
    static GFResetPasswordApiManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[GFResetPasswordApiManager alloc] init];
    });
    return manager;
}

-(void)sendMessageWithMobile:(NSString *)mobile callback:(APIRequstCallBack)callback
{
    NSDictionary *paras = [NSDictionary dictionaryWithObjectsAndKeys:mobile,@"mobile",@"2",@"type", nil];
    [[NetWorkRequestManager shareManager] post:GF_MessageSend_API parameters:paras callback:callback isNotify:YES];
}

-(void)resetPasswordWithMobile:(NSString *)mobile code:(NSString *)code newPassword:(NSString *)newPassword callback:(APIRequstCallBack)callback
{
    NSDictionary *paras = [NSDictionary dictionaryWithObjectsAndKeys:mobile,@"mobile",code,@"code",[AppUtils getMd5_32Bit:newPassword],@"password", nil];
    [[NetWorkRequestManager shareManager] post:GF_PasswordReset_API parameters:paras callback:callback isNotify:YES];
}
@end
