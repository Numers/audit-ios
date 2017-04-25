//
//  GFResetPasswordViewModel.h
//  GLPFinance
//
//  Created by 鲍利成 on 2016/11/28.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GFResetPasswordViewModel : NSObject
@property(nonatomic, copy) NSString *phone;
@property(nonatomic, copy) NSString *validateCode;
@property(nonatomic, copy) NSString *resetPassword;


/**
 确认按钮是否可点击信号

 @return 信号量
 */
-(RACSignal *)comfirmButtonEnableSignal;


/**
 密码重置信号

 @return 信号量
 */
-(RACSignal *)resetPasswordSignal;


/**
 获取验证码信号

 @return 信号量
 */
-(RACSignal *)validateCodeSignal;


/**
 
验证码按钮验证
 @return YES/可以获取验证码   NO/不能获取验证码
 */
-(BOOL)codeBtnValidate;


/**
 用户输入数据校验

 @return YES/通过 NO/不通过
 */
-(BOOL)validateData;
@end
