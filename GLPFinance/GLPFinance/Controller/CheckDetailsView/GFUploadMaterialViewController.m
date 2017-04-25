//
//  GFUploadMaterialViewController.m
//  GLPFinance
//
//  Created by 鲍利成 on 2016/11/29.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import "GFUploadMaterialViewController.h"
#import "GFUploadMaterialCollectionViewCell/GFUploadMaterialCollectionViewCell.h"
#import "BasicInfo.h"

static NSString *collectionViewCellIdentify = @"UploadMaterialCollectionViewCellIdentify";
@interface GFUploadMaterialViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
{
    NSInteger currentPage;
}
@property(nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property(nonatomic, strong) IBOutlet UIButton *btnSign;
@property(nonatomic, strong) IBOutlet UIButton *btnNext;
@end

@implementation GFUploadMaterialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:ViewBackgroundMainColor];
    
    [_collectionView registerClass:[GFUploadMaterialCollectionViewCell class] forCellWithReuseIdentifier:collectionViewCellIdentify];
    [self setCurrentPage:0];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(clickRefreshItem)];
    [self.navigationItem setRightBarButtonItem:rightItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark private funcitons
-(void)setDetailsMaterials:(NSMutableArray *)detailsMaterials
{
    if (_detailsMaterials) {
        [_detailsMaterials removeAllObjects];
    }else{
        _detailsMaterials = [NSMutableArray array];
    }
    [_detailsMaterials addObjectsFromArray:detailsMaterials];
}

-(void)setCurrentPage:(NSInteger)page
{
    currentPage = page;
    BasicInfo *info = [_detailsMaterials objectAtIndex:page];
    self.title = info.fieldName;
    if (info.isSign) {
        [_btnSign setTitle:@"取消" forState:UIControlStateNormal];
    }else{
        [_btnSign setTitle:@"标记" forState:UIControlStateNormal];
    }
    
    if (currentPage < (_detailsMaterials.count - 1)) {
        [_btnNext setEnabled:YES];
        [_btnNext setBackgroundColor:[UIColor colorFromHexString:@"#02AF00"]];
    }else{
        [_btnNext setEnabled:NO];
        [_btnNext setBackgroundColor:[UIColor colorFromHexString:@"#C9C9C9"]];
    }
}
#pragma -mark UIButtonEvent
-(IBAction)clickSignBtn:(id)sender
{
    BasicInfo *info = [_detailsMaterials objectAtIndex:currentPage];
    if (info.isSign) {
        info.isSign = NO;
    }else{
        info.isSign = YES;
    }
    
    [self setCurrentPage:currentPage];
}

-(IBAction)clickNextBtn:(id)sender
{
    if (_detailsMaterials && _detailsMaterials.count > 0) {
        if (currentPage < (_detailsMaterials.count - 1)) {
            [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:currentPage + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
            NSInteger tempPage = currentPage + 1;
            [self setCurrentPage:tempPage];
        }
    }
}

-(void)clickRefreshItem
{
    BasicInfo *info = [_detailsMaterials objectAtIndex:currentPage];
    GFUploadMaterialCollectionViewCell *cell = (GFUploadMaterialCollectionViewCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:currentPage inSection:0]];
    if (cell) {
        [cell loadMaterial:info.userVal];
    }
}
#pragma -mark ScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    for (UIView *view in _collectionView.subviews) {
        if ([view isKindOfClass:[GFUploadMaterialCollectionViewCell class]]) {
            GFUploadMaterialCollectionViewCell *cell = (GFUploadMaterialCollectionViewCell *)view;
            [cell.contentScrollView setZoomScale:1.0f];
        }
    }
    
    NSArray *visibleIndexPaths = [_collectionView indexPathsForVisibleItems];
    if (visibleIndexPaths && visibleIndexPaths.count > 0) {
        NSIndexPath *indexPath = [visibleIndexPaths lastObject];
        [self setCurrentPage:indexPath.item];
    }
}

#pragma -mark UICollectionViewDelegateFlowLayout | UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _detailsMaterials.count;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GFUploadMaterialCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellIdentify forIndexPath:indexPath];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BasicInfo *info = [_detailsMaterials objectAtIndex:indexPath.item];
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell loadMaterial:info.userVal];
        });
    });
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
