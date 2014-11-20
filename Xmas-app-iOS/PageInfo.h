//
//  FlatPageDelegate.h
//  Xmas-app-iOS
//
//  Created by Vincent Brubaker-Gianakos on 11/8/14.
//  Copyright (c) 2014 MZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PageDelegate
@property NSString *Title;
@property NSString *Location;
@property NSString *Referrer;
@end

@interface PageInfo: NSObject <PageDelegate>
@end