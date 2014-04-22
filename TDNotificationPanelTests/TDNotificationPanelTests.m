/**
 * Copyright (c) 2013-2014, Tom Diggle
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

#import <XCTest/XCTest.h>

#import <UIKit/UIKit.h>
#import "TDNotificationPanel.h"

@interface TDNotificationPanelTests : XCTestCase

@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) TDNotificationPanel *panel;

@end

@implementation TDNotificationPanelTests

- (void)setUp
{
    [super setUp];
    self.mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    self.panel = [TDNotificationPanel showNotificationInView:self.mainView
                                                       title:@"Title"
                                                    subtitle:@"Subtitle"
                                                        type:TDNotificationTypeSuccess
                                                        mode:TDNotificationModeText
                                                 dismissible:NO];
}

- (void)tearDown
{
    self.panel = nil;
    self.mainView = nil;
    [super tearDown];
}

- (void)testNotificationPanelInstantiates
{
    XCTAssertNotNil(self.panel, @"Notification panel should be not be nil.");
}

- (void)testTitleStringNotNil
{
    XCTAssertNotNil([self.panel titleText], @"Title string should not be nil.");
}

- (void)testSubtitleStringNotNil
{
    XCTAssertNotNil([self.panel subtitleText], @"Subtitle string should not be nil.");
}

- (void)testWhenNotificationModeIsActivityIndicatorNotificationTypeShouldBeMessage
{
    TDNotificationPanel *notification = [[TDNotificationPanel alloc] initWithView:self.mainView
                                                                            title:@"Title"
                                                                         subtitle:@"Subtitle"
                                                                             type:TDNotificationTypeSuccess
                                                                             mode:TDNotificationModeActivityIndicator
                                                                      dismissible:NO];
    
    XCTAssertEqual([notification notificationType], TDNotificationTypeMessage, @"When notificationType is TDNotificationModeActivityIndicator notificationType should be TDNotificationTypeMessage.");
}

- (void)testWhenNotificationModeIsProgressBarNotificationTypeShouldBeMessage
{
    TDNotificationPanel *notification = [[TDNotificationPanel alloc] initWithView:self.mainView
                                                                            title:@"Title"
                                                                         subtitle:@"Subtitle"
                                                                             type:TDNotificationTypeSuccess
                                                                             mode:TDNotificationModeProgressBar
                                                                      dismissible:NO];
    
    XCTAssertEqual([notification notificationType], TDNotificationTypeMessage, @"When notificationType is TDNotificationModeProgressBar notificationType should be TDNotificationTypeMessage.");
}

- (void)testNotificationIsHidden
{
    BOOL isHidden = [TDNotificationPanel hideNotificationInView:self.mainView];
    
    XCTAssertTrue(isHidden, @"Notification panel should be hidden.");
}

- (void)testCanFindNotificationsInView
{
    NSArray *notifications = [TDNotificationPanel notificationsInView:self.mainView];
    
    XCTAssertNotEqual([notifications count], 0, @"At least one notification panel should be returned.");
}

@end
