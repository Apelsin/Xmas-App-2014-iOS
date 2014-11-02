//
//  ViewController.m
//  Xmas-app-iOS
//
//  Created by Mozilla on 10/11/14.
//  Copyright (c) 2014 MZ. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSString *sponsorsFullURL = @"http://christmasinthepark.com/sponsors.html";
    NSURL *sponsorsURL = [NSURL URLWithString:sponsorsFullURL];
    NSURLRequest *requestSponsors = [NSURLRequest requestWithURL:sponsorsURL];
    [_sponsorWebview loadRequest:requestSponsors];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, 
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
}

- (IBAction)handlePinch:(UIPinchGestureRecognizer *)recognizer
{
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1;    
}


@end
