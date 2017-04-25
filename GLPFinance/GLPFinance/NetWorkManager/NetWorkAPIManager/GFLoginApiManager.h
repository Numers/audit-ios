//
//  GFLoginApiManager.h
//  GLPFinance
//
//  Created by 鲍利成 on 2016/12/14.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetWorkRequestManager.h"

@interface GFLoginApiManager : NSObject
+(instancetype)shareManager;

-(void)login:(NSString *)mobile password:(NSString *)password callback:(APIRequstCallBack)callback;
@end
