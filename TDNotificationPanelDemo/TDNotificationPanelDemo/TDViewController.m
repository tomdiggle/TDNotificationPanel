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
                                          title:@"Network Error"
                                       subtitle:@"Check your network connection."
                                           type:TDNotificationTypeError
                                           mode:TDNotificationModeText
                                    dismissible:YES
                                 hideAfterDelay:3];
}

- (IBAction)displayMessageNotificationButtonTapped:(id)sender
{
    [TDNotificationPanel showNotificationInView:self.view
                                          title:@"Message"
                                       subtitle:nil
                                           type:TDNotificationTypeMessage
                                           mode:TDNotificationModeText
                                    dismissible:YES
                                 hideAfterDelay:3];
}

- (IBAction)displaySuccessNotificationButtonTapped:(id)sender
{
    [TDNotificationPanel showNotificationInView:self.view
                                          title:@"Success"
                                       subtitle:nil
                                           type:TDNotificationTypeSuccess
                                           mode:TDNotificationModeText
                                    dismissible:YES
                                 hideAfterDelay:3];
}

- (IBAction)displayLongTaskNotificationButtonTapped:(id)sender
{
    TDNotificationPanel *panel = [[TDNotificationPanel alloc] initWithView:self.view
                                                                     title:@"Posting Message"
                                                                  subtitle:nil
                                                                      type:TDNotificationTypeMessage
                                                                      mode:TDNotificationModeProgressBar
                                                               dismissible:NO];
    [[self view] addSubview:panel];
    [panel show];
    
    dispatch_queue_t fillProgressIndicatorQueue = dispatch_queue_create("com.TomDiggle.TDNotificatioPanelDemo.fillProgressIndicatorQueue", NULL);
	dispatch_async(fillProgressIndicatorQueue, ^{
        // This just increases the progress indicator in a loop
        float progress = 0.0f;
        while (progress < 1.0f)
        {
            progress += 0.01f;
            dispatch_async(dispatch_get_main_queue(), ^{
                [panel setProgress:progress];
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
        [TDNotificationPanel hideNotificationInView:self.view];
    });
}

- (IBAction)persistentNotificationButtonTapped:(id)sender
{
    [TDNotificationPanel showNotificationInView:self.view.window
                                          title:@"Persistent Notification"
                                       subtitle:nil
                                           type:TDNotificationTypeMessage
                                           mode:TDNotificationModeText
                                    dismissible:YES
                                 hideAfterDelay:6];
}

- (IBAction)displayActivityIndicatorNotification:(id)sender
{
    [TDNotificationPanel showNotificationInView:self.view
                                          title:@"Importing media..."
                                       subtitle:nil
                                           type:TDNotificationTypeMessage
                                           mode:TDNotificationModeActivityIndicator
                                    dismissible:YES
                                 hideAfterDelay:3];
}

@end
