//
//  SpecialWebviewController.h
//  Xmas-app-iOS
//
//  Created by Vincent Brubaker-Gianakos on 10/31/14.
//  Copyright (c) 2014 CITP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackgroundPattern.h"

@interface SpecialWebViewController : UIViewController <UIWebViewDelegate, BackgroundPatternDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webViewMain;
@property (strong, nonatomic) IBOutlet UIWebView *webViewThrobber;
@property NSString *InitialLocation;
@property NSString *InitialReferrer;
@property NSString *ThrobberLocation;
@property BOOL AutoTitle;
- (void)visit:(NSString *)uriString;

@end
