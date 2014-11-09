//
//  EventScheduleView.h
//  Xmas-app-iOS
//
//  Created by Vincent Brubaker-Gianakos on 10/19/14.
//  Copyright (c) 2014 MZ. All rights reserved.
//

#import <EventKitUI/EventKitUI.h>

#import "SpecialWebViewController.h"

@interface EventScheduleViewController : SpecialWebViewController <UIWebViewDelegate, EKEventEditViewDelegate>
@end
