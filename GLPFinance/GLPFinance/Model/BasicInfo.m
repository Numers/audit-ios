//
//  basicInfo.m
//  GLPFinance
//
//  Created by 鲍利成 on 2016/12/20.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import "BasicInfo.h"

@implementation BasicInfo
-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        if (dic && [dic isKindOfClass:[NSDictionary class]]) {
            self.infoId = [dic objectForKey:@"info_id"];
            self.canedit = [dic objectForKey:@"canedit"];
            self.fieldId = [dic objectForKey:@"field_id"];
            self.formId = [dic objectForKey:@"form_id"];
            self.display = [dic objectForKey:@"display"];
            self.fieldName = [dic objectForKey:@"field_name"];
            self.formFlag = [dic objectForKey:@"form_flag"];
            self.field = [dic objectForKey:@"field"];
            self.userVal = [dic objectForKey:@"user_val"];
            self.flag = [dic objectForKey:@"flag"];
            self.canSign = ![[dic objectForKey:@"nocheckbox"] boolValue];
            self.isSign = NO;
        }
    }
    return self;
}
@end
