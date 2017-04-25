//
//  GFCheckDetailsViewController.m
//  GLPFinance
//
//  Created by 鲍利成 on 2016/11/28.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import "GFCheckDetailsViewController.h"
#import "GFBasicDataViewController.h"
#import "GFUploadMaterialListViewController.h"
#import "LGAlertView.h"
#import "GFTextView.h"

#import "CheckItem.h"
#import "GFCheckDetailsViewModel.h"

#import "BasicInfo.h"
#import "UploadMaterial.h"

@interface GFCheckDetailsViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,GFBasicDataViewProtocol,GFUploadMaterialViewProtocol>
{
    NSInteger currentPage;
    NSInteger lastPage;
    NSMutableArray *controllers;
    
    UIView *sliderView;
    
    GFCheckDetailsViewModel *viewModel;
}
@property(nonatomic, strong) UIPageViewController *pageVC;
@property(nonatomic, strong) GFBasicDataViewController *basicDataVC;
@property(nonatomic, strong) GFUploadMaterialListViewController *uploadMaterialListVC;
@property(nonatomic, strong) IBOutlet UIView *sliderBackView;
@property(nonatomic, strong) IBOutlet UIButton *btnBasicData;
@property(nonatomic, strong) IBOutlet UIButton *btnUploadMaterialList;
@end

@implementation GFCheckDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:ViewBackgroundMainColor];
    viewModel = [[GFCheckDetailsViewModel alloc] initWithCheckItem:_item];
    //slider初始化
    sliderView = [[UIView alloc] initWithFrame:CGRectMake(0, -2, GDeviceWidth / 2.0f, 2)];
    [sliderView setBackgroundColor:[UIColor colorFromHexString:@"#02AF00"]];
    [_sliderBackView addSubview:sliderView];
    //pageView 初始化
    _pageVC = [self.childViewControllers firstObject];
    _basicDataVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GFBasicDataViewIdentify"];
    _basicDataVC.delegate = self;
    _uploadMaterialListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GFUploadMaterialListViewIdentify"];
    _uploadMaterialListVC.delegate = self;
    
    _pageVC.delegate = self;
    _pageVC.dataSource = self;
    
    currentPage = 0;
    lastPage = 0;
    controllers = [NSMutableArray arrayWithObjects:_basicDataVC,_uploadMaterialListVC, nil];
    [_pageVC setViewControllers:@[_basicDataVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self changeViewController:currentPage];
    
    UIScrollView *pageScrollView = [self findScrollView];
    if (pageScrollView) {
        [pageScrollView setScrollEnabled:NO];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self setTitle:@"审核详情"];
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
    [UIView animateWithDuration:0.3 animations:^{
        if (sliderView) {
            [sliderView setFrame:CGRectMake((GDeviceWidth / 2.0f) * page, -2, GDeviceWidth / 2.0f, 2)];
        }
    } completion:^(BOOL finished) {
        
    }];
    if (page == 0) {
        [_btnBasicData setTitleColor:[UIColor colorFromHexString:@"#02AF00"] forState:UIControlStateNormal];
        [_btnUploadMaterialList setTitleColor:[UIColor colorFromHexString:@"#818181"] forState:UIControlStateNormal];
    }
    
    if (page == 1) {
        [_btnBasicData setTitleColor:[UIColor colorFromHexString:@"#818181"] forState:UIControlStateNormal];
        [_btnUploadMaterialList setTitleColor:[UIColor colorFromHexString:@"#02AF00"] forState:UIControlStateNormal];
    }
    
    if (currentPage != page) {
        currentPage = page;
        lastPage = currentPage;
    }
}

-(NSMutableArray *)signFields
{
    NSMutableArray *basicInfos = [_basicDataVC returnBasicInfoList];
    NSMutableArray *uploadMaterials = [_uploadMaterialListVC returnMaterialList];
    NSMutableArray *signFieldList = [NSMutableArray array];
    if (basicInfos && basicInfos.count > 0) {
        for (BasicInfo *info in basicInfos) {
            if (info.isSign) {
                if (info.infoId) {
                    if (![signFieldList containsObject:info.infoId]) {
                        [signFieldList addObject:info.infoId];
                    }
                }
            }
        }
    }
    
    if (uploadMaterials && uploadMaterials.count > 0) {
        for (UploadMaterial *material in uploadMaterials) {
            if (material.childInfos && material.childInfos.count > 0) {
                for (BasicInfo *bInfo in material.childInfos) {
                    if (bInfo.isSign) {
                        if (bInfo.infoId) {
                            if (![signFieldList containsObject:bInfo.infoId]) {
                                [signFieldList addObject:bInfo.infoId];
                            }
                        }
                    }
                }
            }
        }
    }
    return signFieldList;
}

-(NSNumber *)returnCommitId
{
    return @(_item.itemId);
}

-(void)audit:(AuditStatus)status reason:(NSString *)reason commitId:(NSInteger)commitId canedit:(NSArray *)caneditList callback:(void(^)(BOOL flag))callback
{
    if (_item) {
        if (caneditList == nil) {
            caneditList = [NSArray array];
        }
       
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [AppUtils showHudProgress:@"请稍后..." ForView:self.view];
            [[viewModel audit:status reason:reason commitId:commitId canedit:caneditList] subscribeNext:^(id x) {
                NSDictionary *dataDic = (NSDictionary *)x;
                if (dataDic) {
                    NSInteger flag = [[dataDic objectForKey:@"flag"] integerValue];
                    if (flag == 1) {
                        callback(YES);
                    }else{
                        callback(NO);
                    }
                }
            } completed:^{
                [AppUtils hidenHudProgressForView:self.view];
            }];
        });
    }
}

-(void)audit:(AuditStatus)status reason:(NSString *)reason callback:(void(^)(BOOL flag))callback
{
    NSNumber *commitId = [self returnCommitId];
    NSArray *canedit = [self signFields];
    switch (status) {
        case Compeletely:
        {
            if (canedit && canedit.count > 0) {
                LGAlertView *alert = [LGAlertView alertViewWithTitle:nil message:@"还有标红字段，是否确认通过?" style:LGAlertViewStyleAlert buttonTitles:@[@"通过"] cancelButtonTitle:@"取消" destructiveButtonTitle:nil actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
                    [alertView setDidDismissHandler:^(LGAlertView *alertView) {
                        if (commitId && canedit) {
                            [self audit:status reason:reason commitId:[commitId integerValue] canedit:canedit callback:callback];
                        }
                    }];
                } cancelHandler:^(LGAlertView *alertView) {
                    
                } destructiveHandler:^(LGAlertView *alertView) {
                    
                }];
                
                [alert setLayerCornerRadius:3.0f];
                [alert setHeightMax:250.0f];
                [alert setCancelButtonTitleColor:[UIColor colorFromHexString:@"#808080"]];
                [alert setCancelButtonBackgroundColor:[UIColor whiteColor]];
                [alert setButtonsTitleColor:[UIColor colorFromHexString:@"#02AF00"]];
                [alert setButtonsBackgroundColor:[UIColor whiteColor]];
                [alert setMessageFont:[UIFont boldSystemFontOfSize:18.0f]];
                [alert showAnimated:YES completionHandler:^{
                    
                }];
            }else{
                if (commitId && canedit) {
                    [self audit:status reason:reason commitId:[commitId integerValue] canedit:canedit callback:callback];
                }
            }
            break;
        }
        case Reject:
        {
            
            break;
        }
        case Overruled:
        {
            if ([AppUtils isNullStr:reason]) {
                [AppUtils showInfo:@"请填写驳回原因"];
            }else{
                if (commitId && canedit) {
                    [self audit:status reason:reason commitId:[commitId integerValue] canedit:canedit callback:callback];
                }
            }
            break;
        }
        default:
            break;
    }
}
#pragma -mark ButtonEvent
-(IBAction)clickTabBtn:(UIButton *)sender
{
    [self setCurrentPage:sender.tag - 100];
}

//点击拒绝按钮
-(IBAction)clickRejectBtn:(id)sender
{
    LGAlertView *alert = [LGAlertView alertViewWithTitle:nil message:@"确定拒绝吗?" style:LGAlertViewStyleAlert buttonTitles:@[@"确定"] cancelButtonTitle:@"取消" destructiveButtonTitle:nil actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
        [alertView setDidDismissHandler:^(LGAlertView *alertView) {
            [self audit:Reject reason:nil callback:^(BOOL flag) {
                if (flag) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CheckDetails_ForkImage"]];
                        [AppUtils showInfo:@"审核已拒绝" WithIconView:iconImageView ForView:self.view];
                        _item.canEditable = NO;
                        if ([self.delegate respondsToSelector:@selector(checkItemDidChecked:)]) {
                            [self.delegate checkItemDidChecked:_item];
                        }
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }else{
                    [AppUtils showInfo:@"上传失败!"];
                }
            }];
        }];
    } cancelHandler:^(LGAlertView *alertView) {
        
    } destructiveHandler:^(LGAlertView *alertView) {
        
    }];
    
    [alert setLayerCornerRadius:3.0f];
    [alert setHeightMax:250.0f];
    [alert setCancelButtonTitleColor:[UIColor colorFromHexString:@"#808080"]];
    [alert setCancelButtonBackgroundColor:[UIColor whiteColor]];
    [alert setButtonsTitleColor:[UIColor colorFromHexString:@"#02AF00"]];
    [alert setButtonsBackgroundColor:[UIColor whiteColor]];
    [alert setMessageFont:[UIFont boldSystemFontOfSize:18.0f]];
    
    [alert showAnimated:YES completionHandler:^{
        
    }];
    
//    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"确定拒绝吗?" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        
//    }];
//    [alertVC addAction:cancelAction];
//    UIAlertAction *comfirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//    }];
//    [alertVC addAction:comfirmAction];
//    
//    [self presentViewController:alertVC animated:YES completion:^{
//        
//    }];
}

//点击通过按钮
-(IBAction)clickCompeletelyBtn:(id)sender
{
    LGAlertView *alert = [LGAlertView alertViewWithTitle:nil message:@"确定通过吗?" style:LGAlertViewStyleAlert buttonTitles:@[@"确定"] cancelButtonTitle:@"取消" destructiveButtonTitle:nil actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
        [alertView setDidDismissHandler:^(LGAlertView *alertView) {
            [self audit:Compeletely reason:nil callback:^(BOOL flag) {
                if (flag) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CheckDetails_TickImage"]];
                        [AppUtils showInfo:@"审核已通过" WithIconView:iconImageView ForView:self.view];
                        _item.canEditable = NO;
                        if ([self.delegate respondsToSelector:@selector(checkItemDidChecked:)]) {
                            [self.delegate checkItemDidChecked:_item];
                        }
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }else{
                    [AppUtils showInfo:@"上传失败!"];
                }
            }];
        }];
        
    } cancelHandler:^(LGAlertView *alertView) {
        
    } destructiveHandler:^(LGAlertView *alertView) {
        
    }];
    
    [alert setDidDismissHandler:^(LGAlertView *alertView) {
        
    }];
    
    [alert setLayerCornerRadius:3.0f];
    [alert setCancelButtonTitleColor:[UIColor colorFromHexString:@"#808080"]];
    [alert setCancelButtonBackgroundColor:[UIColor whiteColor]];
    [alert setButtonsTitleColor:[UIColor colorFromHexString:@"#02AF00"]];
    [alert setButtonsBackgroundColor:[UIColor whiteColor]];
    [alert setMessageFont:[UIFont boldSystemFontOfSize:18.0f]];
    
    [alert showAnimated:YES completionHandler:^{
        
    }];
}

//点击驳回按钮
-(IBAction)clickOverruledBtn:(id)sender
{
    NSArray *signedArray = [self signFields];
    if (signedArray == nil || signedArray.count == 0) {
        [AppUtils showInfo:@"请先标红错误项"];
        return;
    }
    GFTextView *textView = [[GFTextView alloc] initWithFrame:CGRectMake(0, 0, 250.0f, 100.0f)];
    [textView setIsShowBoundLine:YES];
    [textView setPlaceHolder:@"请输入驳回原因"];
    [textView setBoundLineColor:[UIColor colorFromHexString:@"#ECECEC"]];
    [textView setPlaceHolderFont:[UIFont systemFontOfSize:13.0f]];
    LGAlertView *alert = [LGAlertView alertViewWithViewAndTitle:@"审核驳回!" message:nil style:LGAlertViewStyleAlert view:textView buttonTitles:@[@"确定"] cancelButtonTitle:@"取消" destructiveButtonTitle:nil actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
        [alertView setDidDismissHandler:^(LGAlertView *alertView) {
            [self audit:Overruled reason:textView.text callback:^(BOOL flag) {
                if (flag) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CheckDetails_WarnImage"]];
                        [AppUtils showInfo:@"审核已驳回" WithIconView:iconImageView ForView:self.view];
                        _item.canEditable = NO;
                        if ([self.delegate respondsToSelector:@selector(checkItemDidChecked:)]) {
                            [self.delegate checkItemDidChecked:_item];
                        }
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }else{
                    [AppUtils showInfo:@"上传失败!"];
                }
            }];
        }];
    } cancelHandler:^(LGAlertView *alertView) {
        
    } destructiveHandler:^(LGAlertView *alertView) {
        
    }];
    
    [alert setLayerCornerRadius:3.0f];
    [alert setCancelButtonTitleColor:[UIColor colorFromHexString:@"#808080"]];
    [alert setCancelButtonBackgroundColor:[UIColor whiteColor]];
    [alert setButtonsTitleColor:[UIColor colorFromHexString:@"#02AF00"]];
    [alert setButtonsBackgroundColor:[UIColor whiteColor]];
    [alert setMessageFont:[UIFont boldSystemFontOfSize:18.0f]];
    
    [alert showAnimated:YES completionHandler:^{
        
    }];
}
#pragma -mark UIPageViewControllerDelegate |  UIPageViewControllerDataSource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[GFUploadMaterialListViewController class]]) {
        return _basicDataVC;
    }
    return nil;
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[GFBasicDataViewController class]]) {
        return _uploadMaterialListVC;
    }
    return nil;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed) {
        UIViewController *vc = [previousViewControllers lastObject];
        if ([vc isKindOfClass:[GFBasicDataViewController class]]) {
            [self changeViewController:1];
        }
        
        if ([vc isKindOfClass:[GFUploadMaterialListViewController class]]) {
            [self changeViewController:0];
        }
    }
}

#pragma -mark GFBasicInfoViewProtocol
-(void)loadBasicData:(void (^)(id data))callback
{
    if (_item) {
        [AppUtils showHudProgress:@"加载中..." ForView:self.view];
        [[viewModel requestBasicInfoSignal] subscribeNext:^(id x) {
            callback(x);
        } completed:^{
            [AppUtils hidenHudProgressForView:self.view];
        }];
    }
}

#pragma -mark GFUploadMaterialViewProtocol
-(void)loadUploadMaterialData:(void (^)(id))callback
{
    if (_item) {
        [AppUtils showHudProgress:@"加载中..." ForView:self.view];
        [[viewModel requestUploadMaterialInfoSignal] subscribeNext:^(id x) {
            callback(x);
        } completed:^{
            [AppUtils hidenHudProgressForView:self.view];
        }];
    }
}
@end
