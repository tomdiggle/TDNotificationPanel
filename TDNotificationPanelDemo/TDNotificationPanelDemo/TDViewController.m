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

@end
