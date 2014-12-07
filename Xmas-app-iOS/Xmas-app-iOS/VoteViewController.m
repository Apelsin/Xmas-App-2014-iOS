//
//  VoteViewController.m
//  Xmas-app-iOS
//
//  Created by Sreenidhi Pundi Muralidharan on 11/7/14.
//  Copyright (c) 2014 CITP. All rights reserved.
//

#import "UIKit-Blocks/UIAlertView+IABlocks.h"
#import "VoteViewController.h"

@interface VoteViewController ()
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property BOOL QRCodeAlert__Presented;
@property BOOL exiting;
@property NSURL *urlScanned;
-(BOOL)startReading;
-(void)stopReading;

@end

@implementation VoteViewController
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
    
    _exiting = NO;
    _QRCodeAlert__Presented = NO;
    
    // Begin reading and await QR code metadata
    // Scanning happens automatically
    [self startReading];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)scanReady
{
    if(_QRCodeAlert__Presented)
        return NO;
    if(_exiting)
        return NO;
    return YES;
}

-(NSURL *)parseURLFromString:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    // Fix schemeless URLs:
    //NSLog(@"Resource Specifier: %@", [url resourceSpecifier]);
    if(![[url resourceSpecifier] hasPrefix:@"//"])
        return [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", urlString]];
    else if([url scheme] == nil)
        return [NSURL URLWithString:[NSString stringWithFormat:@"http:%@", urlString]];
    return url;
}

- (BOOL)startReading {
    NSError *error;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    
    [_captureSession startRunning];
    
    return YES;
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    // Only scan if we're not busy
    if([self scanReady])
    {
        if (metadataObjects != nil && [metadataObjects count] > 0)
        {
            AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
            if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
                @try
                {
                    [self handleScannedQRCodeMessage:metadataObj.stringValue];
                }
                @catch (NSException *exception)
                {
                    UIAlertController *qrca_controller;
                    UIAlertView *qrca_view;
                    @try
                    {
                        NSURL *url= [self parseURLFromString:metadataObj.stringValue];
                        if(url == nil)
                            [NSException raise:@"Invalid URL" format:@"QR code contains malformed URL: %@", metadataObj.stringValue];
                        NSString *alert_message = [NSString stringWithFormat:@"Unfamiliar host name:\n%@\nVisit anyway?", url];
                        
                        if ([UIAlertController class])
                        {
                            UIAlertAction *action_visit = [UIAlertAction actionWithTitle:@"Visit" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                _QRCodeAlert__Presented = NO;
                                [self handleScannedQRCodeMessage:metadataObj.stringValue allowAllHosts:true];
                            }];
                            
                            UIAlertAction *action_cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                                // That's all, folks
                                _QRCodeAlert__Presented = NO;
                            }];
                            
                            qrca_controller = [UIAlertController alertControllerWithTitle:@"Warning" message:alert_message preferredStyle:UIAlertControllerStyleAlert];
                            
                            // In a two-button alert that proposes a potentially risky action, the button that cancels the action should be on the right (and light-colored).
                            [qrca_controller addAction:action_visit];
                            [qrca_controller addAction:action_cancel];
                            [self presentViewController:qrca_controller animated:YES completion:nil];
                        }
                        else
                        {
                            qrca_view = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                                   message:alert_message
                                                         cancelButtonTitle:@"Cancel"
                                                         otherButtonTitles:@"Visit", nil];
                            [qrca_view setHandler:^(UIAlertView *alert, NSInteger buttonIndex) {
                                _QRCodeAlert__Presented = NO;
                            } forButtonAtIndex:0];
                            [qrca_view setHandler:^(UIAlertView *alert, NSInteger buttonIndex) {
                                _QRCodeAlert__Presented = NO;
                                [self handleScannedQRCodeMessage:metadataObj.stringValue allowAllHosts:true];
                            } forButtonAtIndex:1];
                            [qrca_view performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:true];
                        }

                    }
                    @catch(NSException *url_exception)
                    {
                        NSString *alert_message = [NSString stringWithFormat:@"QR code is not a valid URL. Message:\n\n%@", metadataObj.stringValue];
                        
                        if ([UIAlertController class])
                        {
                            UIAlertAction *action_ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                                // That's all, folks
                                _QRCodeAlert__Presented = NO;
                            }];
                            
                            qrca_controller = [UIAlertController alertControllerWithTitle:@"Error" message:alert_message preferredStyle:UIAlertControllerStyleAlert];
                            [qrca_controller addAction:action_ok];
                            [self presentViewController:qrca_controller animated:YES completion:nil];
                        }
                        else
                        {
                            qrca_view = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                   message:alert_message
                                                         cancelButtonTitle:@"Cancel"
                                                         otherButtonTitles: nil];
                            [qrca_view setHandler:^(UIAlertView *alert, NSInteger buttonIndex) {
                                _QRCodeAlert__Presented = NO;
                            } forButtonAtIndex:0];
                            
                            [qrca_view performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:true];
                        }
                    }
                    _QRCodeAlert__Presented = YES;
                    
                }
            }
        }
    }
}

-(void)handleScannedQRCodeMessage:(NSString *)stringValue
{
    [self handleScannedQRCodeMessage:stringValue allowAllHosts:NO];
}

-(void)handleScannedQRCodeMessage:(NSString *)stringValue allowAllHosts:(BOOL)allowAllHosts
{
    _urlScanned = nil;
    NSLog(@"Scanned QR code message: %@", stringValue);
    NSURL *url = [self parseURLFromString:stringValue];
    if(allowAllHosts)
    {
        [self exitWithURL_async:url];
    }
    else
    {
        NSArray *allowed_hosts = [[self AllowedHosts] componentsSeparatedByString:@";"];
        if([allowed_hosts containsObject:url.host])
        {
            [self exitWithURL_async:url];
        }
        else
        {
            [NSException raise:@"Domain not allowed" format:@"Scanned domain: %@; allowed domains: %@", url.host, allowed_hosts];
        }
    }
}

-(void)stopReading
{
    [_captureSession stopRunning];
    _captureSession = nil;
    [_videoPreviewLayer removeFromSuperlayer];
}

-(void)stopReading_async
{
    [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
}

-(void)exitWithURL:(NSURL *)url
{
    _urlScanned = url;
    [[self navigationController] popViewControllerAnimated:YES];
    [self stopReading];
    _exiting = YES;
}

-(void)exitWithURL_async:(NSURL *)url
{
    [self performSelectorOnMainThread:@selector(exitWithURL:) withObject:url waitUntilDone:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self stopReading_async];
}

-(void)viewDidDisappear:(BOOL)animated
{
    if(_urlScanned != nil)
        [[UIApplication sharedApplication] openURL:_urlScanned];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

@end
