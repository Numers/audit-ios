//
//  GFResetPasswordApiManager.h
//  GLPFinance
//
//  Created by 鲍利成 on 2016/12/16.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetWorkRequestManager.h"

@interface GFResetPasswordApiManager : NSObject
+(instancetype)shareManager;
-(void)sendMessageWithMobile:(NSString *)mobile callback:(APIRequstCallBack)callback;
-(void)resetPasswordWithMobile:(NSString *)mobile code:(NSString *)code newPassword:(NSString *)newPassword callback:(APIRequstCallBack)callback;
@end
