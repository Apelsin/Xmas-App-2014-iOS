//
//  VoteViewController.h
//  Xmas-app-iOS
//
//  Created by Mozilla on 11/7/14.
//  Copyright (c) 2014 MZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface VoteViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewPreview;
@property (strong, nonatomic) IBOutlet UIView *bbItemScan;
- (IBAction)scanAction:(id)sender;

@end
