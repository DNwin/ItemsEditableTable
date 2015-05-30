//
//  BNRImageStore.h
//  Homepwner
//
//  Created by Dennis Nguyen on 5/23/15.
//  Copyright (c) 2015 dnwin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BNRImageStore : NSObject

+ (instancetype)sharedStore;

- (void)setImage:(UIImage *)image forKey:(NSString *)key; // Set an image using a key
- (UIImage *)imageForKey:(NSString *)key;
- (void)deleteImageForKey:(NSString *)key;

@end
