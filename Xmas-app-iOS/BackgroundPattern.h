//
//  BackgroundPatternDelegate.h
//  Xmas-app-iOS
//
//  Created by Vincent Brubaker-Gianakos on 11/8/14.
//  Copyright (c) 2014 MZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BackgroundPatternDelegate <NSObject>
@property NSString *BackgroundPatternName;
@end

@interface BackgroundPattern : NSObject
+ (void)setViewBackgroundPatternFromNamedPattern:(UIView *)view withPatternName:(NSString *)name;
@end