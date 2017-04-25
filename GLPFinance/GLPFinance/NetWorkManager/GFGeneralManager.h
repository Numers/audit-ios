//
//  GFGeneralManager.h
//  GLPFinance
//
//  Created by 鲍利成 on 16/10/28.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetWorkManager.h"
@interface GFGeneralManager : NSObject
+(id)defaultManager;

-(void)getGlovalVarWithVersion;
@end
