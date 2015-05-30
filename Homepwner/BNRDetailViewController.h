//
//  BNRDetailViewController.h
//  Homepwner
//
//  Created by Dennis Nguyen on 5/22/15.
//  Copyright (c) 2015 dnwin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNRItem;

@interface BNRDetailViewController : UIViewController

// Designated initializer, checks if it is for a new item
- (instancetype)initForNewItem:(BOOL)isNew;

@property (nonatomic, strong)BNRItem *item;
@property (nonatomic, copy) void (^dismissBlock)(void); // Block

@end
