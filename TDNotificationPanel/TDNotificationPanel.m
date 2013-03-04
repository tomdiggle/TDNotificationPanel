// TDNotificationPanel.h
// Version 0.1
// Created by Tom Diggle 08.02.2013

/**
 * Copyright (c) 2013, Tom Diggle
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the Software
 * is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
 * PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "TDNotificationPanel.h"

static const CGFloat kPadding = 14.f;
static const CGFloat kTitleFontSize = 14.f;

@interface TDNotificationPanel ()

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) NSArray *backgroundColors;

@end

@implementation TDNotificationPanel

#pragma mark - Class Methods

+ (TDNotificationPanel *)showNotificationPanelInView:(UIView *)view type:(TDNotificationType)type title:(NSString *)title hideAfterDelay:(double)delay
{
    TDNotificationPanel *panel = [[TDNotificationPanel alloc] initWithView:view];
    [panel setNotificationType:type];
    [panel setTitleText:title];
    [view addSubview:panel];
    [panel show:YES];
    [panel hide:YES afterDelay:delay];
    
    return panel;
}

+ (TDNotificationPanel *)showNotificationPanelInView:(UIView *)view animated:(BOOL)animated
{
    TDNotificationPanel *panel = [[TDNotificationPanel alloc] initWithView:view];
    [view addSubview:panel];
    [panel show:animated];
    
    return panel;
}

+ (BOOL)hideNotificationPanelInView:(UIView *)view animated:(BOOL)animated
{
    TDNotificationPanel *panel = [TDNotificationPanel notificationPanelForView:view];
    if (panel)
    {
        [panel hide:animated];
        
        return YES;
    }
    
    return NO;
}

+ (TDNotificationPanel *)notificationPanelForView:(UIView *)view
{
    NSEnumerator *subviews = [[view subviews] reverseObjectEnumerator];
    for (UIView *view in subviews)
    {
        if ([view isKindOfClass:[TDNotificationPanel class]])
        {
            return (TDNotificationPanel *)view;
        }
    }
    
    return nil;
}

+ (NSArray *)notificationPanelsForView:(UIView *)view
{
    NSMutableArray *notificationPanels = [NSMutableArray array];
    NSArray *subview = [view subviews];
    [subview enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[TDNotificationPanel class]])
        {
            [notificationPanels addObject:obj];
        }
    }];
    
    return notificationPanels;
}

#pragma mark - Initializers

- (id)initWithView:(UIView *)view
{
    NSAssert(view, @"view must not be nil.");
    return [self initWithFrame:[view bounds]];
}

- (id)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame]))
    {
        return nil;
    }
    
    _titleText = nil;
    _titleFont = [UIFont boldSystemFontOfSize:kTitleFontSize];
    
    [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self setOpaque:NO];
    [self setBackgroundColor:[UIColor clearColor]];
    [self setAlpha:0.f];
    
    [self setupLabels];
    [self registerForKVO];
    
    return self;
}

#pragma mark - Memory Management

- (void)dealloc
{
    [self unregisterFromKVO];
}

#pragma mark - Setup

- (void)setupLabels
{
    _title = [[UILabel alloc] initWithFrame:self.bounds];
    [_title setText:_titleText];
    [_title setAdjustsFontSizeToFitWidth:NO];
    [_title setTextAlignment:NSTextAlignmentCenter];
    [_title setOpaque:NO];
    [_title setBackgroundColor:[UIColor clearColor]];
    [_title setTextColor:[UIColor whiteColor]];
    [_title setFont:_titleFont];
    [self addSubview:_title];
}

#pragma mark - Show & Hide 

- (void)show:(BOOL)animated
{
    if (animated)
    {
        CATransition *transition = [CATransition animation];
        [transition setDuration:0.33];
        [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [transition setType:kCATransitionPush];
        [transition setSubtype:kCATransitionFromBottom];
        [[self layer] addAnimation:transition forKey:nil];
    }
    
    [self setAlpha:1.f];
}

- (void)hide:(BOOL)animated
{
    if (animated)
    {
        CATransition *transition = [CATransition animation];
        [transition setDuration:0.33];
        [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [transition setType:kCATransitionPush];
        [transition setSubtype:kCATransitionFromTop];
        [[self layer] addAnimation:transition forKey:nil];
        [self setFrame:CGRectMake(0.f, -self.frame.size.height, self.frame.size.width, self.frame.size.height)];
        
        double delayInSeconds = 0.33;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            [self removeFromSuperview];
        });
    }
    else
    {
       [self removeFromSuperview]; 
    }
}

- (void)hide:(BOOL)animated afterDelay:(double)delay
{
    double delayInSeconds = delay;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        [self hide:animated];
    });
}

#pragma mark - KVO

- (NSArray *)observableKeyPaths
{
    return @[@"notificationType", @"titleText", @"titleFont"];
}

- (void)registerForKVO
{
    [[self observableKeyPaths] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self addObserver:self forKeyPath:obj options:NSKeyValueObservingOptionNew context:NULL];
    }];
}

- (void)unregisterFromKVO
{
    [[self observableKeyPaths] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self removeObserver:self forKeyPath:obj];
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"notificationType"])
    {
        [self updateBackground];
    }
    else if ([keyPath isEqualToString:@"titleText"])
    {
        [_title setText:_titleText];
    }
    else if ([keyPath isEqualToString:@"titleFont"])
    {
        [_title setFont:_titleFont];
    }
}

#pragma mark - Update Background

- (void)updateBackground
{
    UIColor *startColor = nil;
    UIColor *endColor = nil;
    if (_notificationType == TDNotificationTypeError)
    {
        startColor = [UIColor colorWithRed:1 green:0.102 blue:0 alpha:0.750];
        endColor = [UIColor colorWithRed:0.804 green:0 blue:0 alpha:0.750];
    }
    else if (_notificationType == TDNotificationTypeInfo)
    {
        startColor = [UIColor colorWithRed:0.290 green:0.607 blue:0.917 alpha:0.750];
        endColor = [UIColor colorWithRed:0.121 green:0.482 blue:0.898 alpha:0.750];
    }
    else if (_notificationType == TDNotificationTypeSuccess)
    {
        startColor = [UIColor colorWithRed:0.356 green:0.650 blue:0 alpha:0.750];
        endColor = [UIColor colorWithRed:0.192 green:0.635 blue:0 alpha:0.750];
    }
    _backgroundColors = @[(id)startColor.CGColor, (id)endColor.CGColor];
}

#pragma mark - Handling Touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hide:YES];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    // Determine the total width & height needed
    CGSize totalSize = CGSizeZero;
    totalSize.width = self.bounds.size.width;
    totalSize.height = kPadding;

    CGSize titleSize = [[_title text] sizeWithFont:[_title font]];
    titleSize.width = MIN(titleSize.width, totalSize.width);
    totalSize.height += titleSize.height;
    
    totalSize.height += 2 * kPadding;
    
    // Position title
    CGFloat yPos = roundf(kPadding / 2);
    CGRect title;
    title.origin.y = yPos;
    title.origin.x = roundf((self.bounds.size.width - titleSize.width) / 2);
    title.size = titleSize;
    _title.frame = title;
    
    self.frame = CGRectMake(0.f, 0.f, totalSize.width, totalSize.height);
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGRect currentBounds = self.bounds;
    
    CGFloat backgroundColorLocations[] = {0, 1};
    CGGradientRef backgroundGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)_backgroundColors, backgroundColorLocations);
    
    CGPoint topCenter = CGPointMake(CGRectGetMidX(currentBounds), 0.f);
    CGPoint midCenter = CGPointMake(CGRectGetMidX(currentBounds), CGRectGetMidY(currentBounds));
    CGContextDrawLinearGradient(context, backgroundGradient, topCenter, midCenter, 0);
    
    CGGradientRelease(backgroundGradient);
    CGColorSpaceRelease(colorSpace);
}

@end
