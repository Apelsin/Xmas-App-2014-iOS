//
//  SpecialWebviewController.m
//  Xmas-app-iOS
//
//  Created by Vincent Brubaker-Gianakos on 10/31/14.
//  Copyright (c) 2014 CITP. All rights reserved.
//

#import "SpecialWebViewController.h"

@interface SpecialWebViewController ()
@property NSString *_TargetAnchor;
@property NSURL *_LastRequestURL;
@end

@implementation SpecialWebViewController

@synthesize webView;
@synthesize InitialLocation;
@synthesize InitialReferrer;
@synthesize BackgroundPatternName;
@synthesize AutoTitle;

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
    webView.delegate = self;
    @try {
        if(self.InitialLocation)
            [self visit:self.InitialLocation relativeTo:[self.InitialReferrer stringByDeletingLastPathComponent]];
    }
    @catch (NSException *exception) {
        NSLog( @"Exception: %@", exception.name);
        NSLog( @"Reason: %@", exception.reason );
    }
    if(self.BackgroundPatternName)
        [BackgroundPattern setViewBackgroundPatternFromNamedPattern:self.view withPatternName:self.BackgroundPatternName];
}

- (void)visit:(NSString *)uriString
{
    [self visit:uriString relativeTo:nil];
}

- (void)visit:(NSString *)uriString relativeTo:(NSString *)relativePath
{
    NSArray *components = [uriString componentsSeparatedByString:@"#"];
    uriString = components[0];
    NSString *anchor = nil;
    if(components.count > 1)
        anchor = components[1];
    
    if([uriString hasPrefix:@"file:///"])
        uriString = [uriString substringFromIndex:7];
    
    if([uriString rangeOfString:@"://"].location == NSNotFound)
    {
        
        if([uriString hasPrefix:@"/"]) // Local Path
        {
            NSString *dirname = [uriString stringByDeletingLastPathComponent];
            NSString *basename = [uriString lastPathComponent];
            NSString *name = [basename stringByDeletingPathExtension];
            NSString *extension = [basename pathExtension];
            NSString *url_string = [[NSBundle mainBundle] pathForResource:name ofType:extension inDirectory:dirname];
            [self asyncVisitURL:[NSURL fileURLWithPath:url_string] withAnchor:anchor];
        }
        else // Relative Path
        {
            NSString *url_string = [relativePath stringByAppendingPathComponent:uriString];
            [self asyncVisitURL:[NSURL URLWithString:url_string] withAnchor:anchor];
        }
    }
    else // Non-local Path
    {
        [self asyncVisitURL:[NSURL URLWithString:uriString] withAnchor:anchor];
    }
}

- (void)asyncVisitURL:(NSURL *) url
{
    [self asyncVisitURL:url withAnchor:nil];
}

- (void)asyncVisitURL:(NSURL *) url withAnchor:(NSString *)anchor
{
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init]; // I don't know what this line does
    [NSURLConnection sendAsynchronousRequest:request queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if([data length] > 0 && error == nil)
                               {
                                   [self.webView loadRequest:request];
                                   self._TargetAnchor = anchor; // Hack
                                   self._LastRequestURL = request.URL; // Hack
                               }
                               else if(error != nil)
                                   NSLog(@"Error: %@", error);
                           }];
}


- (void)webViewDidFinishLoad:(UIWebView *)wv
{
    if(self.AutoTitle)
        self.title = [wv stringByEvaluatingJavaScriptFromString:@"document.title"];
    if(self._TargetAnchor)
    {
        [self.webView stringByEvaluatingJavaScriptFromString:
         [NSString stringWithFormat:@"window.location.hash = '#%@'; window.FragmentChanged();", self._TargetAnchor]];
        self._TargetAnchor = nil;
    }
}

- (BOOL)handleAppRequest:(NSURLRequest *)request withComponents:(NSArray *)components
{
    if ([(NSString *)[components objectAtIndex:0] isEqualToString:@"app"])
    {
        // Implement in subclass
        return NO; // NO means it was handled
    }
    return YES; // YES means request should proceed
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestString = [[request URL] absoluteString];
    NSArray *components = [requestString componentsSeparatedByString:@":"];
    if([components count] > 1)
    {
        if(![self handleAppRequest:request withComponents:components])
            return NO;
    }
    // Fall-through
    if(navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        NSURL *url = [request URL];
        [[UIApplication sharedApplication] openURL:url];
        return NO;
    }
    return YES;
}

@end
