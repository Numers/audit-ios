//
//  UploadMaterial.h
//  GLPFinance
//
//  Created by 鲍利成 on 2016/12/20.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasicInfo.h"
@interface UploadMaterial : NSObject
@property(nonatomic, strong) BasicInfo *basicInfo;
@property(nonatomic, strong) NSMutableArray *childInfos;

-(instancetype)initWithDictionary:(NSDictionary *)dic;
@end
