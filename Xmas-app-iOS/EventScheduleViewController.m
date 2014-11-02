//
//  EventScheduleView.m
//  Xmas-app-iOS
//
//  Created by Vincent Brubaker-Gianakos on 10/19/14.
//  Copyright (c) 2014 MZ. All rights reserved.
//

#import <EventKit/EventKit.h>
#import "AppDelegate.h"
#import "ALAlertBanner/ALAlertBanner.h"
#import "EventScheduleViewController.h"

@interface EventScheduleViewController ()

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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self visitLocal:@"/html/event_schedule.html"];
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
            banner = [ALAlertBanner alertBannerForView:appDelegate.window style:ALAlertBannerStyleSuccess position:ALAlertBannerPositionUnderNavBar title:@"Calendar event added" subtitle:controller.event.title];
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
        
        if([first isEqualToString:@"//calendar"])
        {
            EKEventStore *store = [[EKEventStore alloc] init];
            [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
                if(!granted)
                    return;
                // Jeez this is ugly...
                NSString *title_encoded = [components objectAtIndex:2];
                NSString *where_encoded = [components objectAtIndex:3];
                NSString *when_encoded = [components objectAtIndex:4];
                NSString *title= [title_encoded stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
                NSString *where = [where_encoded stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
                NSString *when = [when_encoded stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
                
                self.selectedEvent = [EKEvent eventWithEventStore:store];
                self.selectedEvent.calendar = store.defaultCalendarForNewEvents;
                self.selectedEvent.title = title;
                self.selectedEvent.location = where;
                self.selectedEvent.startDate = [NSDate date];
                self.selectedEvent.endDate = [NSDate date];
                
                [self presentEventEditViewControllerWithEventStore:store];
            }];
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
