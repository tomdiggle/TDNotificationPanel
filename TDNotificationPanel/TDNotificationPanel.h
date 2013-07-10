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
    TDNotificationTypeMessage,
    TDNotificationTypeSuccess,
} TDNotificationType;

@interface TDNotificationPanel : UIView

/**
 * The notification type that will be used to determine the color of the background & icon.
 *
 * @see TDNotificationType
 */
@property (nonatomic, assign) TDNotificationType notificationType;

/**
 * A short message to be displayed. If the text is too long it will get clipped by displaying "..." at the end. If set to nil no title is displayed.
 */
@property (nonatomic, copy) NSString *titleText;

/**
 * Font to be used for the title. Default is system bold font.
 */
@property (nonatomic, copy) UIFont *titleFont;

/**
 * A message to be displayed underneath the title. If set to nil no subtitle is displayed.
 */
@property (nonatomic, copy) NSString *subtitleText;

/**
 * Font to be use for the subtitle. Default is system font.
 */
@property (nonatomic, copy) UIFont *subtitleFont;

/**
 * When set to YES notification will be dismissable when tapped. When set to NO notification will only be able to be dismissed using hideNotificationInView:animated method. Default is YES.
 */
@property (nonatomic, assign, getter = isDismissable) BOOL dismissable;

/**
 * Creates a new notification, adds it to the provided view shows it and then removes it after the delay given.
 *
 * @param view The view that the notification will be added to.
 * @param type The notification type.
 * @param title The title that will be displayed.
 * @param delay The delay before the notification will be removed.
 *
 * @return A reference to the created notification.
 *
 * @see TDNotificationType
 */
+ (instancetype)showNotificationInView:(UIView *)view type:(TDNotificationType)type title:(NSString *)title subtitle:(NSString *)subtitle hideAfterDelay:(NSTimeInterval)delay;

/**
 * Creates a new notification, adds it to the view provided and shows it.
 *
 * @param view The view that the notification will be added to.
 * @param animated If set to YES the notification will be shown and hidden using an animation. If set to NO, no animation will be used.
 *
 * @return A reference to the created notification.
 */
+ (instancetype)showNotificationInView:(UIView *)view animated:(BOOL)animated;

/**
 * Hides the top-most notification in the view provided.
 *
 * @param view The view that the notification will be removed from.
 * @param animated If set to YES the notification will be shown and hidden using an animation. If set to NO, no animation will be used.
 * 
 * @return YES if notification is hidden, NO otherwise.
 *
 * @see showNotificationInView:animated:
 */
+ (BOOL)hideNotificationInView:(UIView *)view animated:(BOOL)animated;

/**
 * Returns an array of notifications in the view provided.
 *
 * @param view The view in which to check for notifications.
 *
 * @return An array of notifications for the view provided, or nil if none exists.
 */
+ (NSArray *)notificationsInView:(UIView *)view;

@end
