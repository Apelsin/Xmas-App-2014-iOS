//
//  HandledSegueViewController.h
//  Xmas-app-iOS
//
//  Created by Vincent Brubaker-Gianakos on 11/8/14.
//  Copyright (c) 2014 CITP. All rights reserved.
//

#import "HandledSegueViewController.h"
#import "SegueHandlerDelegate.h"
#import "PageInfo.h"

@interface HandledSegueViewController ()

@end

@implementation HandledSegueViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionVisitExternal:(id)sender
{
    @try {
        id<PageDelegate> info = (id<PageDelegate>)sender;
        [self visitExternal:[NSURL URLWithString:info.Location]];
    }
    @catch (NSException *exception) {
        NSLog( @"Exception: %@", exception.name);
        NSLog( @"Reason: %@", exception.reason );
    }
}

- (void)visitExternal:(NSURL *) url
{
    [[UIApplication sharedApplication] openURL:url];
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
