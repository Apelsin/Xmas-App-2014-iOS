//
//  EventScheduleView.m
//  Xmas-app-iOS
//
//  Created by Vincent Brubaker-Gianakos on 10/19/14.
//  Copyright (c) 2014 CITP. All rights reserved.
//

#import <EventKit/EventKit.h>
#import "AppDelegate.h"
#import "ALAlertBanner/ALAlertBanner.h"
#import "CJSON/NSDictionary_JSONExtensions.h"
#import "EventScheduleViewController.h"

@interface EventScheduleViewController ()
@property ALAlertBanner *infoBanner;
@property EKEvent *selectedEvent;
@property NSDateFormatter *ISO8601DateFormatter;
@end

@implementation EventScheduleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// initWithNibName doesn't get called...
- (void)awakeFromNib
{
    self.ISO8601DateFormatter = [NSDateFormatter new];
    [self.ISO8601DateFormatter setDateFormat:@"yyyy-MM-d'T'HH:mm:ss.SSSZ"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [ALAlertBanner forceHideAllAlertBannersInView:appDelegate.window];
    self.infoBanner = [ALAlertBanner
              alertBannerForView:appDelegate.window
              style:ALAlertBannerStyleNotify
              position:ALAlertBannerPositionUnderNavBar
              title:@"Touch an event to add it to your calendar."];
    [self.infoBanner show];
}

-(void)viewWillDisappear:(BOOL)animated
{
    //[self.infoBanner hide];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [ALAlertBanner forceHideAllAlertBannersInView:appDelegate.window];
}

- (void)presentEventEditViewControllerWithEventStore:(EKEventStore*)eventStore {
    EKEventEditViewController *eventEditVC = [[EKEventEditViewController alloc] init];
    eventEditVC.editViewDelegate = self;
    eventEditVC.eventStore = eventStore;
    eventEditVC.event = self.selectedEvent;
    // Extend the current navigation controller with the first controller inside the EKEditEventViewController
    //[self.eventEditVC setValue:self forKeyPath:@"_parentViewController"];
    [self presentViewController:eventEditVC animated:YES completion:nil];
}

- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action
{
    NSError *error = nil;
    ALAlertBanner *banner = nil;
    AppDelegate *appDelegate = nil;
    switch (action) {
        case EKEventEditViewActionCanceled:
        break;
        case EKEventEditViewActionSaved:
            [controller.eventStore saveEvent:controller.event span:EKSpanThisEvent error:&error];
            appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            [ALAlertBanner forceHideAllAlertBannersInView:appDelegate.window];
            banner = [ALAlertBanner alertBannerForView:appDelegate.window style:ALAlertBannerStyleSuccess position:ALAlertBannerPositionUnderNavBar title:@"Calendar event added." subtitle:controller.event.title];
            [banner show];
        break;
        case EKEventEditViewActionDeleted:
        [controller.eventStore removeEvent:controller.event span:EKSpanThisEvent error:&error];
        break;
        default:
        break;
    }
    // Manually dismissal is necessary!
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)handleAppRequest:(NSURLRequest *)request withComponents:(NSArray *)components
{
    if ([(NSString *)[components objectAtIndex:0] isEqualToString:@"app"])
    {
        NSString *first = (NSString *)[components objectAtIndex:1];
        // TO-DO: make these handlers their own class
        if([first isEqualToString:@"//calendar"])
        {
            NSRange sub_range = NSMakeRange(2, components.count - 2);
            NSArray *sub_remainder = [components subarrayWithRange:sub_range];
            NSString *remainder_encoded = [sub_remainder componentsJoinedByString:@":"];
            NSString *remainder = [remainder_encoded stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            NSError *arg_parse_error = NULL;
            NSDictionary *arg_dict = [NSDictionary dictionaryWithJSONString:remainder error:&arg_parse_error];
            
            EKEventStore *store = [[EKEventStore alloc] init];
            [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
                // Allow the system to alert the user
                //if(!granted)
                //    return;
                NSString *title = [arg_dict valueForKey:@"title"];
                NSString *where = [arg_dict valueForKey:@"where"];
                NSString *begin = [arg_dict valueForKey:@"begin"];
                NSString *end = [arg_dict valueForKey:@"end"];
                NSDate *date_begin = [self.ISO8601DateFormatter dateFromString:begin];
                NSDate *date_end = [self.ISO8601DateFormatter dateFromString:end];
                
                self.selectedEvent = [EKEvent eventWithEventStore:store];
                self.selectedEvent.calendar = store.defaultCalendarForNewEvents;
                self.selectedEvent.title = title;
                self.selectedEvent.location = where;
                self.selectedEvent.startDate = date_begin;
                self.selectedEvent.endDate = date_end;
                
                [self presentEventEditViewControllerWithEventStore:store];
            }];
        }
        else if([first isEqualToString:@"//log"])
        {
            NSRange sub_range = NSMakeRange(2, components.count - 2);
            NSArray *sub_remainder = [components subarrayWithRange:sub_range];
            NSString *remainder_encoded = [sub_remainder componentsJoinedByString:@":"];
            NSString *remainder = [remainder_encoded stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            NSLog(@"JS: %@", remainder);
        }
        else if([first isEqualToString:@"//alert"])
        {
            NSRange sub_range = NSMakeRange(2, components.count - 2);
            NSArray *sub_remainder = [components subarrayWithRange:sub_range];
            NSString *remainder_encoded = [sub_remainder componentsJoinedByString:@":"];
            NSString *remainder = [remainder_encoded stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            NSError *arg_parse_error = NULL;
            NSDictionary *arg_dict = [NSDictionary dictionaryWithJSONString:remainder error:&arg_parse_error];
            NSString *message = [arg_dict valueForKey:@"message"];
            NSString *detail = [arg_dict valueForKey:@"detail"];
            NSString *alert_type = [arg_dict valueForKey:@"alert-type"];
            
            ALAlertBannerStyle alert_style = ALAlertBannerStyleNotify;
            
            if([alert_type hasPrefix:@"warn"])
                alert_style = ALAlertBannerStyleWarning;
            else if([alert_type hasPrefix:@"err"])
                alert_style = ALAlertBannerStyleFailure;
            else if([alert_type hasPrefix:@"success"])
                alert_style = ALAlertBannerStyleSuccess;
            
            AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            //[ALAlertBanner forceHideAllAlertBannersInView:appDelegate.window];
            ALAlertBanner *banner = [ALAlertBanner alertBannerForView:appDelegate.window style:alert_style position:ALAlertBannerPositionUnderNavBar title:message subtitle:detail];
            [banner show];
        }
        return NO;
    }
    return YES;
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
