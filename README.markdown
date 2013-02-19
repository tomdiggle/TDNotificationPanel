# TDNotificationPanel
TDNotificationPanel is a drop in class that displays a notification panel with a label.

[![](http://www.tomdiggle.com/assets/images/tdnotificationpanel-error-thumb.png)](http://www.tomdiggle.com/assets/images/tdnotificationpanel-error.png)
[![](http://www.tomdiggle.com/assets/images/tdnotificationpanel-info-thumb.png)](http://www.tomdiggle.com/assets/images/tdnotificationpanel-info.png)
[![](http://www.tomdiggle.com/assets/images/tdnotificationpanel-success-thumb.png)](http://www.tomdiggle.com/assets/images/tdnotificationpanel-success.png)

## Requirements
TDNotification has been tested on iOS 6+ and is compatible with ARC projects. It depends on the following Apple frameworks:

- Foundation.framework
- UIKit.framework
- CoreGraphics.framework
- QuartzCore.framework

## Adding TDNotificationPanel To Your Project
Add the following source files `TDNotificationPanel.h` and `TDNotificationPanel.m` located in `TDNotificationPanel` directory to your project. Then include TDNotificationPanel wherever you need it with `#import "TDNotificationPanel.h"`.

## Usage
To display a notification panel use the following method:

```
[TDNotificationPanel showNotificationPanelInView:self.view
											type:TDNotificationTypeError
										   title:@"Error Notification"
								  hideAfterDelay:3];
```

There are 3 different notification types these are:

- TDNotificationTypeError
- TDNotificationTypeInfo
- TDNotificationTypeSuccess

## License

TDNotificationPanel is distributed under the [The MIT License](https://github.com/tomdiggle/tdnotificationpanel/blob/master/LICENSE).

## Changelog
Changelog can be viewed [here](https://github.com/tomdiggle/tdnotificationpanel/blob/master/Changelog.markdown).
