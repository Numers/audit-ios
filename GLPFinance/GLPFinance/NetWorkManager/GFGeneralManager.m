//
//  GFGeneralManager.m
//  GLPFinance
//
//  Created by 鲍利成 on 16/10/28.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import "GFGeneralManager.h"
static GFGeneralManager *gfGeneralManager;
@implementation GFGeneralManager
+(id)defaultManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (gfGeneralManager == nil) {
            gfGeneralManager = [[GFGeneralManager alloc] init];
        }
    });
    
    return gfGeneralManager;
}

-(void)getGlovalVarWithVersion
{
    [AppUtils setUrlWithState:NO];
}
@end
