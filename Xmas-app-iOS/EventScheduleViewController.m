//
//  EventScheduleView.m
//  Xmas-app-iOS
//
//  Created by Vincent Brubaker-Gianakos on 10/19/14.
//  Copyright (c) 2014 MZ. All rights reserved.
//

#import <EventKit/EventKit.h>
#import "EventScheduleViewController.h"

@interface EventScheduleViewController ()
<UIWebViewDelegate>

@end

@implementation EventScheduleViewController

@synthesize myWebView;

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
    myWebView.delegate = self;
    // Do any additional setup after loading the view.
    //NSString *url_string = @"http://christmasinthepark.com/calendar.html";
    NSString *url_string = [[NSBundle mainBundle] pathForResource:@"event_schedule" ofType:@"html" inDirectory:@"html"];
    //NSURL *url = [NSURL URLWithString:url_string];
    NSURL *url = [NSURL fileURLWithPath:url_string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init]; // I don't know what this line does
    [NSURLConnection sendAsynchronousRequest:request queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if([data length] > 0 && error == nil)
            [self.myWebView loadRequest:request];
        else if(error != nil)
            NSLog(@"Error: %@", error);
    }];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSString *requestString = [[request URL] absoluteString];
    NSArray *components = [requestString componentsSeparatedByString:@":"];

    if ([components count] > 1 && [(NSString *)[components objectAtIndex:0] isEqualToString:@"app"])
    {
        NSString *first = (NSString *)[components objectAtIndex:1];
        
        if([first isEqualToString:@"//calendar"])
        {
            // Jeez this is ugly...
            NSString *title_encoded = [components objectAtIndex:2];
            NSString *where_encoded = [components objectAtIndex:3];
            NSString *when_encoded = [components objectAtIndex:4];
            NSString *title= [title_encoded stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            NSString *where = [where_encoded stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            NSString *when = [when_encoded stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            
            
            // TO-DO: presentEventEditViewControllerWithEventStore
            EKEventStore *store = [[EKEventStore alloc] init];
            [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
                if(!granted)
                    return;
                EKEvent *event = [EKEvent eventWithEventStore:store];
                event.title = title;
                event.startDate = [NSDate date];
                event.endDate = event.startDate;
                event.allDay = NO;
                event.location = where;
                [event setCalendar:[store defaultCalendarForNewEvents]];
                NSError *err = nil;
                [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
                NSString *savedEventId = event.eventIdentifier;
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
