//
//  PHHeadImageView.h
//  PocketHealth
//
//  Created by macmini on 15-1-31.
//  Copyright (c) 2015年 YiLiao. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GFHeadImageViewDelegate <NSObject>
-(void)clickHeadButton;
@end
@class Member;
@interface GFHeadImageView : UIView
@property(nonatomic, strong) UIImageView *backGroundImageView;
@property(nonatomic, strong) UILabel *nickNameLabel;
@property(nonatomic, strong) UIImageView *headImageView;
@property(nonatomic, strong) UIButton *btnUserHead;
@property(nonatomic, strong) UIView *borderView;

@property(nonatomic, weak) id<GFHeadImageViewDelegate> delegate;

-(void)setupWithMember:(Member *)member;
@end
