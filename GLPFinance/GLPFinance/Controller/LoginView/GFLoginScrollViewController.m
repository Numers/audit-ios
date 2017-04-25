//
//  GFLoginScrollViewController.m
//  GLPFinance
//
//  Created by 鲍利成 on 2016/11/23.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import "GFLoginScrollViewController.h"
#import "GFLoginViewController.h"
#import "GFHomeViewController.h"
#import "GFResetPasswordScrollViewController.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface GFLoginScrollViewController ()<LoginViewProtocol>
{
    GFLoginViewController *loginVC;
    TPKeyboardAvoidingScrollView *scrollView;
}
@end

@implementation GFLoginScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:ViewBackgroundColor];
    scrollView = [[TPKeyboardAvoidingScrollView alloc] init];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:scrollView];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    loginVC = [storyboard instantiateViewControllerWithIdentifier:@"GFLoginViewIdentify"];
    loginVC.delegate = self;
    [scrollView addSubview:loginVC.view];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [scrollView setFrame:CGRectMake(0, 0, GDeviceWidth, GDeviceHeight)];
    [loginVC.view setFrame:CGRectMake(0, 0, GDeviceWidth, GDeviceHeight)];
    [scrollView setContentSize:CGSizeMake(GDeviceWidth, GDeviceHeight)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark LoginViewProtocol
-(void)loginSuccess
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GFHomeViewController *homeVC = [storyboard instantiateViewControllerWithIdentifier:@"GFHomeViewIdentify"];
    [self.navigationController pushViewController:homeVC animated:YES];
}

-(void)forgetPassword
{
    GFResetPasswordScrollViewController *resetPasswordScrollVC = [[GFResetPasswordScrollViewController alloc] initWithTitle:@"密码重置"];
    [self.navigationController pushViewController:resetPasswordScrollVC animated:YES];
}
@end
