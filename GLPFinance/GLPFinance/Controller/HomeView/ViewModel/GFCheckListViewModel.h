//
//  GFCheckListViewModel.h
//  GLPFinance
//
//  Created by 鲍利成 on 2016/12/15.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GFCheckListViewModel : NSObject


/**
 获取审核列表信号

 @param page 获取的第几页
 @param size 一页的记录数目
 @param conditions 过滤条件
 @return 列表信号
 */
-(RACSignal *)checkListWithPageNum:(NSInteger)page WithPageSize:(NSInteger)size WithFilterCondition:(NSDictionary *)conditions;


/**
 返回特定格式的日期

 @param time 时间戳
 @return 日期字符串
 */
-(NSString *)dateStrFromTime:(NSTimeInterval)time;
@end
