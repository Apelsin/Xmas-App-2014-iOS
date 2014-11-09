//
//  SpecialWebviewController.m
//  Xmas-app-iOS
//
//  Created by Vincent Brubaker-Gianakos on 10/31/14.
//  Copyright (c) 2014 MZ. All rights reserved.
//

#import "SpecialWebViewController.h"

@implementation SpecialWebViewController

@synthesize webView;
@synthesize InitialLocalPath;
@synthesize InitialURLString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)visit:(NSString *)urlString
{
    [self asyncVisitURL:[NSURL URLWithString:urlString]];
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
    @finally {
    }
    
}
- (void)visitLocal:(NSString *)localPath
{
    NSString *dirname = [localPath stringByDeletingLastPathComponent];
    NSString *basename = [localPath lastPathComponent];
    NSString *title = [basename stringByDeletingPathExtension];
    NSString *extension = [basename pathExtension];
    NSString *url_string = [[NSBundle mainBundle] pathForResource:title ofType:extension inDirectory:dirname];
    [self asyncVisitURL:[NSURL fileURLWithPath:url_string]];
}

- (void)asyncVisitURL:(NSURL *) url
{
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init]; // I don't know what this line does
    [NSURLConnection sendAsynchronousRequest:request queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if([data length] > 0 && error == nil)
                                   [self.webView loadRequest:request];
                               else if(error != nil)
                                   NSLog(@"Error: %@", error);
                           }];
}

- (void)webViewDidFinishLoad:(UIWebView *)wv
{
    if([self.title isEqual: @"_auto"])
        self.title = [wv stringByEvaluatingJavaScriptFromString:@"document.title"];
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
