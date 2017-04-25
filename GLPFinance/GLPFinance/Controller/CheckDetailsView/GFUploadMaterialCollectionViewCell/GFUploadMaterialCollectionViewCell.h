//
//  GFUploadMaterialCollectionViewCell.h
//  GLPFinance
//
//  Created by 鲍利成 on 2016/11/30.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GFUploadMaterialCollectionViewCell : UICollectionViewCell
@property(nonatomic, strong) UIScrollView *contentScrollView;
@property(nonatomic, strong) UIWebView *contentWebView;

-(void)loadMaterial:(NSString *)url;
@end
