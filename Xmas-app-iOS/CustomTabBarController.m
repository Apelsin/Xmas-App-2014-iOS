//
//  CustomTabBarController.m
//  Xmas-app-iOS
//
//  Created by Vincent Brubaker-Gianakos on 11/8/14.
//  Copyright (c) 2014 CITP. All rights reserved.
//

#import "CustomTabBarController.h"

@interface CustomTabBarController ()
@end

@implementation CustomTabBarController

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
    self.delegate = self;
    // Do any additional setup after loading the view.
    // Set title colors
    [self.tabBar setSelectedImageTintColor:_ColorActive];
    [self.tabBar setTintColor:_ColorActive];
    for(int i = 0; i < self.tabBar.items.count; i++)
    {
        UITabBarItem *item = [self.tabBar.items objectAtIndex:i];
        UIImage *image_selected = [item.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [item setSelectedImage:image_selected];
        UIImage *image = [item.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [item setImage:image];
        [item setTitleTextAttributes:@{
                                       NSForegroundColorAttributeName : _ColorActive,
                                       NSFontAttributeName: [UIFont fontWithName:@"Cochin" size:12.f],
                                       }
                            forState:UIControlStateSelected];
        [item setTitleTextAttributes:@{
                                       NSForegroundColorAttributeName : _ColorInactive,
                                       NSFontAttributeName: [UIFont fontWithName:@"Cochin" size:12.f],
                                       }
                            forState:UIControlStateNormal];
    }
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    //if([viewController respondsToSelector:@selector(adjustSubviews)])
    //{
    //    [viewController performSelector:@selector(adjustSubviews) withObject:nil];
    //}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate
{
    return [self.selectedViewController shouldAutorotate];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
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

@end
