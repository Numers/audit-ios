//
//  GFUploadMaterialListViewController.m
//  GLPFinance
//
//  Created by 鲍利成 on 2016/11/28.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import "GFUploadMaterialListViewController.h"
#import "GFUploadMaterialViewController.h"
#import "UploadMaterial.h"
static NSString *cellIdentify = @"UploadMaterialListTableViewCellIdentify";
@interface GFUploadMaterialListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *materials;
}
@property(nonatomic, strong) IBOutlet UITableView *tableView;
@property(nonatomic, strong) IBOutlet UIButton *btnRefresh;
@end

@implementation GFUploadMaterialListViewController

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
    
    materials = [NSMutableArray array];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark private functions
-(void)loadData
{
    if ([self.delegate respondsToSelector:@selector(loadUploadMaterialData:)]) {
        [self.delegate loadUploadMaterialData:^(id data) {
            NSArray *dataArr = (NSArray *)data;
            if (dataArr) {
                for (NSDictionary *dic in dataArr) {
                    UploadMaterial *info = [[UploadMaterial alloc] initWithDictionary:dic];
                    [materials addObject:info];
                }
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

-(NSMutableArray *)returnMaterialList
{
    return materials;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return materials.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    }
    UploadMaterial *material = [materials objectAtIndex:indexPath.row];
    cell.textLabel.text = material.basicInfo.fieldName;
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UploadMaterial *material = [materials objectAtIndex:indexPath.row];
    GFUploadMaterialViewController *uploadMaterialVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GFUploadMaterialViewIdentify"];
    [uploadMaterialVC setDetailsMaterials:material.childInfos];
    [self.navigationController pushViewController:uploadMaterialVC animated:YES];
}

@end
