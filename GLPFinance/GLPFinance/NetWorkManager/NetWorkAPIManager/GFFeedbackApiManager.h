//
//  GFFeedbackApiManager.h
//  GLPFinance
//
//  Created by 鲍利成 on 2016/12/16.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetWorkRequestManager.h"

@interface GFFeedbackApiManager : NSObject
+(instancetype)shareManager;
-(void)feedback:(NSString *)email content:(NSString *)content callback:(APIRequstCallBack)callback;
@end
