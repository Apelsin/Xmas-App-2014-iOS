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
	if (self.scrollView.zoomScale == 1.0)
    {
		CGPoint tapPoint = [self.tapGesture locationOfTouch:0 inView:self.tapGesture.view];
		CGRect zoomRect = [self zoomRectForScrollView:self.scrollView withScale:5.0f withCenter:tapPoint];
		[self.scrollView zoomToRect:zoomRect animated:YES];
	}
    else
    {
		[self.scrollView setZoomScale:1.0f animated:YES];
	}	
}

/* Apple's utility method that converts a specified scale and center point to a rectangle for zooming */
- (CGRect)zoomRectForScrollView:(UIScrollView *)scrollView withScale:(float)scale withCenter:(CGPoint)center {
	CGRect zoomRect;
    float scale_recip = 1.0f / scale;
    float ratio = scrollView.frame.size.width / scrollView.frame.size.height;
    float ratio_recip = 1.0f / ratio;
    zoomRect.size.width = scrollView.frame.size.width * scale_recip;
	zoomRect.size.height = scrollView.frame.size.height * scale_recip;
    CGPoint offset = center;
    offset.x -= 0.5 * scrollView.frame.size.width;
    offset.y -= 0.5 * scrollView.frame.size.height;
    float originx = scrollView.contentOffset.x;
    float originy = scrollView.contentOffset.y;
	zoomRect.origin.x = originx + scale * scrollView.frame.origin.x + 0.5 * (scrollView.frame.size.width - zoomRect.size.width) + offset.x;
	zoomRect.origin.y = originy + scale * scrollView.frame.origin.y + ratio * 0.5 * (scrollView.frame.size.height - zoomRect.size.height) + offset.y;
	return zoomRect;
}

@end
