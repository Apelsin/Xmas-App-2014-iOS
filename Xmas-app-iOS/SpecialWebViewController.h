//
//  SpecialWebviewController.h
//  Xmas-app-iOS
//
//  Created by Vincent Brubaker-Gianakos on 10/31/14.
//  Copyright (c) 2014 MZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpecialWebViewController : UIViewController <UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;

- (void)visit:(NSString *)urlString;
- (void)visitLocal:(NSString *)localPath;
- (void)asyncVisitURL:(NSURL *) url;

@end
