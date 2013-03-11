//
//  TDViewController.m
//  TDNotificationPanelDemo
//
//  Created by Tom Diggle on 17/02/2013.
//  Copyright (c) 2013 Tom Diggle. All rights reserved.
//

#import "TDViewController.h"
#import "TDNotificationPanel.h"

@interface TDViewController ()

@end

@implementation TDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)displayErrorNotificationButtonTapped:(id)sender
{
    [TDNotificationPanel showNotificationPanelInView:self.view
                                                type:TDNotificationTypeError
                                               title:@"Error Notification"
                                      hideAfterDelay:3];
}

- (IBAction)displayInfoNotificationButtonTapped:(id)sender
{
    [TDNotificationPanel showNotificationPanelInView:self.view
                                                type:TDNotificationTypeInfo
                                               title:@"Info Notification"
                                      hideAfterDelay:3];
}

- (IBAction)displaySuccessNotificationButtonTapped:(id)sender
{
    [TDNotificationPanel showNotificationPanelInView:self.view
                                                type:TDNotificationTypeSuccess
                                               title:@"Success Notification"
                                      hideAfterDelay:3];
}

- (IBAction)displayLongTaskNotificationButtonTapped:(id)sender
{
    TDNotificationPanel *panel = [TDNotificationPanel showNotificationPanelInView:self.view
                                                                         animated:YES];
    [panel setTitleText:@"Long Task"];
    [panel setNotificationType:TDNotificationTypeSuccess];
    
    double delayInSeconds = 5.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [TDNotificationPanel hideNotificationPanelInView:self.view
                                                animated:YES];
    });
}

- (IBAction)persistentNotificationButtonTapped:(id)sender
{
    [TDNotificationPanel showNotificationPanelInView:self.view.window
                                                type:TDNotificationTypeInfo
                                               title:@"Persistent Notification"
                                      hideAfterDelay:6];
}

@end
