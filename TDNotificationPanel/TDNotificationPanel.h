// TDNotificationPanel.h
// Version 0.5.2
// Created by Tom Diggle 08.02.2013

/**
 * Copyright (c) 2013-2015, Tom Diggle
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
    TDNotificationModeActivityIndicator,
    TDNotificationModeProgressBar,
    TDNotificationModeText
} TDNotificationMode;

typedef enum {
    TDNotificationTypeError,
    TDNotificationTypeMessage,
    TDNotificationTypeSuccess,
} TDNotificationType;

/** 
 * Displays a simple notification which can contain a title, subtitle, icon, progress bar or activity indicator.
 *
 * The notification will appear at the top of a view directly beneath any status or navigation bars.
 */

@interface TDNotificationPanel : UIView

/**
 * The notification type that will be used to determine the color of the background & type of icon displayed.
 *
 * @see TDNotificationType
 */
@property (nonatomic, assign) TDNotificationType notificationType;

/**
 * The notification operation mode. When using TDNotificationModeActivityIndicator or TDNotificationModeProgressBar the notification mode TDNotificationTypeMessage will be used.
 *
 * @see TDNotificationMode
 */
@property (nonatomic, assign) TDNotificationMode notificationMode;

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
 * The duration of the notification. Default is 0.
 */
@property (nonatomic, assign) NSTimeInterval notificationDuration;

/**
 * The completion handler to call when the notification is dismissed.
 */
@property (nonatomic, copy) void(^completionHandler)();

/**
 * The progress of the progress bar, from 0.0 to 1.0. Defaults to 0.0.
 *
 * @see notificationMode
 */
@property (nonatomic, assign) float progress;

/**
 * YES notification will be dismissible when tapped, NO notification will not be dismissible when tapped.
 */
@property (nonatomic, assign, getter = isDismissible) BOOL dismissible;

/**
 * Initializes a new notification, adds it to the provided view then displays it.
 *
 * @param view The view that the notification will be added to.
 * @param title The title that will be displayed.
 * @param subtitle The subtitle that will be displayed under the title.
 * @param type The notification type.
 * @param mode The notification mode.
 * @param dismissible The notification is dismissible by tapping.
 *
 * @return A reference to the created notification.
 *
 * @see TDNotificationType
 * @see TDNotificationMode
 */
+ (instancetype)showNotificationInView:(UIView *)view title:(NSString *)title subtitle:(NSString *)subtitle type:(TDNotificationType)type mode:(TDNotificationMode)mode dismissible:(BOOL)dismissible;

/**
 * Initializes a new notification, adds it to the provided view then displays it, then calls a handler upon completion.
 *
 * @param view The view that the notification will be added to.
 * @param title The title that will be displayed.
 * @param subtitle The subtitle that will be displayed under the title.
 * @param type The notification type.
 * @param mode The notification mode.
 * @param dismissible The notification is dismissible by tapping.
 * @param completionHandler The completion handler to call when the notification is dismissed.
 *
 * @return A reference to the created notification.
 *
 * @see TDNotificationType
 * @see TDNotificationMode
 */
+ (instancetype)showNotificationInView:(UIView *)view title:(NSString *)title subtitle:(NSString *)subtitle type:(TDNotificationType)type mode:(TDNotificationMode)mode dismissible:(BOOL)dismissible completionHandler:(void (^)())completionHandler;

/**
 * Initializes a new notification, adds it to the provided view, shows it and then removes it after the delay given.
 *
 * @param view The view that the notification will be added to.
 * @param title The title that will be displayed.
 * @param subtitle The subtitle that will be displayed under the title.
 * @param type The notification type.
 * @param mode The notification mode.
 * @param dismissible The notification is dismissible by tapping.
 * @param delay The delay in seconds before the notification will be removed.
 *
 * @return A reference to the created notification.
 *
 * @see TDNotificationType
 * @see TDNotificationMode
 */
+ (instancetype)showNotificationInView:(UIView *)view title:(NSString *)title subtitle:(NSString *)subtitle type:(TDNotificationType)type mode:(TDNotificationMode)mode dismissible:(BOOL)dismissible hideAfterDelay:(NSTimeInterval)delay;

/**
 * Initializes a new notification, adds it to the provided view, shows it, removes it after the delay given, then calls a handler upon completion.
 *
 * @param view The view that the notification will be added to.
 * @param title The title that will be displayed.
 * @param subtitle The subtitle that will be displayed under the title.
 * @param type The notification type.
 * @param mode The notification mode.
 * @param dismissible The notification is dismissible by tapping.
 * @param delay The delay in seconds before the notification will be removed.
 * @param completionHandler The completion handler to call when the notification is dismissed.
 *
 * @return A reference to the created notification.
 *
 * @see TDNotificationType
 * @see TDNotificationMode
 */
+ (instancetype)showNotificationInView:(UIView *)view title:(NSString *)title subtitle:(NSString *)subtitle type:(TDNotificationType)type mode:(TDNotificationMode)mode dismissible:(BOOL)dismissible hideAfterDelay:(NSTimeInterval)delay completionHandler:(void (^)())completionHandler;

/**
 * Hides the top-most notification in the view provided.
 *
 * @param view The view that the notification will be removed from.
 * 
 * @return YES if notification is hidden, NO otherwise.
 *
 * @see showNotificationInView:animated:
 */
+ (BOOL)hideNotificationInView:(UIView *)view;

/**
 * Returns an array of notifications in the view provided.
 *
 * @param view The view that will be searched for notifications.
 *
 * @return An array of notifications for the view provided, or nil if none exists.
 */
+ (NSArray *)notificationsInView:(UIView *)view;

/**
 * Initializes a new notification.
 *
 * @param view The view instance that will provided the bounds for the notification.
 * @param title The title that will be displayed.
 * @param subtitle The subtitle that will be displayed under the title.
 * @param type The notification type.
 * @param mode The notification mode.
 * @param dismissible The notification is dismissible by tapping.
 *
 * @see notificationtype
 * @see notificationMode
 * @see dismissible
 */
- (instancetype)initWithView:(UIView *)view title:(NSString *)title subtitle:(NSString *)subtitle type:(TDNotificationType)type mode:(TDNotificationMode)mode dismissible:(BOOL)dismissible;

/**
 * Displays the notification.
 */
- (void)show;

/**
 * Hides the notification.
 */
- (void)hide;

@end
