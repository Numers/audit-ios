//
//  GFLoginViewController.m
//  GLPFinance
//
//  Created by 鲍利成 on 2016/11/23.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import "GFLoginViewController.h"
#import "GFLoginViewModel.h"
#import "Member.h"
#import "AppStartManager.h"

@interface GFLoginViewController ()<UITextFieldDelegate>
{
    GFLoginViewModel *viewModel;
}
@property(nonatomic, strong) IBOutlet UITextField *txtPhone;
@property(nonatomic, strong) IBOutlet UITextField *txtPassword;
@property(nonatomic, strong) IBOutlet UIButton *btnLogin;
@end

@implementation GFLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:ViewBackgroundColor];
    [_btnLogin.layer setCornerRadius:5.0f];
    [_btnLogin.layer setMasksToBounds:YES];
    
    viewModel = [[GFLoginViewModel alloc] init];
    RAC(_btnLogin,enabled) = [viewModel LoginButtonEnableSignal];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"UITextFieldTextDidChangeNotification" object:nil] subscribeNext:^(id x) {
        UITextField *textField = [x object];
        if ([textField isEqual:_txtPhone]) {
            viewModel.phone = _txtPhone.text;
        }
        
        if ([textField isEqual:_txtPassword]) {
            viewModel.password = _txtPassword.text;
        }
    }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark ToucheViewEvent
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([_txtPhone isFirstResponder]) {
        [_txtPhone resignFirstResponder];
    }
    
    if ([_txtPassword isFirstResponder]) {
        [_txtPassword resignFirstResponder];
    }
}

#pragma -mark textFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}
#pragma -mark ButtonEvent
-(IBAction)clickLoginBtn:(id)sender
{
    if ([viewModel validateData:_txtPhone.text password:_txtPassword.text]) {
        [AppUtils showHudProgress:@"登陆中..." ForView:self.view];
        [[viewModel login] subscribeNext:^(id x) {
            if (x != nil) {
                NSDictionary *dataDic = (NSDictionary *)x;
                Member *member = [[Member alloc] init];
                member.phone = [dataDic objectForKey:@"account"];
                member.company = [dataDic objectForKey:@"company"];
                member.role = (PlatformType)[[dataDic objectForKey:@"role"] integerValue];
                member.name = [dataDic objectForKey:@"name"];
                member.headIcon = [dataDic objectForKey:@"image_url"];
                member.token = [dataDic objectForKey:@"token"];
                member.type = (UserType)[[dataDic objectForKey:@"type"] integerValue];
                [[AppStartManager shareManager] setMember:member];
                [AppUtils localUserDefaultsValue:@"1" forKey:KMY_AutoLogin];
                if ([self.delegate respondsToSelector:@selector(loginSuccess)]) {
                    [self.delegate loginSuccess];
                }
            }
        } error:^(NSError *error) {
            [AppUtils hidenHudProgressForView:self.view];
        } completed:^{
            [AppUtils hidenHudProgressForView:self.view];
        }];
    }
}

-(IBAction)clickForgetPasswordBtn:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(forgetPassword)]) {
        [self.delegate forgetPassword];
    }
}
@end
