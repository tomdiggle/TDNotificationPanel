// TDNotificationPanel.h
// Version 0.2
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

#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>

static const CGFloat kXPadding = 20.f;
static const CGFloat kYPadding = 10.f;
static const CGFloat kSpacing = 4.f;
static const CGFloat kTitleFontSize = 14.f;
static const CGFloat kSubtitleFontSize = 12.f;

@interface TDNotificationPanel ()

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *subtitle;
@property (nonatomic, strong) NSArray *backgroundColors;
@property (nonatomic, strong) UIImageView *icon;

@end

@implementation TDNotificationPanel

#pragma mark - Class Methods

+ (instancetype)showNotificationInView:(UIView *)view type:(TDNotificationType)type title:(NSString *)title subtitle:(NSString *)subtitle hideAfterDelay:(NSTimeInterval)delay
{
    TDNotificationPanel *panel = [[TDNotificationPanel alloc] initWithView:view];
    [panel setNotificationType:type];
    [panel setTitleText:title];
    [panel setSubtitleText:subtitle];
    [view addSubview:panel];
    [panel show:YES];
    [panel hide:YES afterDelay:delay];
    
    return panel;
}

+ (instancetype)showNotificationInView:(UIView *)view animated:(BOOL)animated
{
    TDNotificationPanel *panel = [[TDNotificationPanel alloc] initWithView:view];
    [view addSubview:panel];
    [panel show:animated];
    
    return panel;
}

+ (BOOL)hideNotificationInView:(UIView *)view animated:(BOOL)animated
{
    TDNotificationPanel *panel = [TDNotificationPanel notificationInView:view];
    if (panel)
    {
        [panel hide:animated];
        
        return YES;
    }
    
    return NO;
}

+ (TDNotificationPanel *)notificationInView:(UIView *)view
{
    NSEnumerator *subviews = [[view subviews] reverseObjectEnumerator];
    for (UIView *view in subviews)
    {
        if ([view isKindOfClass:NSClassFromString(@"TDNotificationPanel")])
        {
            return (TDNotificationPanel *)view;
        }
    }
    
    return nil;
}

+ (NSArray *)notificationsInView:(UIView *)view
{
    NSMutableArray *notificationPanels = [NSMutableArray array];
    NSArray *subview = [view subviews];
    [subview enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:NSClassFromString(@"TDNotificationPanel")])
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
    if (!(self = [super initWithFrame:frame])) return nil;
    
    _titleText = nil;
    _titleFont = [UIFont boldSystemFontOfSize:kTitleFontSize];
    
    _subtitleText = nil;
    _subtitleFont = [UIFont systemFontOfSize:kSubtitleFontSize];
    
    _notificationMode = TDNotificationModeText;
    _dismissable = YES;
    
    [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self setOpaque:NO];
    [self setBackgroundColor:[UIColor clearColor]];
    [self setAlpha:0];
    
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
    _title = [[UILabel alloc] initWithFrame:CGRectZero];
    [_title setText:_titleText];
    [_title setAdjustsFontSizeToFitWidth:NO];
    [_title setTextAlignment:NSTextAlignmentLeft];
    [_title setOpaque:NO];
    [_title setBackgroundColor:[UIColor clearColor]];
    [_title setTextColor:[UIColor whiteColor]];
    [_title setFont:_titleFont];
    [self addSubview:_title];
    
    _subtitle = [[UILabel alloc] initWithFrame:CGRectZero];
    [_subtitle setText:_titleText];
    [_subtitle setAdjustsFontSizeToFitWidth:NO];
    [_subtitle setTextAlignment:NSTextAlignmentLeft];
    [_subtitle setLineBreakMode:NSLineBreakByWordWrapping];
    [_subtitle setNumberOfLines:0];
    [_subtitle setOpaque:NO];
    [_subtitle setBackgroundColor:[UIColor clearColor]];
    [_subtitle setTextColor:[UIColor whiteColor]];
    [_subtitle setFont:_subtitleFont];
    [self addSubview:_subtitle];
    
    _icon = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:_icon];
}

#pragma mark - Show & Hide 

- (void)show:(BOOL)animated
{
    NSArray *subviews = [[self superview] subviews];
    for (id view in [subviews reverseObjectEnumerator])
    {
        if ([view isKindOfClass:NSClassFromString(@"TDNotificationPanel")] && ![view isEqual:self])
        {
            // If a notification panel is already displaying hide it before showing the new one.
            [view hide:YES];
        }
    }
    
    if (animated)
    {
        CATransition *transition = [CATransition animation];
        [transition setDuration:0.3];
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
        [transition setDuration:0.3];
        [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [transition setType:kCATransitionPush];
        [transition setSubtype:kCATransitionFromTop];
        [[self layer] addAnimation:transition forKey:nil];
        [self setFrame:CGRectMake(0.f, -self.frame.size.height, self.frame.size.width, self.frame.size.height)];
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            [self removeFromSuperview];
        });
    }
    else
    {
       [self removeFromSuperview]; 
    }
}

- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay
{
    [self performSelector:@selector(hide:) withObject:@(animated) afterDelay:delay];
}

#pragma mark - KVO

- (NSArray *)observableKeyPaths
{
    return @[@"notificationType", @"notificationMode", @"titleText", @"titleFont", @"subtitleText", @"subtitleFont"];
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
        [self updateIconAndBackground];
    }
    else if ([keyPath isEqualToString:@"notificationMode"])
    {
        [self updateIndicators];
    }
    else if ([keyPath isEqualToString:@"titleText"])
    {
        [_title setText:_titleText];
        [self setNeedsLayout];
    }
    else if ([keyPath isEqualToString:@"titleFont"])
    {
        [_title setFont:_titleFont];
    }
    else if ([keyPath isEqualToString:@"subtitleText"])
    {
        [_subtitle setText:_subtitleText];
        [self setNeedsLayout];
    }
    else if ([keyPath isEqualToString:@"subtitleFont"])
    {
        [_subtitle setFont:_subtitleFont];
    }
}

#pragma mark - Update Icon and Background

- (void)updateIconAndBackground
{
    UIColor *startColor = nil;
    UIColor *endColor = nil;
    if (_notificationType == TDNotificationTypeError)
    {
        startColor = [UIColor colorWithRed:1 green:0.102 blue:0 alpha:0.750];
        endColor = [UIColor colorWithRed:0.804 green:0 blue:0 alpha:0.750];
        [_icon setImage:[UIImage imageNamed:@"errorIcon"]];
    }
    else if (_notificationType == TDNotificationTypeMessage)
    {
        startColor = [UIColor colorWithRed:0.290 green:0.607 blue:0.917 alpha:0.750];
        endColor = [UIColor colorWithRed:0.121 green:0.482 blue:0.898 alpha:0.750];
        [_icon setImage:nil];
    }
    else if (_notificationType == TDNotificationTypeSuccess)
    {
        startColor = [UIColor colorWithRed:0.356 green:0.650 blue:0 alpha:0.750];
        endColor = [UIColor colorWithRed:0.192 green:0.635 blue:0 alpha:0.750];
        [_icon setImage:[UIImage imageNamed:@"successIcon"]];
    }
    _backgroundColors = @[(id)startColor.CGColor, (id)endColor.CGColor];
}

- (void)updateIndicators
{
    if (_notificationMode == TDNotificationModeText)
    {
        [_progressIndicator removeFromSuperview];
        _progressIndicator = nil;
    }
    else if (_notificationMode == TDNotificationModeProgressBar)
    {
        // No icon will be shown when a progress indicator is being displayed.
        [_icon removeFromSuperview];
        _icon = nil;
        
        _progressIndicator = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        [_progressIndicator setFrame:CGRectZero];
        [self addSubview:_progressIndicator];
    }
}

#pragma mark - Handling Touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_dismissable) return;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [self hide:YES];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGPoint position = CGPointZero;
    
    if ([[self superview] isKindOfClass:NSClassFromString(@"UIWindow")])
    {
        if (![UIApplication sharedApplication].statusBarHidden)
        {
            // Position under the status bar.
            position.y = [UIApplication sharedApplication].statusBarFrame.size.height;
        }
        
        UIWindow *parent = (UIWindow *)self.superview;
        if ([[parent rootViewController] isKindOfClass:NSClassFromString(@"UINavigationController")])
        {
            UINavigationController *navigationController = (UINavigationController *)parent.rootViewController;
            if (!navigationController.navigationBarHidden)
            {
                // Position under the navigation controller's navigation bar.
                position.y += navigationController.navigationBar.frame.size.height;
            }
            
            // Display the view under the navigation controller's navigation bar so the animation's appear
            // below the navigation bar and the panel can persist accross views.
            [self removeFromSuperview];
            [[navigationController view] insertSubview:self
                                          belowSubview:navigationController.navigationBar];
        }
    }

    // Determine the total width of the notification.
    CGSize totalSize = CGSizeZero;
    totalSize.width = self.bounds.size.width;
    
    // Icon
    if ([_icon image])
    {
        [_icon setFrame:CGRectMake(kXPadding, kYPadding, 30, 30)];
    }
    
    // Title
    if (_titleText)
    {
        CGRect title = CGRectZero;
        title.origin.x = _icon.frame.origin.x + CGRectGetWidth(_icon.frame) + kXPadding;
        title.origin.y = kYPadding;
        
        CGSize titleSize = [[_title text] sizeWithFont:[_title font]];
        titleSize.width = MIN(titleSize.width, totalSize.width - title.origin.x - kXPadding);
        title.size = titleSize;
        _title.frame = title;
    }
    
    // Progress indicator
    if (_notificationMode == TDNotificationModeProgressBar)
    {
        CGRect progress = CGRectZero;
        progress.origin.x = kXPadding;
        if (_titleText)
        {
            progress.origin.y = CGRectGetMaxY(_title.frame) + kSpacing;
        }
        else
        {
            progress.origin.y = kYPadding;
        }
        
        progress.size.width = self.bounds.size.width - kXPadding * 2;
        [_progressIndicator setFrame:progress];
    }
    
    // Subtitle
    CGRect subtitle = CGRectZero;
    subtitle.origin.x = _icon.frame.origin.x + CGRectGetWidth(_icon.frame) + kXPadding;
    if (_notificationMode == TDNotificationModeProgressBar)
    {
        subtitle.origin.y = CGRectGetMaxY([_progressIndicator frame]) + kSpacing;
    }
    else
    {
        subtitle.origin.y = CGRectGetMaxY(_title.frame) + kSpacing;
    }
    
    CGSize subtitleSize = [[_subtitle text] sizeWithFont:[_subtitle font]];
    subtitleSize.width = MIN(subtitleSize.width, totalSize.width - subtitle.origin.x - kXPadding);
    subtitle.size = subtitleSize;
    _subtitle.frame = subtitle;
    [_subtitle sizeToFit];
    
    // Determine the total height of the notification.
    if (_notificationMode == TDNotificationModeProgressBar)
    {
        totalSize.height += CGRectGetMaxY(_progressIndicator.frame) + CGRectGetHeight(_progressIndicator.frame);
        
        if (_titleText)
        {
            totalSize.height += CGRectGetHeight(_title.frame);
        }
        
        if (_subtitleText)
        {
            totalSize.height += CGRectGetMaxY(_subtitle.frame) + CGRectGetHeight(_subtitle.frame);
        }
        else
        {
            totalSize.height += CGRectGetMaxY(_title.frame) + kYPadding;
        }
    }
    else if (_subtitleText || ![_icon image])
    {
        totalSize.height = CGRectGetMaxY(_title.frame) + CGRectGetHeight(_title.frame) + CGRectGetMaxY(_subtitle.frame) + CGRectGetHeight(_subtitle.frame);
    }
    else
    {
        // When no subtitle is being shown increase the y offset of the title frame so it's more center.
        _title.frame = CGRectOffset(_title.frame, 0, CGRectGetMinY(_title.frame) / 2);
        
        totalSize.height = CGRectGetMaxY(_icon.frame) + CGRectGetHeight(_icon.frame) + CGRectGetMaxY(_title.frame);
    }
    
    self.frame = CGRectMake(position.x, position.y, totalSize.width, totalSize.height);
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGRect currentBounds = self.bounds;
    
    CGFloat backgroundColorLocations[] = {0, 1};
    CGGradientRef backgroundGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)_backgroundColors, backgroundColorLocations);
    
    CGPoint topCenter = CGPointMake(CGRectGetMidX(currentBounds), 0);
    CGPoint midCenter = CGPointMake(CGRectGetMidX(currentBounds), CGRectGetMidY(currentBounds));
    CGContextDrawLinearGradient(context, backgroundGradient, topCenter, midCenter, 0);
    
    CGGradientRelease(backgroundGradient);
    CGColorSpaceRelease(colorSpace);
}

@end
