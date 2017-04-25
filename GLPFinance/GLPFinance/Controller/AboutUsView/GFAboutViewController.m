//
//  GFAboutViewController.m
//  GLPFinance
//
//  Created by 鲍利成 on 2016/11/25.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import "GFAboutViewController.h"

@interface GFAboutViewController ()<UIWebViewDelegate>
{
    UIActivityIndicatorView *activityView;
}
@property(nonatomic, strong) IBOutlet UIWebView *webView;
@end

@implementation GFAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:ViewBackgroundMainColor];
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityView setOpaque:NO];
    [_webView addSubview:activityView];
    
    UIScrollView *scrollView = [self findScrollViewInWebView];
    if (scrollView) {
        [scrollView setShowsVerticalScrollIndicator:NO];
        [scrollView setShowsHorizontalScrollIndicator:NO];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self setTitle:@"关于我们"];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSString *url = @"http://www.glprop.com.cn/about-glp.html";
    NSString *encodeUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSString *encodeUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:encodeUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    [_webView loadRequest:request];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [activityView setCenter:_webView.center];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIScrollView *)findScrollViewInWebView
{
    UIScrollView *scrollView;
    for (UIView *view in _webView.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            scrollView = (UIScrollView *)view;
            break;
        }
    }
    return scrollView;
}


- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [activityView setOpaque:YES];
    [activityView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if ((title != nil) && (title.length > 0)) {
        [self setTitle:title];
    }
    [activityView setOpaque:NO];
    [activityView stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [activityView setOpaque:NO];
    [activityView stopAnimating];
    [AppUtils showInfo:@"加载失败"];
}
@end
