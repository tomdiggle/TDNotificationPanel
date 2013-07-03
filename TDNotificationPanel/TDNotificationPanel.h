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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    TDNotificationTypeError,
    TDNotificationTypeInfo,
    TDNotificationTypeSuccess,
} TDNotificationType;

@interface TDNotificationPanel : UIView

/**
 * The notification type that will be used to determine the color of the background.
 *
 * @see TDNotificationType
 */
@property (nonatomic, assign) TDNotificationType notificationType;

/**
 * A short message to be displayed. If the text is too long it will get clipped by displaying "..." at the end. 
 * If set to nil then no title is displayed.
 */
@property (nonatomic, copy) NSString *titleText;

/**
 * Font to be used for the title. Default is system bold.
 */
@property (nonatomic, copy) UIFont *titleFont;

/*
 * Creates a new notification panel, adds it to the provided view shows it and then removes it after the delay given.
 *
 * @param view The view that the notification panel will be added to.
 * @param type The notification type.
 * @param title The title that will be displayed.
 * @param delay The delay before the notification panel will be removed.
 *
 * @return A reference to the created notification panel.
 *
 * @see TDNotificationType
 */
+ (TDNotificationPanel *)showNotificationPanelInView:(UIView *)view type:(TDNotificationType)type title:(NSString *)title hideAfterDelay:(NSTimeInterval)delay;

/**
 * Creates a new notification panel, adds it to the view provided and shows it.
 *
 * @param view The view that the notification panel will be added to.
 * @param animated If set to YES the notification panel will be shown and hidden using an animation. If set to NO, no animation will be used.
 *
 * @return A reference to the created notification panel.
 */
+ (TDNotificationPanel *)showNotificationPanelInView:(UIView *)view animated:(BOOL)animated;

/**
 * Hides the top-most notification panel.
 *
 * @param view The view that the notification panel will be removed from.
 * @param animated If set to YES the notification panel will be shown and hidden using an animation. If set to NO, no animation will be used.
 * 
 * @return YES if notification panel is hidden, NO otherwise.
 *
 * @see showNotificationPanelInView:animated:
 */
+ (BOOL)hideNotificationPanelInView:(UIView *)view animated:(BOOL)animated;

/**
 * Returns an array of notification panels for the view provided.
 *
 * @param view The view in which to check for notification panels.
 *
 * @return An array of notification panels for the view provided, or nil if none exists.
 */
+ (NSArray *)notificationPanelsForView:(UIView *)view;

@end
