//
//  GFLoginViewModel.h
//  GLPFinance
//
//  Created by 鲍利成 on 2016/11/23.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GFLoginViewModel : NSObject
@property(nonatomic, copy) NSString *phone;
@property(nonatomic, copy) NSString *password;


/**
 登录按钮是否可用信号

 @return 信号量
 */
-(RACSignal *)LoginButtonEnableSignal;


/**
 登录信号

 @return 信号量
 */
-(RACSignal *)login;


/**
 验证数据

 @param mobile 手机号
 @param password 密码
 @return YES/验证通过  NO/验证不通过
 */
-(BOOL)validateData:(NSString *)mobile password:(NSString *)password;
@end
