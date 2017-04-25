//
//  GFCheckListViewController.m
//  GLPFinance
//
//  Created by 鲍利成 on 2016/11/24.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import "GFCheckListViewController.h"
#import "UIColor+HexString.h"
#import "PopoverView.h"
#import "MJRefresh.h"
#import "GFCheckListViewModel.h"
#import "CheckItem.h"

#import "GFCheckDetailsViewController.h"
#define DefaultPageSize 10

@interface GFCheckListViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,GFCheckDetailsViewProtocol>
{
    PopoverView *popoverView;
    NSArray *popoverTitle;
    
    NSInteger currentPage;
    NSInteger currentPlatformIndex;
    
    NSMutableArray *requestDataList;
    NSMutableArray *dataSourceList;
    
    GFCheckListViewModel *viewModel;
}
@property(nonatomic, strong) IBOutlet UIView *searchBarBackView;
@property(nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property(nonatomic, strong) IBOutlet UITableView *tableView;
@property(nonatomic, strong) IBOutlet UIButton *btnCombox;
@end

@implementation GFCheckListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:ViewBackgroundMainColor];
    // Do any additional setup after loading the view.
    //searchBar边框背景view
    [_searchBarBackView setBackgroundColor:[UIColor colorFromHexString:@"#7cd27b"]];
    [_searchBarBackView.layer setCornerRadius:13.0f];
    [_searchBarBackView.layer setMasksToBounds:YES];
    //SearchBar 设置
    UITextField * searchField = [_searchBar valueForKey:@"_searchField"];
    //输入字体颜色
    [searchField setTextColor:[UIColor whiteColor]];
    //placeholder字体
    [searchField setValue:[UIColor colorFromHexString:@"#b2e1b1"] forKeyPath:@"_placeholderLabel.textColor"];
    [searchField setValue:[UIFont systemFontOfSize:13.0f] forKeyPath:@"_placeholderLabel.font"];
    //设置背景
    [_searchBar.layer setMasksToBounds:YES];
    [_searchBar.layer setCornerRadius:13.0f];
    [_searchBar setBackgroundColor:[UIColor colorFromHexString:@"#42bf3f"]];
    [_searchBar setSearchFieldBackgroundImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    _searchBar.delegate = self;
    //设置光标颜色
    [_searchBar setTintColor:[UIColor colorWithWhite:1.0f alpha:0.7f]];
    
    //设置搜索图标Icon
    [_searchBar setImage:[UIImage imageNamed:@"CheckList_Search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    //popoverView显示的title
    currentPlatformIndex = 1;
    popoverTitle = @[@"全部",@"运力",@"设备",@"平台"];
    [self setComboxBtn:[popoverTitle objectAtIndex:currentPlatformIndex] IsDown:YES];
    
    [self tableViewRefreshSetting];
    [self inilizedData];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma -mark Private Functions
-(void)inilizedData
{
    currentPage = 1;
    if (dataSourceList) {
        [dataSourceList removeAllObjects];
    }else{
        dataSourceList = [NSMutableArray array];
    }
    
    if (requestDataList) {
        [requestDataList removeAllObjects];
    }else{
        requestDataList = [NSMutableArray array];
    }
    
    if (viewModel == nil) {
        viewModel = [[GFCheckListViewModel alloc] init];
    }
    
    [_tableView.mj_footer resetNoMoreData];
}

-(void)tableViewRefreshSetting
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self inilizedData];
        [self loadData];
    }];
    [header setTitle:@"下拉可以刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新数据中..." forState:MJRefreshStateRefreshing];
    _tableView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        currentPage++;
        [self loadData];
    }];
    [footer setTitle:@"点击或上拉加载更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"已经全部加载完毕" forState:MJRefreshStateNoMoreData];
    _tableView.mj_footer = footer;
    
    [_tableView setTableFooterView:[UIView new]];
}

-(void)loadData
{
    if (currentPage == 1) {
        [AppUtils showHudProgress:@"加载中..." ForView:self.view];
    }else{
        if (requestDataList.count == 0) {
            currentPage = 1;
        }
    }
    
    NSMutableDictionary *filterDic = nil;
    if (currentPlatformIndex != 0) {
        if (filterDic == nil) {
            filterDic = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInteger:currentPlatformIndex] forKey:@"type"];
        }else{
            [filterDic setObject:[NSNumber numberWithInteger:currentPlatformIndex] forKey:@"type"];
        }
    }
    
    if (![AppUtils isNullStr:_searchBar.text]) {
        if (filterDic == nil) {
            filterDic = [NSMutableDictionary dictionaryWithObject:_searchBar.text forKey:@"content"];
        }else{
            [filterDic setObject:_searchBar.text forKey:@"content"];
        }
    }
    [[viewModel checkListWithPageNum:currentPage WithPageSize:DefaultPageSize WithFilterCondition:filterDic] subscribeNext:^(id x) {
        if (x != nil) {
            NSDictionary *dataDic = (NSDictionary *)x;
            
            NSArray *dataArr = [dataDic objectForKey:@"data"];
            if (dataArr) {
                for (NSDictionary *dic in dataArr) {
                    CheckItem *item = [[CheckItem alloc] initWithDictionary:dic];
                    item.pid = currentPlatformIndex;
                    [requestDataList addObject:item];
                    [dataSourceList addObject:item];
                }
            }
            
            NSInteger allCount = [[dataDic objectForKey:@"count"] integerValue];
            if (requestDataList.count >= allCount) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }else{
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.tableView reloadData];
    } completed:^{
        if (currentPage == 1) {
            [AppUtils hidenHudProgressForView:self.view];
        }
        
        if ([_tableView.mj_header isRefreshing]) {
            [_tableView.mj_header endRefreshing];
        }
        
        if ([_tableView.mj_footer isRefreshing]) {
            [_tableView.mj_footer endRefreshing];
        }
    }];
}

-(NSArray *)popoverTitles
{
    return popoverTitle;
}

-(void)setComboxBtn:(NSString *)title IsDown:(BOOL)isDown
{
    if (title) {
        [_btnCombox setTitle:title forState:UIControlStateNormal];
    }
    
    if (isDown) {
        [_btnCombox setImage:[UIImage imageNamed:@"CheckList_Combox_Down"] forState:UIControlStateNormal];
    }else{
        [_btnCombox setImage:[UIImage imageNamed:@"CheckList_Combox_Up"] forState:UIControlStateNormal];
    }
}

-(NSArray *)filterArrayWithName:(NSString *)name
{
    if ([AppUtils isNullStr:name]) {
        return requestDataList;
    }
    
    if (requestDataList && requestDataList.count > 0) {
        NSString *predicateString = [NSString stringWithFormat:@"SELF.name CONTAINS '%@'",name];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
        NSArray *filterArray = [requestDataList filteredArrayUsingPredicate:predicate];
        if (filterArray) {
            return filterArray;
        }else{
            return [NSArray array];
        }
    }
    return [NSArray array];
}
#pragma -mark ButtonEvent
-(IBAction)clickComboxBtn:(UIButton *)sender
{
    if(popoverView != nil)
    {
        [popoverView removeFromSuperview];
        popoverView = nil;
    }
    
    CGPoint point = CGPointMake(sender.frame.origin.x + sender.frame.size.width/2, sender.frame.origin.y + sender.frame.size.height);
    popoverView = [[PopoverView alloc] initWithPoint:point titles:popoverTitle images:nil];
    
    __weak __typeof(self) weakSelf = self;
    [popoverView setSelectRowAtIndex:^(NSInteger index) {
        [weakSelf setComboxBtn:[[weakSelf popoverTitles] objectAtIndex:index] IsDown:YES];
        if (currentPlatformIndex == index) {
            return ;
        }
        currentPlatformIndex = index;
        [weakSelf inilizedData];
        [weakSelf loadData];
//        switch (index) {
//            case 0:
//            {
//                
//            }
//                break;
//            case 1:
//            {
//                
//            }
//                break;
//            case 2:
//            {
//                
//            }
//                break;
//            case 3:
//            {
//                
//            }
//                break;
//                
//            default:
//                break;
//        }
    }];
    
    [popoverView setDismissView:^(BOOL completely) {
        [weakSelf setComboxBtn:nil IsDown:YES];
    }];
    
    [popoverView show];
    [self setComboxBtn:nil IsDown:NO];

}


-(IBAction)clickSearchBtn:(id)sender
{
    [self inilizedData];
    [self loadData];
    if ([_searchBar isFirstResponder]) {
        [_searchBar resignFirstResponder];
    }
}
#pragma -mark SearchBar BackgroundImage
-(UIImage*) imageWithColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 44.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma -mark UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSArray *filterArray = [self filterArrayWithName:searchText];
//        if (dataSourceList) {
//            [dataSourceList removeAllObjects];
//            dataSourceList = nil;
//        }
//        dataSourceList = [NSMutableArray arrayWithArray:filterArray];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.tableView reloadData];
//        });
//    });
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self inilizedData];
    [self loadData];
    if ([searchBar isFirstResponder]) {
        [searchBar resignFirstResponder];
    }
}

#pragma -mark UITableViewDelegate | UITableViewDataSource
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([_searchBar isFirstResponder]) {
        [_searchBar resignFirstResponder];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSourceList.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CheckListCellIdentify" forIndexPath:indexPath];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CheckItem *item = [dataSourceList objectAtIndex:indexPath.row];
        dispatch_async(dispatch_get_main_queue(), ^{
            UILabel *lblName = [cell viewWithTag:1];
            [lblName setText:item.name];
            
            UILabel *lblManagerName = [cell viewWithTag:2];
            [lblManagerName setText:item.managerName];
            
            UILabel *lblMoney = [cell viewWithTag:3];
            [lblMoney setText:[NSString stringWithFormat:@"%.2f",item.money]];
            
            UILabel *lblTime = [cell viewWithTag:4];
            [lblTime setNumberOfLines:2];
            NSString *timeStr = [viewModel dateStrFromTime:item.time];
            NSMutableAttributedString *attrStr = [AppUtils generateAttriuteStringWithStr:timeStr WithColor:[UIColor colorFromHexString:@"#808080"] WithFont:[UIFont systemFontOfSize:13.0f]];
            [lblTime setAttributedText:attrStr];
        });
    });
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CheckItem *item = [dataSourceList objectAtIndex:indexPath.row];
    if (!item.canEditable) {
        [AppUtils showInfo:@"该项目已审核"];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(pushCheckDetailsViewWithCheckItem:)]) {
        [self.delegate pushCheckDetailsViewWithCheckItem:item];
    }
}

#pragma -mark GFCheckDetailsViewProtocol
-(void)checkItemDidChecked:(CheckItem *)item
{
    if ([dataSourceList containsObject:item]) {
        NSInteger index = [dataSourceList indexOfObject:item];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [dataSourceList removeObject:item];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}
@end
