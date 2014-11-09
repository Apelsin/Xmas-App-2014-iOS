//
//  ParkViewMapController.m
//  Xmas-app-iOS
//
//  Created by Mozilla on 11/2/14.
//  Copyright (c) 2014 MZ. All rights reserved.
//

#import "ParkMapViewController.h"
#import "AppDelegate.h"

@implementation ParkMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.infoBanner = [ALAlertBanner alertBannerForView:appDelegate.window  style:ALAlertBannerStyleNotify position:ALAlertBannerPositionUnderNavBar title:@"Swipe to pan and pinch to zoom."];
    [self.infoBanner show];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.infoBanner hide];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
