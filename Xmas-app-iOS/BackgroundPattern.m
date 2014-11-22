//
//  BackgroundPatternDelegate.m
//  Xmas-app-iOS
//
//  Created by Vincent Brubaker-Gianakos on 11/8/14.
//  Copyright (c) 2014 CITP. All rights reserved.
//

#include "BackgroundPattern.h"

@implementation BackgroundPattern
+ (void)setViewBackgroundPatternFromNamedPattern:(UIView *)view withPatternName:(NSString *)name
{
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:name]];
}
@end