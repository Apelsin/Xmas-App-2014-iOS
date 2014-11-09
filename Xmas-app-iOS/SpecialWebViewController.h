//
//  SpecialWebviewController.h
//  Xmas-app-iOS
//
//  Created by Vincent Brubaker-Gianakos on 10/31/14.
//  Copyright (c) 2014 MZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackgroundPattern.h"

@interface SpecialWebViewController : UIViewController <UIWebViewDelegate, BackgroundPatternDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property NSString *InitialLocalPath;
@property NSString *InitialURLString;
- (void)visit:(NSString *)urlString;
- (void)visitLocal:(NSString *)localPath;
- (void)asyncVisitURL:(NSURL *) url;

@end
