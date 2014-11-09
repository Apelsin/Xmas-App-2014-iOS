//
//  DynamicInformerViewController.m
//  Xmas-app-iOS
//
//  Created by Vincent Brubaker-Gianakos on 11/8/14.
//  Copyright (c) 2014 MZ. All rights reserved.
//

#import "HandledSegueViewController.h"
#import "SegueHandlerDelegate.h"

@interface HandledSegueViewController ()

@end

@implementation HandledSegueViewController
@synthesize BackgroundPatternName;

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
    if(self.BackgroundPatternName)
        [BackgroundPattern setViewBackgroundPatternFromNamedPattern:self.view withPatternName:self.BackgroundPatternName];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *destination = [segue destinationViewController];
    if([destination conformsToProtocol:@protocol(SegueHandlerDelegate)])
    {
        [(id<SegueHandlerDelegate>)destination handleSeguePreparation:segue sender:sender];
    }
}


@end
