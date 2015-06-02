//
//  BNRItem.h
//  RandomItems
//
//  Created by Dennis Nguyen on 5/13/15.
//  Copyright (c) 2015 dnwin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BNRItem : NSObject <NSCoding>

    
@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *serialNumber;
@property (nonatomic) int valueInDollars;
@property (nonatomic, readonly, strong) NSDate *dateCreated;

@property (nonatomic, strong) NSString *itemKey; // stores key for dictionary
@property (nonatomic, strong) UIImage *thumbnail; // Stores a small thumbnail


// Takes a UIImage and sets it as its thumbnail
- (void)setThumbnailFromImage:(UIImage *)image; 


+ (instancetype)randomItem;

// Designated initializer for BNRItem
- (instancetype)initWithItemName:(NSString *)name
          valueInDollars:(int)value
            serialNumber:(NSString *)sNumber;
- (instancetype)initWithItemName:(NSString *)name;

//- (void)setItemName:(NSString *)str;
//- (NSString *)itemName;
//
//- (void)setSerialNumber:(NSString *)str;
//- (NSString *)serialNumber;
//
//- (void)setValueInDollars:(int)v;
//- (int)valueInDollars;
//
//// only getter
//- (NSDate *)dateCreated;


@end
  