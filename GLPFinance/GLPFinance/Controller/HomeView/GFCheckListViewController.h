//
//  GFCheckListViewController.h
//  GLPFinance
//
//  Created by 鲍利成 on 2016/11/24.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CheckItem;
@protocol GFCheckListViewProtocol <NSObject>
-(void)pushCheckDetailsViewWithCheckItem:(CheckItem *)item;
@end
@interface GFCheckListViewController : UIViewController
@property(nonatomic, assign) id<GFCheckListViewProtocol> delegate;
@end
