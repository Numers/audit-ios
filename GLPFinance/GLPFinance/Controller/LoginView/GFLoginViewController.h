//
//  GFLoginViewController.h
//  GLPFinance
//
//  Created by 鲍利成 on 2016/11/23.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LoginViewProtocol <NSObject>
-(void)loginSuccess;
-(void)forgetPassword;
@end
@interface GFLoginViewController : UIViewController
@property(nonatomic, assign) id<LoginViewProtocol> delegate;
@end
