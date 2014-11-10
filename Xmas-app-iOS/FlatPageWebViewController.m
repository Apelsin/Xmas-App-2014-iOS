//
//  FlatPageWebViewController.m
//  Xmas-app-iOS
//
//  Created by Vincent Brubaker-Gianakos on 11/8/14.
//  Copyright (c) 2014 MZ. All rights reserved.
//

#import "FlatPageWebViewController.h"
#import "FlatPageInfo.h"
#import "CJSON/NSDictionary_JSONExtensions.h"

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

- (BOOL)handleAppRequest:(NSURLRequest *)request withComponents:(NSArray *)components
{
    if ([(NSString *)[components objectAtIndex:0] isEqualToString:@"app"])
    {
        NSString *first = (NSString *)[components objectAtIndex:1];
        
        if([first isEqualToString:@"//nav/push"])
        {
            NSRange sub_range = NSMakeRange(2, components.count - 2);
            NSArray *sub_remainder = [components subarrayWithRange:sub_range];
            NSString *remainder_encoded = [sub_remainder componentsJoinedByString:@":"];
            NSString *remainder = [remainder_encoded stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            NSError *arg_parse_error = NULL;
            NSDictionary *arg_dict = [NSDictionary dictionaryWithJSONString:remainder error:&arg_parse_error];
            FlatPageInfo *info = [FlatPageInfo new];
            info.Title = [arg_dict valueForKey:@"Title"];
            info.Path = [arg_dict valueForKey:@"Path"];
            info.URLString = [arg_dict valueForKey:@"URLString"];
            [self performSegueWithIdentifier:@"FlatPage_SubPage" sender:info];
        }
        return NO;
    }
    return YES;
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

// This should be called before viewDidLoad
- (void) handleSeguePreparation:(UIStoryboardSegue *)segue sender:(id)sender
{
    @try {
        id<FlatPageDelegate> info = (id<FlatPageDelegate>)sender;
        self.title = info.Title;
        self.InitialLocalPath = info.Path;
        self.InitialURLString = info.URLString;
    }
    @catch (NSException *exception) {
        NSLog( @"Exception: %@", exception.name);
        NSLog( @"Reason: %@", exception.reason );
    }
    @finally {
    }
    
}

@end
