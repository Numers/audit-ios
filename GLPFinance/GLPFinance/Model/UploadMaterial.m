//
//  UploadMaterial.m
//  GLPFinance
//
//  Created by 鲍利成 on 2016/12/20.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import "UploadMaterial.h"

@implementation UploadMaterial
-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        if (dic) {
            self.basicInfo = [[BasicInfo alloc] initWithDictionary:dic];
            self.childInfos = [NSMutableArray array];
            NSArray *childInfos = [dic objectForKey:@"child"];
            if (childInfos && childInfos.count > 0) {
                for (NSDictionary *childDic in childInfos) {
                    NSString *userVal = [childDic objectForKey:@"user_val"];
                    if ([AppUtils isNullStr:userVal] || userVal.length <= 4) {
                        BasicInfo *info = [[BasicInfo alloc] initWithDictionary:childDic];
                        info.userVal = @"";
                        [self.childInfos addObject:info];
                    }else{
                        NSString *subString = [userVal substringWithRange:NSMakeRange(1, userVal.length - 2)];
                        NSArray *urlList = [subString componentsSeparatedByString:@","];
                        if (urlList && urlList.count > 0) {
                            for (NSString *url in urlList) {
                                NSString *urlStr = [[url stringByReplacingOccurrencesOfString:@"\\" withString:@""] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                                if ([AppUtils isNetworkURL:urlStr]) {
                                    BasicInfo *info = [[BasicInfo alloc] initWithDictionary:childDic];
                                    info.userVal = urlStr;
                                    [self.childInfos addObject:info];
                                }else{
                                    BasicInfo *info = [[BasicInfo alloc] initWithDictionary:childDic];
                                    info.userVal = @"";
                                    [self.childInfos addObject:info];
                                }
                            }
                        }else{
                            BasicInfo *info = [[BasicInfo alloc] initWithDictionary:childDic];
                            info.userVal = @"";
                            [self.childInfos addObject:info];
                        }
                    }
                }
            }
        }
    }
    return self;
}
@end
