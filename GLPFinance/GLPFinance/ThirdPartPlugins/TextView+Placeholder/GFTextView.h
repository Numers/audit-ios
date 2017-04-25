//
//  GFTextView.h
//  GLPFinance
//
//  Created by 鲍利成 on 2016/11/25.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
#define UITextViewDidChangeNotification @"UITextViewDidChangeNotification"
@interface GFTextView : UIView<UITextViewDelegate>
{
    UILabel *placeHolderLabel;
    UITextView *myTextView;
}
@property(nonatomic, copy) NSString *placeHolder;
-(void)inilizedView;
-(NSString *)text;
-(UITextView *)textView;
-(void)setBoundLineColor:(UIColor *)boundLineColor;
-(void)setBoundLineWidth:(CGFloat)boundLineWidth;
-(void)setIsShowBoundLine:(BOOL)isShowBoundLine;
-(void)setPlaceHolderFont:(UIFont *)placeHolderFont;
@end
