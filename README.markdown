[![Build Status](https://travis-ci.org/tomdiggle/TDNotificationPanel.svg?branch=master)](https://travis-ci.org/tomdiggle/TDNotificationPanel)

# TDNotificationPanel
TDNotificationPanel is a drop in class that displays a notification which can contain a title, subtitle, icon, progress bar or activity indicator.

[![](http://www.tomdiggle.com/assets/images/tdnotificationpanel-error-thumb.jpg)](http://www.tomdiggle.com/assets/images/tdnotificationpanel-error.jpg)
[![](http://www.tomdiggle.com/assets/images/tdnotificationpanel-success-thumb.jpg)](http://www.tomdiggle.com/assets/images/tdnotificationpanel-success.jpg)
[![](http://www.tomdiggle.com/assets/images/tdnotificationpanel-message-thumb.jpg)](http://www.tomdiggle.com/assets/images/tdnotificationpanel-message.jpg)
[![](http://www.tomdiggle.com/assets/images/tdnotificationpanel-progressbar-thumb.jpg)](http://www.tomdiggle.com/assets/images/tdnotificationpanel-progressbar.jpg)
[![](http://www.tomdiggle.com/assets/images/tdnotificationpanel-activityindicator-thumb.jpg)](http://www.tomdiggle.com/assets/images/tdnotificationpanel-activityindicator.jpg)

## Requirements
TDNotificationPanel has been tested on iOS 6+ and requires ARC. It depends on the following Apple frameworks:

- Foundation.framework
- UIKit.framework
- CoreGraphics.framework

## Adding TDNotificationPanel To Your Project

### CocoaPods
[CocoaPods](http://cocoapods.org/) is the recommended way to add TDNotificationPanel to your project.

1. Add a pod entry for TDNotificationPanel to your Podfile `pod 'TDNotificationPanel', '~> 0.5'`.
2. Install the pod(s) by running pod install.
3. Include TDNotificationPanel wherever you need it with `#import "TDNotificationPanel.h"`.

### Source Files
Add the following files located in `TDNotificationPanel` directory to your project. Then include TDNotificationPanel wherever you need it with `#import "TDNotificationPanel.h"`.

## Usage
There are 3 different notification types these are:

- TDNotificationTypeError
- TDNotificationTypeMessage
- TDNotificationTypeSuccess

There are 3 different notification modes these are:

- TDNotificationModeActivityIndicator
- TDNotificationModeProgressBar
- TDNotificationModeText

Please note when using TDNotificationModeActivityIndicator and TDNotificationModeProgressBar the notification type TDNotificationTypeMessage will be used.


To display a notification panel use the following method:

```
[TDNotificationPanel showNotificationInView:self.view
                                      title:@"Notification Title"
                                   subtitle:@"Notification Subtitle"
                                       type:TDNotificationTypeError
                                       mode:TDNotificationModeText
                                dismissible:YES
                             hideAfterDelay:3];
```

If you need to run a long task with a progress bar use the following method:

```
TDNotificationPanel *panel = [[TDNotificationPanel alloc] initWithView:self.view
                                                                 title:@"Posting Message"
                                                              subtitle:nil
                                                                  type:TDNotificationTypeMessage
                                                                  mode:TDNotificationModeProgressBar
                                                           dismissible:NO];
[[self view] addSubview:panel];
[panel show];

[self longRunningTaskWithProgress:^(float)progress {
    [panel setProgress:progress];
} completion:^{
	[panel hideAfterDelay:3];
}];

```

## Completion Handler
A completion handler can be set and will be called when the notification is dismissed.

```
[TDNotificationPanel showNotificationInView:self.view
                                      title:@"Notification Title"
                                   subtitle:@"Notification Subtitle"
                                       type:TDNotificationTypeError
                                       mode:TDNotificationModeText
                                dismissible:YES
                             hideAfterDelay:3
                          completionHandler:^{
                                     NSLog(@"Completion Handler");
                          ];
```

## Queue
All notifications are added to a queue and displayed sequentially.

```
[TDNotificationPanel showNotificationInView:self.view
                                      title:@"Notification 1"
                                   subtitle:@"Notification 1 Subtitle"
                                       type:TDNotificationTypeError
                                       mode:TDNotificationModeText
                                dismissible:YES
                             hideAfterDelay:3];
                             
[TDNotificationPanel showNotificationInView:self.view
                                      title:@"Notification 2 Title"
                                   subtitle:@"Notification 2 Subtitle"
                                       type:TDNotificationTypeSuccess
                                       mode:TDNotificationModeText
                                dismissible:YES
                             hideAfterDelay:3];
```

## License

TDNotificationPanel is distributed under the [The MIT License](https://github.com/tomdiggle/tdnotificationpanel/blob/master/LICENSE).

## Changelog
Changelog can be viewed [here](https://github.com/tomdiggle/tdnotificationpanel/blob/master/Changelog.markdown).
