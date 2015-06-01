//
//  BNRItemCell.m
//  Homepwner
//
//  Created by Dennis Nguyen on 5/31/15.
//  Copyright (c) 2015 dnwin. All rights reserved.
//

#import "BNRItemCell.h"

@implementation BNRItemCell

- (IBAction)showImage:(id)sender
{
    if (self.actionBlock)
    {
        self.actionBlock();
    }
}



@end
