//
//  GFPersonalCenterViewController.h
//  GLPFinance
//
//  Created by 鲍利成 on 2016/11/24.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GFPersonalCenterViewProtocol <NSObject>
-(void)modifyPassword;
-(void)feedback;
-(void)aboutus;
-(void)loginout;
@end
@interface GFPersonalCenterViewController : UIViewController
@property(nonatomic, assign) id<GFPersonalCenterViewProtocol> delegate;
@end
