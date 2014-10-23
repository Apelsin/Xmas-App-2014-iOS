//
//  ImageViewController.m
//  ZoomTest
//
//  Created by AJGM on 7/2/14.
//  Copyright (c) 2014 AJGM. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

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
    // ImageView setup
	//[self.imageView setBackgroundColor:[UIColor blueColor]];
	//self.imageView.image = [UIImage imageNamed:@"landscape.JPG"];

	// Scrollview setup
	//  [self.scrollView setBackgroundColor:[UIColor greenColor]];

	//self.scrollView.contentSize = self.imageView.bounds.size; // Doesn't do anything
	//self.imageView.center = self.scrollView.center; // Doesn't do anything
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return self.imageView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)tapRecognized:(id)sender {
	if (!tapped) {
		CGPoint tapPoint = [self.tapGesture locationOfTouch:0 inView:self.tapGesture.view];
		CGRect zoomRect = [self zoomRectForScrollView:self.scrollView withScale:2.0f withCenter:tapPoint];
		[self.scrollView zoomToRect:zoomRect animated:YES];
		tapped = YES;
	} else {
		[self.scrollView setZoomScale:1.0f animated:YES];
		tapped = NO;
	}	
}

/* Apple's utility method that converts a specified scale and center point to a rectangle for zooming */
- (CGRect)zoomRectForScrollView:(UIScrollView *)scrollView withScale:(float)scale withCenter:(CGPoint)center {
	CGRect zoomRect;
	zoomRect.size.height = scrollView.frame.size.height / scale;
	zoomRect.size.width = scrollView.frame.size.width / scale;
	zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0);
	zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
	return zoomRect;
}

@end
