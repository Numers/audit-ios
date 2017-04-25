//
//  GFFeedbackViewModel.h
//  GLPFinance
//
//  Created by 鲍利成 on 2016/12/16.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GFFeedbackViewModel : NSObject
@property(nonatomic, copy) NSString *email;
@property(nonatomic, copy) NSString *content;
/**
 提交按钮是否可点击信号
 
 @return 信号量
 */
-(RACSignal *)comfirmButtonEnableSignal;


/**
 提交反馈信号

 @return 信号量
 */
-(RACSignal *)submitFeedbackSignal;


/**
 检验反馈数据

 @param email 邮箱
 @param content 反馈内容
 @return YES/通过  NO/不通过
 */
-(BOOL)validateData:(NSString *)email content:(NSString *)content;
@end
