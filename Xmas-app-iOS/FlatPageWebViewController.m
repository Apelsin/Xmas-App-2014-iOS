//
//  FlatPageWebViewController.m
//  Xmas-app-iOS
//
//  Created by Vincent Brubaker-Gianakos on 11/8/14.
//  Copyright (c) 2014 MZ. All rights reserved.
//

#import "FlatPageWebViewController.h"
#import "FlatPageDelegate.h"

@interface FlatPageWebViewController ()
@end

@implementation FlatPageWebViewController
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

// This should be called before viewDidLoad
- (void) handleSeguePreparation:(UIStoryboardSegue *)segue sender:(id)sender
{
    @try {
        // WTF Objective-C???
        id<FlatPageDelegate> info = (id<FlatPageDelegate>)sender;
        self.title = info.Title;
        self.InitialLocalPath = info.Path;
    }
    @catch (NSException *exception) {
        NSLog( @"Exception: %@", exception.name);
        NSLog( @"Reason: %@", exception.reason );
    }
    @finally {
    }
    
}


@end
