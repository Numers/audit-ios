//
//  GFHomeViewController.m
//  GLPFinance
//
//  Created by 鲍利成 on 2016/11/24.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import "GFHomeViewController.h"
#import "GFCheckListViewController.h"
#import "GFPersonalCenterViewController.h"
#import "GFFeedbackViewController.h"
#import "GFAboutViewController.h"
#import "GFResetPasswordScrollViewController.h"
#import "GFCheckDetailsViewController.h"
#import "UIColor+HexString.h"
#import "AppStartManager.h"

@interface GFHomeViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,GFPersonalCenterViewProtocol,GFCheckListViewProtocol>
{
    NSInteger currentPage;
    NSInteger lastPage;
    NSMutableArray *controllers;
}
@property(nonatomic, strong) UIPageViewController *pageVC;
@property(nonatomic, strong) GFCheckListViewController *checkListVC;
@property(nonatomic, strong) GFPersonalCenterViewController *personalCenterVC;

@property(nonatomic, strong) IBOutlet UIButton *btnCheckList;
@property(nonatomic, strong) IBOutlet UIButton *btnPersonalCenter;
@end

@implementation GFHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:ViewBackgroundMainColor];
    
    _pageVC = [self.childViewControllers firstObject];
    _checkListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GFCheckListViewIdentify"];
    _checkListVC.delegate = self;
    _personalCenterVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GFPersonalCenterViewIdentify"];
    _personalCenterVC.delegate = self;
    
    _pageVC.delegate = self;
    _pageVC.dataSource = self;
    
    currentPage = 0;
    lastPage = 0;
    controllers = [NSMutableArray arrayWithObjects:_checkListVC,_personalCenterVC, nil];
    [_pageVC setViewControllers:@[_checkListVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self changeViewController:currentPage];
    
    UIScrollView *pageScrollView = [self findScrollView];
    if (pageScrollView) {
        [pageScrollView setScrollEnabled:NO];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark privateFunction
-(UIScrollView *)findScrollView{
    
    UIScrollView*scrollView;
    
    for(id subview in _pageVC.view.subviews){
        
        if([subview isKindOfClass:UIScrollView.class]){
            
            scrollView=subview;
            
            break;
            
        }}
    
    return scrollView;
    
}

-(void)setCurrentPage:(NSInteger)page
{
    currentPage = page;
    if (currentPage > lastPage) {
        [self.pageVC setViewControllers:@[[controllers objectAtIndex:currentPage]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }else{
        [self.pageVC setViewControllers:@[[controllers objectAtIndex:currentPage]] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    }
    lastPage = currentPage;
    [self changeViewController:page];
}

-(void)changeViewController:(NSInteger)page
{
    if (page == 0) {
        [_btnCheckList setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnCheckList setBackgroundColor:[UIColor colorFromHexString:@"#02AF00"]];
        [_btnCheckList setImage:[UIImage imageNamed:@"Home_CheckList_White"] forState:UIControlStateNormal];
        [_btnPersonalCenter setTitleColor:[UIColor colorFromHexString:@"#7F7F7F"] forState:UIControlStateNormal];
        [_btnPersonalCenter setBackgroundColor:[UIColor whiteColor]];
        [_btnPersonalCenter setImage:[UIImage imageNamed:@"Home_PersonalCenter_Gray"] forState:UIControlStateNormal];
    }
    
    if (page == 1) {
        [_btnCheckList setTitleColor:[UIColor colorFromHexString:@"#7F7F7F"] forState:UIControlStateNormal];
        [_btnCheckList setBackgroundColor:[UIColor whiteColor]];
        [_btnCheckList setImage:[UIImage imageNamed:@"Home_CheckList_Gray"] forState:UIControlStateNormal];
        [_btnPersonalCenter setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnPersonalCenter setBackgroundColor:[UIColor colorFromHexString:@"#02AF00"]];
        [_btnPersonalCenter setImage:[UIImage imageNamed:@"Home_PersonalCenter_White"] forState:UIControlStateNormal];
    }
    
    if (currentPage != page) {
        currentPage = page;
        lastPage = currentPage;
    }
}

#pragma -mark ButtonEvent
-(IBAction)clickTabBtn:(UIButton *)sender
{
    [self setCurrentPage:sender.tag - 100];
}
#pragma -mark UIPageViewControllerDelegate |  UIPageViewControllerDataSource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[GFPersonalCenterViewController class]]) {
        return _checkListVC;
    }
    return nil;
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[GFCheckListViewController class]]) {
        return _personalCenterVC;
    }
    return nil;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed) {
        UIViewController *vc = [previousViewControllers lastObject];
        if ([vc isKindOfClass:[GFCheckListViewController class]]) {
            [self changeViewController:1];
        }
        
        if ([vc isKindOfClass:[GFPersonalCenterViewController class]]) {
            [self changeViewController:0];
        }
    }
}

#pragma -mark GFPersonalCenterViewProtocol
-(void)modifyPassword
{
    GFResetPasswordScrollViewController *resetPasswordScrollVC = [[GFResetPasswordScrollViewController alloc] initWithTitle:@"修改密码"];
    [self.navigationController pushViewController:resetPasswordScrollVC animated:YES];
}
-(void)feedback
{
    GFFeedbackViewController *feedbackVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GFFeedbackViewIdentify"];
    [self.navigationController pushViewController:feedbackVC animated:YES];
}
-(void)aboutus
{
    GFAboutViewController *aboutVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GFAboutViewIdentify"];
    [self.navigationController pushViewController:aboutVC animated:YES];
}
-(void)loginout
{
    [[AppStartManager shareManager] loginout];
}

#pragma -mark GFCheckListViewProtocol
-(void)pushCheckDetailsViewWithCheckItem:(CheckItem *)item
{
    GFCheckDetailsViewController *checkDetailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GFCheckDetailsViewIdentify"];
    checkDetailsVC.item = item;
    checkDetailsVC.delegate = _checkListVC;
    [self.navigationController pushViewController:checkDetailsVC animated:YES];
}
@end
