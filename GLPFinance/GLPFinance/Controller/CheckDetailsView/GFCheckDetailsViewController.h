//
//  GFCheckDetailsViewController.h
//  GLPFinance
//
//  Created by 鲍利成 on 2016/11/28.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CheckItem;
@protocol GFCheckDetailsViewProtocol <NSObject>
-(void)checkItemDidChecked:(CheckItem *)item;
@end
@interface GFCheckDetailsViewController : UIViewController
@property(nonatomic, strong) CheckItem *item;
@property(nonatomic, weak) id<GFCheckDetailsViewProtocol> delegate;
@end
