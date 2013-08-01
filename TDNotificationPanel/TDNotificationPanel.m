// TDNotificationPanel.h
// Version 0.3.2
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
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, strong) UIProgressView *progressBar;
@property (nonatomic, assign) CGSize totalSize;

@end

@implementation TDNotificationPanel

#pragma mark - Class Methods

+ (instancetype)showNotificationInView:(UIView *)view title:(NSString *)title subtitle:(NSString *)subtitle type:(TDNotificationType)type mode:(TDNotificationMode)mode dismissable:(BOOL)dismissable hideAfterDelay:(NSTimeInterval)delay
{
    TDNotificationPanel *panel = [[TDNotificationPanel alloc] initWithView:view
                                                                     title:title
                                                                   subtitle:subtitle
                                                                       type:type
                                                                       mode:mode
                                                                dismissable:dismissable];
    [view addSubview:panel];
    [panel show];
    [panel hideAfterDelay:delay];
    
    return panel;
}

+ (BOOL)hideNotificationInView:(UIView *)view
{
    TDNotificationPanel *panel = [TDNotificationPanel notificationInView:view];
    if (panel)
    {
        [panel hide];
        return YES;
    }
    
    return NO;
}

+ (instancetype)notificationInView:(UIView *)view
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

- (id)initWithView:(UIView *)view title:(NSString *)title subtitle:(NSString *)subtitle type:(TDNotificationType)type mode:(TDNotificationMode)mode dismissable:(BOOL)dismissable
{
    if (!(self = [super initWithFrame:[view bounds]])) return nil;
    
    _titleText = title;
    _titleFont = [UIFont boldSystemFontOfSize:kTitleFontSize];
    
    _subtitleText = subtitle;
    _subtitleFont = [UIFont systemFontOfSize:kSubtitleFontSize];
    
    _notificationType = type;
    _notificationMode = mode;
    
    _dismissable = dismissable;
    
    _progress = 0;
    
    [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self setOpaque:NO];
    [self setBackgroundColor:[UIColor clearColor]];
    [self setAlpha:0];
    
    [self setupElements];
    [self setupIconAndBackgroundColor];
    [self registerForKVO];
    [self positionElements];
    
    return self;
}

#pragma mark - Memory Management

- (void)dealloc
{
    [self unregisterFromKVO];
}

#pragma mark - Setup

- (void)setupElements
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
    [_subtitle setText:_subtitleText];
    [_subtitle setAdjustsFontSizeToFitWidth:NO];
    [_subtitle setTextAlignment:NSTextAlignmentLeft];
    [_subtitle setLineBreakMode:NSLineBreakByWordWrapping];
    [_subtitle setNumberOfLines:0];
    [_subtitle setOpaque:NO];
    [_subtitle setBackgroundColor:[UIColor clearColor]];
    [_subtitle setTextColor:[UIColor whiteColor]];
    [_subtitle setFont:_subtitleFont];
    [self addSubview:_subtitle];
    
    if (_notificationMode == TDNotificationModeActivityIndicator)
    {
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [_indicator setFrame:CGRectZero];
        [self addSubview:_indicator];
    }
    else if (_notificationMode == TDNotificationModeProgressBar)
    {
        _progressBar = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        [_progressBar setFrame:CGRectZero];
        [self addSubview:_progressBar];
    }
    else if (_notificationMode == TDNotificationModeText)
    {
        _icon = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_icon setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_icon];
    }
}

- (void)setupIconAndBackgroundColor
{
    UIColor *startGradient = nil;
    UIColor *endGradient = nil;
    UIColor *bottomBorder = nil;
    if (_notificationType == TDNotificationTypeError)
    {
        startGradient = [UIColor colorWithRed:0.900 green:0.102 blue:0 alpha:0.900];
        endGradient = [UIColor colorWithRed:0.750 green:0 blue:0 alpha:0.900];
        bottomBorder = [UIColor colorWithRed:0.550 green:0 blue:0 alpha:1];
        [_icon setImage:[UIImage imageNamed:@"errorIcon"]];
    }
    else if (_notificationType == TDNotificationTypeMessage)
    {
        startGradient = [UIColor colorWithRed:0.290 green:0.607 blue:0.917 alpha:0.900];
        endGradient = [UIColor colorWithRed:0.121 green:0.482 blue:0.898 alpha:0.900];
        bottomBorder = [UIColor colorWithRed:0.121 green:0.294 blue:0.898 alpha:1];
        [_icon setImage:nil];
    }
    else if (_notificationType == TDNotificationTypeSuccess)
    {
        startGradient = [UIColor colorWithRed:0.356 green:0.650 blue:0 alpha:0.900];
        endGradient = [UIColor colorWithRed:0.192 green:0.635 blue:0 alpha:0.900];
        bottomBorder = [UIColor colorWithRed:0.192 green:0.390 blue:0 alpha:1];
        [_icon setImage:[UIImage imageNamed:@"successIcon"]];
    }
    _backgroundColors = @[(id)startGradient.CGColor, (id)endGradient.CGColor, (id)bottomBorder.CGColor];
}

#pragma mark - Show & Hide 

- (void)show
{
    NSArray *subviews = [[self superview] subviews];
    for (id view in [subviews reverseObjectEnumerator])
    {
        if ([view isKindOfClass:NSClassFromString(@"TDNotificationPanel")] && ![view isEqual:self])
        {
            // If a notification panel is already displaying hide it before showing the new one.
            [view hide];
        }
    }
    
    self.frame = CGRectMake(0, -_totalSize.height, _totalSize.width, _totalSize.height);

    CGFloat verticalOffset = 0;
    if ([[self superview] isKindOfClass:NSClassFromString(@"UIWindow")])
    {
        if (![UIApplication sharedApplication].statusBarHidden)
        {
            // Position under the status bar.
            verticalOffset = [UIApplication sharedApplication].statusBarFrame.size.height;
        }
        
        UIWindow *parent = (UIWindow *)self.superview;
        if ([[parent rootViewController] isKindOfClass:NSClassFromString(@"UINavigationController")])
        {
            UINavigationController *navigationController = (UINavigationController *)parent.rootViewController;
            if (!navigationController.navigationBarHidden)
            {
                // Position under the navigation controller's navigation bar.
                verticalOffset += navigationController.navigationBar.frame.size.height;
            }
            
            // Display the view under the navigation controller's navigation bar so the animation's appear
            // below the navigation bar and the panel can persist accross views.
            [self removeFromSuperview];
            [[navigationController view] insertSubview:self
                                          belowSubview:navigationController.navigationBar];
        }
    }
    
    if (_notificationMode == TDNotificationModeActivityIndicator)
    {
        [_indicator startAnimating];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        [self setCenter:CGPointMake(self.center.x, verticalOffset + self.bounds.size.height - self.frame.size.height / 2)];
        [self setAlpha:1.0];
    }];
}

- (void)hide
{
    [UIView animateWithDuration:0.3 animations:^{
        [self setCenter:CGPointMake(self.center.x, -self.frame.size.height / 2)];
        [self setAlpha:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)hideAfterDelay:(NSTimeInterval)delay
{
    [self performSelector:@selector(hide) withObject:nil afterDelay:delay];
}

#pragma mark - KVO

- (NSArray *)observableKeyPaths
{
    return @[@"titleText", @"titleFont", @"subtitleText", @"subtitleFont", @"progress"];
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
    if ([keyPath isEqualToString:@"titleText"])
    {
        [_title setText:_titleText];
    }
    else if ([keyPath isEqualToString:@"titleFont"])
    {
        [_title setFont:_titleFont];
    }
    else if ([keyPath isEqualToString:@"subtitleText"])
    {
        [_subtitle setText:_subtitleText];
    }
    else if ([keyPath isEqualToString:@"subtitleFont"])
    {
        [_subtitle setFont:_subtitleFont];
    }
    else if ([keyPath isEqualToString:@"progress"])
    {
        if ([_progressBar respondsToSelector:@selector(setProgress:)])
        {
            [_progressBar setProgress:_progress];
        }
        
        return;
    }
    
    [self positionElements];
}

#pragma mark - Handling Touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_dismissable) return;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [self hide];
}

#pragma mark - Layout

- (void)positionElements
{
    // Determine the total width of the notification.
    CGSize size = CGSizeZero;
    size.width = self.bounds.size.width;
    size.height = kYPadding;
    
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
        titleSize.width = MIN(titleSize.width, size.width - title.origin.x - kXPadding);
        title.size = titleSize;
        _title.frame = title;
        
        size.height += CGRectGetHeight(_title.frame);
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
        [_indicator setFrame:progress];
        
        size.height += CGRectGetHeight(_indicator.frame);
        
        if (_titleText)
        {
            size.height += kSpacing;
        }
    }
    
    // Subtitle
    if (_subtitleText)
    {
        CGRect subtitle = CGRectZero;
        subtitle.origin.x = _icon.frame.origin.x + CGRectGetWidth(_icon.frame) + kXPadding;
        if (_notificationMode == TDNotificationModeProgressBar)
        {
            subtitle.origin.y = CGRectGetMaxY([_indicator frame]) + kSpacing;
        }
        else
        {
            subtitle.origin.y = CGRectGetMaxY(_title.frame) + kSpacing;
        }
        
        CGSize subtitleSize = [[_subtitle text] sizeWithFont:[_subtitle font]];
        subtitleSize.width = MIN(subtitleSize.width, size.width - subtitle.origin.x - kXPadding);
        subtitle.size = subtitleSize;
        _subtitle.frame = subtitle;
        [_subtitle sizeToFit];
        
        size.height += CGRectGetHeight(_subtitle.frame);
        
        if (_titleText)
        {
            size.height += kSpacing;
        }
    }
    
    // Activity Indicator
    if (_notificationMode == TDNotificationModeActivityIndicator)
    {
        [_indicator setFrame:CGRectMake(kXPadding, kYPadding, 20, 20)];
        
        if (_titleText)
        {
            [_title setFrame:CGRectMake(_title.frame.origin.x + CGRectGetWidth(_indicator.frame) + kXPadding, _title.frame.origin.y, _title.frame.size.width, _title.frame.size.height)];
        }
        
        if (_subtitle)
        {
            [_subtitle setFrame:CGRectMake(_subtitle.frame.origin.x + CGRectGetWidth(_indicator.frame) + kXPadding, _subtitle.frame.origin.y, _subtitle.frame.size.width, _subtitle.frame.size.height)];
        }
    }
    
    size.height += kYPadding;
    
    if (!CGRectContainsRect(CGRectMake(0, 0, size.width, size.height), _icon.frame))
    {
        size.height = CGRectGetHeight(_icon.frame) + kYPadding * 2;
        _title.frame = CGRectOffset(_title.frame, 0, CGRectGetMinY(_title.frame) / 2);
    }
    
    _totalSize = size;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGRect currentBounds = self.bounds;
    
    CGFloat backgroundColorLocations[] = {0, 0.98, 1};
    CGGradientRef backgroundGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)_backgroundColors, backgroundColorLocations);
    
    CGPoint top = CGPointMake(CGRectGetMidX(currentBounds), 0);
    CGPoint bottom = CGPointMake(CGRectGetMidX(currentBounds), CGRectGetMaxY(currentBounds));
    CGContextDrawLinearGradient(context, backgroundGradient, top, bottom, 0);
    
    CGGradientRelease(backgroundGradient);
    CGColorSpaceRelease(colorSpace);
}

@end
