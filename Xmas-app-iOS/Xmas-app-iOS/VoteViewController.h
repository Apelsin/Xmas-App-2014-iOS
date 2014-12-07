//
//  VoteViewController.h
//  Xmas-app-iOS
//
//  Created by Sreenidhi Pundi Muralidharan on 11/7/14.
//  Copyright (c) 2014 CITP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "BackgroundPattern.h"

@interface VoteViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate, BackgroundPatternDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewPreview;
@property (strong, nonatomic) IBOutlet UIView *bbItemScan;
@property NSString *AllowedHosts;
-(void)handleScannedQRCodeMessage:(NSString *)stringValue;
-(void)handleScannedQRCodeMessage:(NSString *)stringValue allowAllHosts:(BOOL)allowAllHosts;
-(NSURL *)parseURLFromString:(NSString *)urlString;

@end
