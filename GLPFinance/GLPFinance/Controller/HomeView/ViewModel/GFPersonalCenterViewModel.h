//
//  GFPersonalCenterViewModel.h
//  GLPFinance
//
//  Created by 鲍利成 on 2016/12/16.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GFPersonalCenterViewModel : NSObject

/**
 上传头像文件信号

 @param image 头像图片
 @return 信号
 */
-(RACSignal *)uploadImageSignal:(UIImage *)image;


/**
 设置头像信号

 @param url 头像路径
 @return 信号
 */
-(RACSignal *)resetHeadImage:(NSString *)url;
@end
