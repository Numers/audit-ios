//
//  GFResetPasswordViewController.h
//  GLPFinance
//
//  Created by 鲍利成 on 2016/11/28.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GFResetPasswordViewProtocol <NSObject>
-(void)resetPasswordSuccess;
@end
@interface GFResetPasswordViewController : UIViewController
@property(nonatomic, assign) id<GFResetPasswordViewProtocol> delegate;
@end
