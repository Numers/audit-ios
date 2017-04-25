//
//  GFFeedbackViewController.m
//  GLPFinance
//
//  Created by 鲍利成 on 2016/11/25.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import "GFFeedbackViewController.h"
#import "GFTextView.h"
#import "GFFeedbackViewModel.h"

@interface GFFeedbackViewController ()<UITextFieldDelegate>
{
    GFFeedbackViewModel *viewModel;
}
@property(nonatomic, strong) IBOutlet UITextField *txtMail;
@property(nonatomic, strong) IBOutlet GFTextView *feedbackContent;
@property(nonatomic, strong) IBOutlet UIButton *btnSubmit;
@end

@implementation GFFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:ViewBackgroundMainColor];
    
    [_btnSubmit.layer setCornerRadius:5.f];
    [_btnSubmit.layer setMasksToBounds:YES];
    [_feedbackContent setPlaceHolder:@"描述问题、吐槽或对产品的建议..."];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName,[UIColor colorWithRed:179/255.0f green:179/255.0f blue:179/255.0f alpha:1.0f],NSForegroundColorAttributeName, nil];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"请输入邮箱" attributes:dic];
    [_txtMail setAttributedPlaceholder:attr];
    _txtMail.delegate = self;
    
    viewModel = [[GFFeedbackViewModel alloc] init];
    RAC(_btnSubmit,enabled) = [viewModel comfirmButtonEnableSignal];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"UITextFieldTextDidChangeNotification" object:nil] subscribeNext:^(id x) {
        UITextField *textField = [x object];
        if ([textField isEqual:_txtMail]) {
            viewModel.email = textField.text;
        }
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UITextViewTextDidChangeNotification object:nil] subscribeNext:^(id x) {
        UITextView *textView = [x object];
        if ([textView isEqual:[_feedbackContent textView]]) {
            viewModel.content = textView.text;
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    self.title = @"反馈我们";
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_feedbackContent inilizedView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark UIButtonEvent
-(IBAction)clickSubmitBtn:(id)sender
{
    if ([viewModel validateData:_txtMail.text content:_feedbackContent.text]) {
        [AppUtils showHudProgress:@"请稍后..." ForView:self.view];
        [[viewModel submitFeedbackSignal] subscribeNext:^(id x) {
            if ([x boolValue]) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        } completed:^{
            [AppUtils hidenHudProgressForView:self.view];
        }];
    }
}

#pragma -mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

#pragma -mark UITouchEvent
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([_txtMail isFirstResponder]) {
        [_txtMail resignFirstResponder];
    }
    
    if ([[_feedbackContent textView] isFirstResponder]) {
        [[_feedbackContent textView] resignFirstResponder];
    }
}
@end
