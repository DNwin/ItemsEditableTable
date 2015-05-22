//
//  BNRItem.h
//  RandomItems
//
//  Created by Dennis Nguyen on 5/13/15.
//  Copyright (c) 2015 dnwin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRItem : NSObject

    
@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *serialNumber;
@property (nonatomic) int valueInDollars;
@property (nonatomic, readonly, strong) NSDate *dateCreated;

- (void)setContainedItem:(BNRItem *)item;
- (BNRItem *)containedItem; // returns contained item

- (void)setContainer:(BNRItem *)item;
- (BNRItem *)container;




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
  