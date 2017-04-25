//
//  GFPersonalCenterViewController.m
//  GLPFinance
//
//  Created by 鲍利成 on 2016/11/24.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import "GFPersonalCenterViewController.h"
#import "GFUserCenterHead/GFHeadImageView.h"
#import "CExpandHeader.h"
#import "Member.h"
#import "AppStartManager.h"
#import "GFPersonalCenterViewModel.h"

@interface GFPersonalCenterViewController ()<GFHeadImageViewDelegate,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    GFHeadImageView *headImageView;
    CExpandHeader *exPandHeader;
    
    NSArray *cellIcons;
    NSArray *cellNames;
    
    GFPersonalCenterViewModel *viewModel;
}
@property(nonatomic, strong) IBOutlet UITableView *tableView;
@end

@implementation GFPersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:ViewBackgroundMainColor];
    // Do any additional setup after loading the view.
    headImageView = [[GFHeadImageView alloc] initWithFrame:CGRectMake(0, 0, GDeviceWidth, (GDeviceWidth*304.0f/750.0f))];
    headImageView.delegate = self;
    exPandHeader = [CExpandHeader expandWithScrollView:self.tableView expandView:headImageView];
    
    cellIcons = @[@"PersonalCenter_Password",@"PersonalCenter_Feedback",@"PersonalCenter_About"];
    cellNames = @[@"修改密码",@"意见反馈",@"关于我们"];
    Member *host = [[AppStartManager shareManager] currentMember];
    if (host) {
        [headImageView setupWithMember:host];
    }
    
    viewModel = [[GFPersonalCenterViewModel alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark UITableViewDelegate | UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
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
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 1;
            break;
        default:
            break;
    }
    return 0;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCenterCellIdentify" forIndexPath:indexPath];
            UIImageView *imageView = [cell viewWithTag:1];
            [imageView setImage:[UIImage imageNamed:[cellIcons objectAtIndex:0]]];
            UILabel *label = [cell viewWithTag:2];
            [label setText:[cellNames objectAtIndex:0]];
            return cell;
            break;
        }
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCenterCellIdentify" forIndexPath:indexPath];
                    UIImageView *imageView = [cell viewWithTag:1];
                    [imageView setImage:[UIImage imageNamed:[cellIcons objectAtIndex:1]]];
                    UILabel *label = [cell viewWithTag:2];
                    [label setText:[cellNames objectAtIndex:1]];
                    return cell;
                    break;
                }
                case 1:
                {
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCenterCellIdentify" forIndexPath:indexPath];
                    UIImageView *imageView = [cell viewWithTag:1];
                    [imageView setImage:[UIImage imageNamed:[cellIcons objectAtIndex:2]]];
                    UILabel *label = [cell viewWithTag:2];
                    [label setText:[cellNames objectAtIndex:2]];
                    return cell;
                    break;
                }
                    
                default:
                    break;
            }
            
            break;
        }
        case 2:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"loginoutCell"];
            [cell.textLabel setText:@"安全退出"];
            [cell.textLabel setTextColor:[UIColor colorFromHexString:@"#333333"]];
            [cell.textLabel setFont:[UIFont systemFontOfSize:15.0f]];
            [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
            return cell;
            break;
        }
        default:
            break;
    }
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
        {
            if ([self.delegate respondsToSelector:@selector(modifyPassword)]) {
                [self.delegate modifyPassword];
            }
            break;
        }
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    if ([self.delegate respondsToSelector:@selector(feedback)]) {
                        [self.delegate feedback];
                    }
                    break;
                }
                case 1:
                {
                    if ([self.delegate respondsToSelector:@selector(aboutus)]) {
                        [self.delegate aboutus];
                    }
                    break;
                }
                    
                default:
                    break;
            }
            
            break;
        }
        case 2:
        {
            UIActionSheet *as=[[UIActionSheet alloc]initWithTitle:@"退出后不会删除任何历史数据,下次登录依然可以使用本账号" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出登录" otherButtonTitles:nil, nil];
            [as setTag:2];
            [as showInView:self.view];
            break;
        }
        default:
            break;
    }
    
}

#pragma -mark  GFHeadImageViewDelegate
-(void)clickHeadButton
{
    UIActionSheet *as=[[UIActionSheet alloc]initWithTitle:@"上传头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"马上照一张" otherButtonTitles:@"从相册中取一张", nil ];
    [as setTag:1];
    [as showInView:self.view];
}

#pragma mark ----------ActionSheet 按钮点击-------------
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"用户点击的是第%ld个按钮",(long)buttonIndex);
    switch (actionSheet.tag) {
        case 1:
        {
            switch (buttonIndex) {
                case 0:
                    //照一张
                {
                    UIImagePickerController *imgPicker=[[UIImagePickerController alloc]init];
                    [imgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
                    [imgPicker setDelegate:self];
                    [imgPicker setAllowsEditing:YES];
                    [self.navigationController presentViewController:imgPicker animated:YES completion:^{
                    }];
                }
                    break;
                case 1:
                    //搞一张
                {
                    UIImagePickerController *imgPicker=[[UIImagePickerController alloc]init];
                    [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                    [imgPicker setDelegate:self];
                    [imgPicker setAllowsEditing:YES];
                    [self presentViewController:imgPicker animated:YES completion:^{
                    }];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 2:
        {
            switch (buttonIndex) {
                case 0:
                {
                    if ([self.delegate respondsToSelector:@selector(loginout)]) {
                        [self.delegate loginout];
                    }
                }
                    break;
                default:
                    break;
            }
            
        }
            break;
        default:
            break;
    }
}

#pragma mark ----------图片选择完成-------------
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage  * userHeadImage= [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [AppUtils showHudProgress:@"请稍后..." ForView:self.view];
        [[viewModel uploadImageSignal:userHeadImage] subscribeNext:^(id x) {
            if (x) {
                NSString *url = x;
                [[viewModel resetHeadImage:url] subscribeNext:^(id x) {
                    if ([x boolValue]) {
                        Member *host = [[AppStartManager shareManager] currentMember];
                        if (host) {
                            host.headIcon = url;
                            [[AppStartManager shareManager] setMember:host];
                            [headImageView setupWithMember:host];
                        }
                    }
                } completed:^{
                    [AppUtils hidenHudProgressForView:self.view];
                }];
            }else{
                [AppUtils hidenHudProgressForView:self.view];
            }
        } completed:^{
            
        }];
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
        //
    }];
}

@end
