//
//  GFResetPasswordViewController.m
//  GLPFinance
//
//  Created by 鲍利成 on 2016/11/28.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import "GFResetPasswordViewController.h"
#import "GFResetPasswordViewModel.h"

@interface GFResetPasswordViewController ()<UITextFieldDelegate>
{
    GFResetPasswordViewModel *viewModel;
    
    NSInteger second;
    NSTimer *secondTimer;
}
@property(nonatomic, strong) IBOutlet UITextField *txtPhone;
@property(nonatomic, strong) IBOutlet UITextField *txtValidateCode;
@property(nonatomic, strong) IBOutlet UITextField *txtNewPassword;
@property(nonatomic, strong) IBOutlet UIButton *btnValidateCode;

@property(nonatomic, strong) IBOutlet UIButton *btnComfirm;
@end

@implementation GFResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_btnValidateCode.layer setCornerRadius:5.0f];
    [_btnValidateCode.layer setMasksToBounds:YES];
    
    [_btnComfirm.layer setCornerRadius:5.0f];
    [_btnComfirm.layer setMasksToBounds:YES];
    
    viewModel = [[GFResetPasswordViewModel alloc] init];
    RAC(_btnComfirm, enabled) = [viewModel comfirmButtonEnableSignal];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"UITextFieldTextDidChangeNotification" object:nil] subscribeNext:^(id x) {
        UITextField *textField = [x object];
        if ([textField isEqual:_txtPhone]) {
            viewModel.phone = textField.text;
        }
        
        if ([textField isEqual:_txtValidateCode]) {
            viewModel.validateCode = textField.text;
        }
        
        if ([textField isEqual:_txtNewPassword]) {
            viewModel.resetPassword = textField.text;
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
#pragma -mark private functions
-(void)beginTimer
{
    if (secondTimer) {
        if ([secondTimer isValid]) {
            [secondTimer invalidate];
        }
        secondTimer = nil;
    }
    
    second = 0;
    secondTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (second < 60) {
            [_btnValidateCode setEnabled:NO];
            [_btnValidateCode setTitle:[NSString stringWithFormat:@"还剩%lds",(long)(60 - second)] forState:UIControlStateNormal];
        }else{
            [_btnValidateCode setEnabled:YES];
            [_btnValidateCode setTitle:@"获取验证码" forState:UIControlStateNormal];
            if (timer) {
                if ([timer isValid]) {
                    [timer invalidate];
                }
            }
        }
        second++;
        
    }];
    
    [[NSRunLoop currentRunLoop] addTimer:secondTimer forMode:NSRunLoopCommonModes];
}

#pragma -mark textFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

#pragma -mark ButtonEvent
-(IBAction)clickComfirmBtn:(id)sender
{
    [AppUtils showHudProgress:@"请稍后..." ForView:self.view];
    [[viewModel resetPasswordSignal] subscribeNext:^(id x) {
        if ([x boolValue]) {
            if ([self.delegate respondsToSelector:@selector(resetPasswordSuccess)]) {
                [self.delegate resetPasswordSuccess];
            }
        }
    } error:^(NSError *error) {
        
    } completed:^{
        [AppUtils hidenHudProgressForView:self.view];
    }];
}

-(IBAction)clickValidateCodeBtn:(id)sender
{
    if ([viewModel codeBtnValidate]) {
        [[viewModel validateCodeSignal] subscribeNext:^(id x) {
            if ([x boolValue]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self beginTimer];
                });
            }
        } error:^(NSError *error) {
            
        } completed:^{
            
        }];
    }
}
@end
