//
//  BNRDrawViewController.m
//  TouchTracker
//
//  Created by Dennis Nguyen on 5/24/15.
//  Copyright (c) 2015 dnwin. All rights reserved.
//

#import "BNRDrawViewController.h"
#import "BNRDrawView.h"

@interface BNRDrawViewController ()

@end

@implementation BNRDrawViewController

#pragma define View

// loadView - setting view property to custom view
- (void)loadView
{
    // init a draw view with 0 rectangle
    self.view = [[BNRDrawView alloc] initWithFrame:CGRectZero];
}


@end
