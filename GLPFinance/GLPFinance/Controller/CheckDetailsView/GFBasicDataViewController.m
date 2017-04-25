//
//  GFBasicDataViewController.m
//  GLPFinance
//
//  Created by 鲍利成 on 2016/11/28.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import "GFBasicDataViewController.h"
#import "BasicInfo.h"
#import "LGAlertView.h"

static NSString *cellIdentify = @"BasicDataTableViewCellIdentify";
@interface GFBasicDataViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *basicInfoList;
    NSMutableArray *titleInfoList;
    NSMutableArray *dataInfoList;
}
@property(nonatomic, strong) IBOutlet UITableView *tableView;
@property(nonatomic, strong) IBOutlet UIButton *btnRefresh;
@end

@implementation GFBasicDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:ViewBackgroundMainColor];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self.tableView setTableFooterView:[UIView new]];
    
    basicInfoList = [NSMutableArray array];
    titleInfoList = [NSMutableArray array];
    dataInfoList = [NSMutableArray array];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark private functions
-(void)loadData
{
    if ([self.delegate respondsToSelector:@selector(loadBasicData:)]) {
        [self.delegate loadBasicData:^(id data) {
            NSArray *dataArr = (NSArray *)data;
            if (dataArr) {
                for (NSDictionary *dic in dataArr) {
                    BasicInfo *info = [[BasicInfo alloc] initWithDictionary:dic];
                    if ([@"1" isEqualToString:info.display]) {
                        [basicInfoList addObject:info];
                    }
                }
                
                [self filterBaseInfoList];
                [self.btnRefresh setHidden:YES];
                [self.tableView setHidden:NO];
                [self.tableView reloadData];
            }else{
                [self.btnRefresh setHidden:NO];
                [self.tableView setHidden:YES];
            }
        }];
    }
}

-(NSMutableArray *)returnBasicInfoList
{
    return basicInfoList;
}

-(void)filterBaseInfoList
{
    if (basicInfoList && basicInfoList.count > 0) {
        BasicInfo *firstObj = [basicInfoList firstObject];
        if (![@"fieldseg" isEqualToString:firstObj.field]) {
            [titleInfoList addObject:@"基本信息"];
        }
        NSMutableArray *subArr = [NSMutableArray array];
        BOOL isSameSection = YES;
        for (BasicInfo *info in basicInfoList) {
            if ([@"fieldseg" isEqualToString:info.field]) {
                [titleInfoList addObject:[NSString stringWithFormat:@"    %@",info.fieldName]];
                if (![info isEqual:firstObj]) {
                    if (!isSameSection) {
                        [dataInfoList addObject:@[]];
                    }
                    isSameSection = NO;
                }
            }else{
                if (!isSameSection) {
                    [dataInfoList addObject:subArr];
                    subArr = nil;
                    subArr = [NSMutableArray array];
                    isSameSection = YES;
                }
                [subArr addObject:info];
            }
        }
        [dataInfoList addObject:subArr];
    }
}
#pragma -mark UIButtonEvent
-(IBAction)clickRefreshBtn:(id)sender
{
    [self loadData];
}

#pragma -mark UITableViewDelegate | UITableViewDataSource
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

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
//    BasicInfo *info = [basicInfoList objectAtIndex:indexPath.row];
//    if ([@"fieldseg" isEqualToString:info.field]) {
//        return NO;
//    }
    NSArray *dataArr = [dataInfoList objectAtIndex:indexPath.section];
    BasicInfo *info = [dataArr objectAtIndex:indexPath.row];
    if (info.canSign) {
        return YES;
    }
    return NO;
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *dataArr = [dataInfoList objectAtIndex:indexPath.section];
    BasicInfo *info = [dataArr objectAtIndex:indexPath.row];
    if (info.isSign) {
        UITableViewRowAction *cancelAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"取消" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            [tableView setEditing:NO];
            info.isSign = NO;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
        [cancelAction setBackgroundColor:[UIColor colorFromHexString:@"#d9d9d9"]];
        return @[cancelAction];
    }else{
        UITableViewRowAction *signAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"标红" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            [tableView setEditing:NO];
            info.isSign = YES;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
        [signAction setBackgroundColor:[UIColor colorFromHexString:@"#f93c37"]];
        return @[signAction];
    }
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *infoList = [dataInfoList objectAtIndex:section];
    return infoList.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return titleInfoList.count;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = [titleInfoList objectAtIndex:section];
    return title;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentify];
    }
    NSArray *dataArr = [dataInfoList objectAtIndex:indexPath.section];
    BasicInfo *info = [dataArr objectAtIndex:indexPath.row];
    cell.textLabel.text = [AppUtils isNullStr:info.fieldName] ? @"":info.fieldName;
    cell.detailTextLabel.text = [AppUtils isNullStr:info.userVal] ? @"":info.userVal;
    if ([@"fieldseg" isEqualToString:info.field]) {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }else{
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    if (info.isSign) {
        [cell.textLabel setTextColor:[UIColor redColor]];
        [cell.contentView setBackgroundColor:[UIColor colorFromHexString:@"#f7f7f7"]];
    }else{
        [cell.textLabel setTextColor:[UIColor blackColor]];
        [cell.contentView setBackgroundColor:[UIColor whiteColor]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *dataArr = [dataInfoList objectAtIndex:indexPath.section];
    BasicInfo *info = [dataArr objectAtIndex:indexPath.row];
    if ([@"fieldseg" isEqualToString:info.field]) {
        return;
    }
    
    NSString *btnTitle = nil;
    if (info.isSign) {
        btnTitle = @"取消标红";
    }else{
        btnTitle = @"标红";
    }
    LGAlertView *alert = [LGAlertView alertViewWithTitle:info.fieldName message:info.userVal style:LGAlertViewStyleAlert buttonTitles:@[btnTitle] cancelButtonTitle:@"取消" destructiveButtonTitle:nil actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
        info.isSign = !info.isSign;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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
}

@end
