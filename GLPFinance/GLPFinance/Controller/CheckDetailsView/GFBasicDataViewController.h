//
//  GFBasicDataViewController.h
//  GLPFinance
//
//  Created by 鲍利成 on 2016/11/28.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GFBasicDataViewProtocol <NSObject>
-(void)loadBasicData:(void(^)(id data))callback;
@end
@interface GFBasicDataViewController : UIViewController
@property(nonatomic, assign) id<GFBasicDataViewProtocol> delegate;

-(NSMutableArray *)returnBasicInfoList;
@end
