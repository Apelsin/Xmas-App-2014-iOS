//
//  AboutViewController.m
//  Xmas-app-iOS
//
//  Created by Vincent Brubaker-Gianakos on 11/14/14.
//  Copyright (c) 2014 CITP. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

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
}

- (void)viewDidLayoutSubviews
{
    // Repair view insets
    UIEdgeInsets currentInsets = self.webView.scrollView.contentInset;
    currentInsets.top = self.tabBarController.topLayoutGuide.length;
    self.webView.scrollView.contentInset = currentInsets;
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    // Fix the Navigation Bar problem:
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
