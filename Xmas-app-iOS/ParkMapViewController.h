//
//  ParkViewMapController.h
//  Xmas-app-iOS
//
//  Created by Mozilla on 11/2/14.
//  Copyright (c) 2014 MZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALAlertBanner/ALAlertBanner.h"
#import "SpecialWebViewController.h"

@interface ParkMapViewController :  SpecialWebViewController
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;
- (IBAction)tapRecognized:(id)sender;
@property ALAlertBanner *infoBanner;

@end
