//
//  GFTextView.m
//  GLPFinance
//
//  Created by 鲍利成 on 2016/11/25.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import "GFTextView.h"
#define LeftMargin 6.0f
#define TopMargin 8.0f

#define BoundLineDefaultWidth 0.5f
#define BoundLineDefaultColor [UIColor colorWithRed:215.0f/255.0f green:215.0f/255.0f blue:215.0f/255.0f alpha:1.0f]

#define PlaceHolderDefaultFont [UIFont systemFontOfSize:15.f]

@interface GFTextView()
@property(nonatomic, strong) UIColor *boundLineColor;
@property(nonatomic) CGFloat boundLineWidth;
@property(nonatomic) BOOL isShowBoundLine;

@property(nonatomic,strong) UIFont *placeHolderFont;
@end

@implementation GFTextView
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self inilizedView];
    }
    return self;
}

-(void)inilizedView
{
    if (myTextView == nil) {
        myTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        myTextView.textContainerInset = UIEdgeInsetsMake(TopMargin, LeftMargin, 0, 0);
        if (_placeHolderFont == nil) {
            _placeHolderFont = PlaceHolderDefaultFont;
        }
        [myTextView setFont:_placeHolderFont];
        myTextView.returnKeyType = UIReturnKeyDone;
        myTextView.delegate = self;
        [self addSubview:myTextView];
        
        placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(LeftMargin + 5, 6, myTextView.frame.size.width, 21)];
        [placeHolderLabel setFont:[UIFont systemFontOfSize:15.f]];
        [placeHolderLabel setTextColor:[UIColor colorWithRed:179/255.0f green:179/255.0f blue:179/255.0f alpha:1.0f]];
        [placeHolderLabel setTextAlignment:NSTextAlignmentLeft];
        [placeHolderLabel setText:_placeHolder];
        [myTextView addSubview:placeHolderLabel];
        
        _boundLineWidth = BoundLineDefaultWidth;
        _boundLineColor = BoundLineDefaultColor;
        _isShowBoundLine = NO;
    }
}

-(void)setPlaceHolderFont:(UIFont *)placeHolderFont
{
    if (placeHolderFont) {
        _placeHolderFont = placeHolderFont;
        if (placeHolderLabel) {
            [placeHolderLabel setFont:placeHolderFont];
        }
    }
}

-(void)setBoundLineColor:(UIColor *)boundLineColor
{
    if (boundLineColor != nil) {
        _boundLineColor = boundLineColor;
        [self setNeedsDisplay];
    }
}

-(void)setBoundLineWidth:(CGFloat)boundLineWidth
{
    _boundLineWidth = boundLineWidth;
    [self setNeedsDisplay];
}

-(void)setIsShowBoundLine:(BOOL)isShowBoundLine
{
    _isShowBoundLine = isShowBoundLine;
    [self setNeedsDisplay];
}

-(void)setPlaceHolder:(NSString *)placeHolder
{
    if (placeHolderLabel) {
        [placeHolderLabel setText:placeHolder];
    }
    _placeHolder = placeHolder;
}

-(NSString *)text
{
    return myTextView.text;
}

-(UITextView *)textView
{
    return myTextView;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if( [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound ) {
        if (range.location > 0 || text.length != 0) {
            [placeHolderLabel setHidden:YES];
        }else{
            [placeHolderLabel setHidden:NO];
        }
        return YES;
    }
    [textView resignFirstResponder];
    return NO;
}

- (void)textViewDidChange:(UITextView *)textView
{
    
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    if (_isShowBoundLine) {
        [myTextView setFrame:CGRectMake(_boundLineWidth, _boundLineWidth, self.frame.size.width - 2 * _boundLineWidth, self.frame.size.height - 2 * _boundLineWidth)];
        CGMutablePathRef path = CGPathCreateMutable();
        CGRect rectangle = CGRectMake(_boundLineWidth / 2.0f, _boundLineWidth / 2.0f, self.frame.size.width - _boundLineWidth, self.frame.size.height - _boundLineWidth);
        CGPathAddRect(path, NULL, rectangle);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextAddPath(context, path);
        CGContextSetStrokeColorWithColor(context, _boundLineColor.CGColor);
        CGContextSetLineWidth(context, _boundLineWidth);
        CGContextSetLineCap(context, kCGLineCapSquare);
        CGContextDrawPath(context, kCGPathFillStroke);
        CGPathRelease(path);
    }else{
        [myTextView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    }
}


@end
