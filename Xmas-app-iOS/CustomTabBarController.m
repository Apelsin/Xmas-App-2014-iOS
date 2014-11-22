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
    // Do any additional setup after loading the view.

    // Set title colors
    for(int i = 0; i < self.tabBar.items.count; i++)
    {
        UITabBarItem *item = [self.tabBar.items objectAtIndex:i];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName : _ColorActive,} forState:UIControlStateHighlighted];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName : _ColorInactive,} forState:UIControlStateNormal];
    }
    
    // Set the tint color for unselected tabs
    for (UIView *view in self.tabBar.subviews)
    {
      if ([NSStringFromClass(view.class) isEqual:@"UITabBarButton"])
      {
          // I really hope it's OK to do this...
          // I checked the colors in a color-blindness simulator and everything is clearly visible
          if([view respondsToSelector:@selector(_setUnselectedTintColor:)])
              [view performSelector:@selector(_setUnselectedTintColor:) withObject:_ColorInactive];
      }
    }
    [self.tabBar setSelectedImageTintColor:_ColorActive];
    [self.tabBar setTintColor:_ColorActive];
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
    return [self.selectedViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
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
