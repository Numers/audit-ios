//
//  GFResetPasswordScrollViewController.m
//  GLPFinance
//
//  Created by 鲍利成 on 2016/11/28.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import "GFResetPasswordScrollViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "GFResetPasswordViewController.h"
#import "AppStartManager.h"

@interface GFResetPasswordScrollViewController ()<GFResetPasswordViewProtocol>
{
    GFResetPasswordViewController *resetPasswordVC;
    TPKeyboardAvoidingScrollView *scrollView;
    NSString *title;
}
@end

@implementation GFResetPasswordScrollViewController
-(instancetype)initWithTitle:(NSString *)navTitle
{
    self = [super init];
    if (self) {
        title = navTitle;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:ViewBackgroundColor];
    scrollView = [[TPKeyboardAvoidingScrollView alloc] init];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:scrollView];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    resetPasswordVC = [storyboard instantiateViewControllerWithIdentifier:@"GFResetPasswordViewIdentify"];
    resetPasswordVC.delegate = self;
    [scrollView addSubview:resetPasswordVC.view];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    if (title) {
        self.title = title;
    }
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [scrollView setFrame:CGRectMake(0, 0, GDeviceWidth, GDeviceHeight)];
    [resetPasswordVC.view setFrame:CGRectMake(0, 0, GDeviceWidth, GDeviceHeight)];
    [scrollView setContentSize:CGSizeMake(GDeviceWidth, GDeviceHeight)];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark GFResetPasswordViewProtocol
-(void)resetPasswordSuccess
{
    [[AppStartManager shareManager] loginout];
}
@end
