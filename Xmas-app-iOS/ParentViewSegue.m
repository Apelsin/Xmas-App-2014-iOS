//
//  ParentViewSegue.m
//  Xmas-app-iOS
//
//  Created by Vincent Brubaker-Gianakos on 10/19/14.
//  Copyright (c) 2014 MZ. All rights reserved.
//

#import "ParentViewSegue.h"

@implementation ParentViewSegue

- (void)perform
{
    [[[self sourceViewController] parentViewController ]presentModalViewController:[self destinationViewController]animated:YES];
}

@end
