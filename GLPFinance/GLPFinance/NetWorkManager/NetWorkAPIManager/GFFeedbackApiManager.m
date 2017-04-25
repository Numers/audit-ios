//
//  GFFeedbackApiManager.m
//  GLPFinance
//
//  Created by 鲍利成 on 2016/12/16.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import "GFFeedbackApiManager.h"

@implementation GFFeedbackApiManager
+(instancetype)shareManager
{
    static GFFeedbackApiManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[GFFeedbackApiManager alloc] init];
        }
    });
    return manager;
}

-(void)feedback:(NSString *)email content:(NSString *)content callback:(APIRequstCallBack)callback
{
    NSDictionary *paras = [NSDictionary dictionaryWithObjectsAndKeys:email,@"email",content,@"content", nil];
    [[NetWorkRequestManager shareManager] post:GF_Feedback_API parameters:paras callback:callback isNotify:YES];
}
@end
