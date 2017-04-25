//
//  basicInfo.h
//  GLPFinance
//
//  Created by 鲍利成 on 2016/12/20.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BasicInfo : NSObject
@property(nonatomic, copy) NSString *infoId;
@property(nonatomic, copy) NSString *canedit;
@property(nonatomic, strong) NSNumber *fieldId;
@property(nonatomic, strong) NSNumber *formId;
@property(nonatomic, copy) NSString *display;
@property(nonatomic, copy) NSString *fieldName;
@property(nonatomic, copy) NSString *formFlag;
@property(nonatomic, copy) NSString *field;
@property(nonatomic, copy) NSString *userVal;
@property(nonatomic, copy) NSString *flag;

@property(nonatomic) BOOL canSign; //能否标红

@property(nonatomic) BOOL isSign; //是否标红 YES/是  NO/否

-(instancetype)initWithDictionary:(NSDictionary *)dic;
@end
