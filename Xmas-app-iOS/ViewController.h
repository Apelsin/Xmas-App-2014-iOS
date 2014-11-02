//
//  ViewController.h
//  Xmas-app-iOS
//
//  Created by Mozilla on 10/11/14.
//  Copyright (c) 2014 MZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *sponsorWebview;
- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer;
- (IBAction)handlePinch:(UIPinchGestureRecognizer *)recognizer;
@end
