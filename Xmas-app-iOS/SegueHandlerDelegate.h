//
//  DynamicInfoReceiver.h
//  Xmas-app-iOS
//
//  Created by Vincent Brubaker-Gianakos on 11/8/14.
//  Copyright (c) 2014 MZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SegueHandlerDelegate <NSObject>

- (void)handleSeguePreparation:(UIStoryboardSegue *)segue sender:(id)sender;

@end