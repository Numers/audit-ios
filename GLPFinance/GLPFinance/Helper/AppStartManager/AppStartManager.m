//
//  AppStartManager.m
//  GLPFinance
//
//  Created by 鲍利成 on 2016/11/23.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import "AppStartManager.h"
#import "AppDelegate.h"
#import "GFGeneralManager.h"

#import "GFLoginScrollViewController.h"
#import "GFHomeViewController.h"
#import "UINavigationController+NavigationBar.h"
#import "UIColor+HexString.h"

#define HostProfilePlist @"PersonProfile.plist"
@implementation AppStartManager
+(instancetype)shareManager
{
    static AppStartManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AppStartManager alloc] init];
    });
    return manager;
}


/**
 返回当前登录的用户
 
 @return 登录用户
 */
-(Member *)currentMember
{
    if (host == nil) {
        host = [self getProfileFromPlist];
    }
    return host;
}

/**
 设置记录当前登录的用户
 
 @param member 登录用户
 */
-(void)setMember:(Member *)member
{
    if (member) {
        host = member;
        [self saveProfileToPlist];
    }
}


/**
 移除本地用户数据
 */
-(void)removeLocalHostMemberData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *selfInfoPath = [documentsPath stringByAppendingPathComponent:HostProfilePlist];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:selfInfoPath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:selfInfoPath error:nil];
    }
    
    host = nil;
}


/**
 将登录用户信息保存本地
 */
-(void)saveProfileToPlist
{
    NSDictionary *dic = [host dictionaryInfo];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *selfInfoPath = [documentsPath stringByAppendingPathComponent:HostProfilePlist];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:selfInfoPath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:selfInfoPath error:nil];
    }
    
    [dic writeToFile:selfInfoPath atomically:YES];
}


/**
 获取本地登录用户信息

 @return 在本地登录过的用户信息
 */
-(Member *)getProfileFromPlist
{
    Member *member = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *selfInfoPath = [documentsPath stringByAppendingPathComponent:HostProfilePlist];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:selfInfoPath])
    {
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:selfInfoPath];
        if (dic != nil) {
            member = [[Member alloc] initWithDictionary:dic];
        }
    }
    return member;
}

/**
 app启动时处理事件
 */
-(void)startApp
{
    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"NavBackIndicatorImage"]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"NavBackIndicatorImage"]];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    [[GFGeneralManager defaultManager] getGlovalVarWithVersion];
    [self currentMember];
    if (host) {
        NSString *autoLogin = [AppUtils localUserDefaultsForKey:KMY_AutoLogin];
        if ([autoLogin isEqualToString:@"1"]) {
            [self setHomeView];
        }else{
            [self setLoginView];
        }
    }else{
//        [self setGuidView];
        [self setLoginView];
    }
}

-(void)navColor
{
    if (_navigationController) {
        [_navigationController setNavigationViewColor:[UIColor colorFromHexString:@"#02AF00"]];
    }
}

-(void)setHomeView
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GFHomeViewController *HomeVC = [storyboard instantiateViewControllerWithIdentifier:@"GFHomeViewIdentify"];
    _navigationController = [[UINavigationController alloc] initWithRootViewController:HomeVC];
    [[(AppDelegate *)[UIApplication sharedApplication].delegate window] setRootViewController:_navigationController];
    
    [self navColor];
}

-(void)setGuidView
{
//    SCGuidViewController *zxGuidVC = [[SCGuidViewController alloc] init];
//    _navigationController = [[UINavigationController alloc] initWithRootViewController:zxGuidVC];
//    [[(AppDelegate *)[UIApplication sharedApplication].delegate window] setRootViewController:_navigationController];
    
//    [self navColor];
}

-(void)setLoginView
{
    GFLoginScrollViewController *GFLoginScrollVC = [[GFLoginScrollViewController alloc] init];
    _navigationController = [[UINavigationController alloc] initWithRootViewController:GFLoginScrollVC];
    [[(AppDelegate *)[UIApplication sharedApplication].delegate window] setRootViewController:_navigationController];
    
    [self navColor];
}


/**
 app退出登录时处理事件
 */
-(void)loginout
{
    [_navigationController popToRootViewControllerAnimated:NO];
    _navigationController = nil;
    [AppUtils localUserDefaultsValue:@"0" forKey:KMY_AutoLogin];
    [self setLoginView];
}
@end
