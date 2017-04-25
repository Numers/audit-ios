//
//  GFPersonalCenterApiManager.h
//  GLPFinance
//
//  Created by 鲍利成 on 2016/12/16.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetWorkRequestManager.h"

@interface GFPersonalCenterApiManager : NSObject
+(instancetype)shareManager;
-(void)uploadImage:(UIImage *)image callback:(APIRequstCallBack)callback;
-(void)resetHeadImage:(NSString *)url callback:(APIRequstCallBack)callback;
@end
