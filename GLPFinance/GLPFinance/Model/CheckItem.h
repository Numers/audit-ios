//
//  CheckItem.h
//  GLPFinance
//
//  Created by 鲍利成 on 2016/12/15.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckItem : NSObject
@property(nonatomic) NSInteger itemId;  //项目ID
@property(nonatomic) NSInteger pass;    //审核状态
@property(nonatomic) NSTimeInterval time; //提交时间
@property(nonatomic) NSInteger pid; //平台id 1、快捷用信  2、运力  3、大平台小项目  4、冷链
@property(nonatomic, copy) NSString *status; //审核状态名称
@property(nonatomic, copy) NSString *managerName; //经办人
@property(nonatomic, copy) NSString *userType; //承租人类型
@property(nonatomic, copy) NSString *name; //承租人名称
@property(nonatomic) CGFloat money; //设备金额
@property(nonatomic, copy) NSString *rentModel; //租赁模式
@property(nonatomic, copy) NSString *loanModel; //放款模式

@property(nonatomic) BOOL canEditable;

-(instancetype)initWithDictionary:(NSDictionary *)dic;
@end
