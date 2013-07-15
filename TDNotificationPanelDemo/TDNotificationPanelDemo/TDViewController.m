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
    [TDNotificationPanel showNotificationInView:self.view
                                           type:TDNotificationTypeError
                                          title:@"Error Notification"
                                       subtitle:@"Subtitle"
                                 hideAfterDelay:3];
}

- (IBAction)displayMessageNotificationButtonTapped:(id)sender
{
    [TDNotificationPanel showNotificationInView:self.view
                                           type:TDNotificationTypeMessage
                                          title:@"Message Notification"
                                       subtitle:nil
                                 hideAfterDelay:3];
}

- (IBAction)displaySuccessNotificationButtonTapped:(id)sender
{
    [TDNotificationPanel showNotificationInView:self.view
                                           type:TDNotificationTypeSuccess
                                          title:@"Success Notification"
                                       subtitle:nil
                                 hideAfterDelay:3];
}

- (IBAction)displayLongTaskNotificationButtonTapped:(id)sender
{
    TDNotificationPanel *panel = [TDNotificationPanel showNotificationInView:self.view
                                                                    animated:YES];
    [panel setTitleText:@"Posting Message"];
//    [panel setSubtitleText:@"Subtitle"];
    [panel setNotificationType:TDNotificationTypeMessage];
    [panel setNotificationMode:TDNotificationModeProgressBar];
    [panel setDismissable:NO];
    
    dispatch_queue_t fillProgressIndicatorQueue = dispatch_queue_create("com.TomDiggle.TDNotificatioPanelDemo.fillProgressIndicatorQueue", NULL);
	dispatch_async(fillProgressIndicatorQueue, ^{
        // This just increases the progress indicator in a loop
        float progress = 0.0f;
        while (progress < 1.0f)
        {
            progress += 0.01f;
            dispatch_async(dispatch_get_main_queue(), ^{
                [[panel progressIndicator] setProgress:progress];
            });
            usleep(50000);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the title to show task has been completed.
            [panel setTitleText:@"Message Posted"];
        });
	});
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6.0 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [TDNotificationPanel hideNotificationInView:self.view
                                                animated:YES];
    });
}

- (IBAction)persistentNotificationButtonTapped:(id)sender
{
    [TDNotificationPanel showNotificationInView:self.view.window
                                           type:TDNotificationTypeMessage
                                          title:@"Persistent Notification"
                                       subtitle:nil
                                 hideAfterDelay:6];
}

@end
