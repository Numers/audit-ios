//
//  GFUploadMaterialListViewController.h
//  GLPFinance
//
//  Created by 鲍利成 on 2016/11/28.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GFUploadMaterialViewProtocol <NSObject>
-(void)loadUploadMaterialData:(void(^)(id data))callback;
@end
@interface GFUploadMaterialListViewController : UIViewController
@property(nonatomic, assign) id<GFUploadMaterialViewProtocol> delegate;

-(NSMutableArray *)returnMaterialList;
@end
