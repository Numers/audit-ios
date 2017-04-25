//
//  CheckItem.m
//  GLPFinance
//
//  Created by 鲍利成 on 2016/12/15.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import "CheckItem.h"

@implementation CheckItem
-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _itemId = [[dic objectForKey:@"id"] integerValue];
        _pass = [[dic objectForKey:@"pass"] integerValue];
        _time = [[dic objectForKey:@"time"] doubleValue];
        _status = [dic objectForKey:@"status_name"];
        _managerName = [dic objectForKey:@"manager_name"];
        _userType = [NSString stringWithFormat:@"%@",[dic objectForKey:@"user_type"]];
        _name = [dic objectForKey:@"name"];
        _money = [[dic objectForKey:@"money"] floatValue];
        _rentModel = [dic objectForKey:@"rent_model"];
        _loanModel = [dic objectForKey:@"loan_model"];
        _canEditable = YES;
    }
    return self;
}
@end
