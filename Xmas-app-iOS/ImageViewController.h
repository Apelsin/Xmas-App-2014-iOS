//
//  ImageViewController.h
//  ZoomTest
//
//  Created by AJGM on 7/2/14.
//  Copyright (c) 2014 AJGM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController <UIScrollViewDelegate> {
	BOOL tapped;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;

- (IBAction)tapRecognized:(id)sender;

@end
