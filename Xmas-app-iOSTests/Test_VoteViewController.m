//
//  Test_VoteViewController.m
//  Xmas-app-iOS
//
//  Created by Vincent Brubaker-Gianakos on 11/16/14.
//  Copyright (c) 2014 MZ. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VoteViewController.h"

@interface Test_VoteViewController : XCTestCase
@property VoteViewController *controller;
@end

@implementation Test_VoteViewController

- (void)setUp
{
    [super setUp];
    _controller = [[VoteViewController alloc]init];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testScannedQRCodeMessage
{
    _controller.allowedHosts = @"christmasinthepark.com;paypal.com";
    XCTAssertNoThrow([_controller handleScannedQRCodeMessage:@"http://christmasinthepark.com/vote/something.html"]);
    XCTAssertNoThrow([_controller handleScannedQRCodeMessage:@"https://paypal.com/stuff/things"]);
    XCTAssertThrows([_controller handleScannedQRCodeMessage:@"http://notchristmasinthepark.com"], @"Should throw exception");
    XCTAssertThrows([_controller handleScannedQRCodeMessage:@"https://payeepal.com/foobar"], @"Should throw exception");
}

- (void)testParseURLFromString
{
    NSString *desired, *input, *output;
    desired = input = @"http://christmasinthepark.com/vote.php?id=1234";
    output = [[_controller parseURLFromString:@"http://christmasinthepark.com/vote.php?id=1234"] absoluteString];
    XCTAssertEqual(output, desired);
    input = @"//christmasinthepark.com/vote.php?id=1234";
    output = [[_controller parseURLFromString:@"http://christmasinthepark.com/vote.php?id=1234"] absoluteString];
    XCTAssertEqual(output, desired);
    input = @"christmasinthepark.com/vote.php?id=1234";
    output = [[_controller parseURLFromString:@"http://christmasinthepark.com/vote.php?id=1234"] absoluteString];
    XCTAssertEqual(output, desired);
}

@end
