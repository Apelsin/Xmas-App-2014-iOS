//
//  SpecialWebviewController.m
//  Xmas-app-iOS
//
//  Created by Vincent Brubaker-Gianakos on 10/31/14.
//  Copyright (c) 2014 MZ. All rights reserved.
//

#import "SpecialWebViewController.h"

@interface SpecialWebViewController ()
@property NSString *_TargetAnchor;

@end

@implementation SpecialWebViewController

@synthesize webView;
@synthesize InitialLocalPath;
@synthesize InitialURLString;
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
        if(self.InitialLocalPath)
            [self visitLocal:self.InitialLocalPath];
        else if(self.InitialURLString)
            [self visit:self.InitialURLString];
    }
    @catch (NSException *exception) {
        NSLog( @"Exception: %@", exception.name);
        NSLog( @"Reason: %@", exception.reason );
    }
    if(self.BackgroundPatternName)
        [BackgroundPattern setViewBackgroundPatternFromNamedPattern:self.view withPatternName:self.BackgroundPatternName];
}

- (void)visit:(NSString *)urlString
{
    NSArray *components = [urlString componentsSeparatedByString:@"#"];
    urlString = components[0];
    NSString *anchor = nil;
    if(components.count > 1)
        anchor = components[1];
    if([urlString hasPrefix:@"file:///"])
        [self asyncVisitURL:[NSURL fileURLWithPath:[urlString substringFromIndex:7]] withAnchor:anchor];
    else
        [self asyncVisitURL:[NSURL URLWithString:urlString]];
}

- (void)visitLocal:(NSString *)localPath
{
    NSArray *components = [localPath componentsSeparatedByString:@"#"];
    localPath = components[0];
    NSString *anchor = nil;
    if(components.count > 1)
        anchor = components[1];
    // TO-DO: get anchor to work
    
    NSString *dirname = [localPath stringByDeletingLastPathComponent];
    NSString *basename = [localPath lastPathComponent];
    NSString *title = [basename stringByDeletingPathExtension];
    NSString *extension = [basename pathExtension];
    NSString *url_string = [[NSBundle mainBundle] pathForResource:title ofType:extension inDirectory:dirname];
    [self asyncVisitURL:[NSURL fileURLWithPath:url_string] withAnchor:anchor];
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
         [NSString stringWithFormat:@"window.location.hash = '#%@'; hashChanged();", self._TargetAnchor]];
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
    return [components count] > 1 && [self handleAppRequest:request withComponents:components];
}

@end
