//
//  BNRItem.m
//  RandomItems
//
//  Created by Dennis Nguyen on 5/13/15.
//  Copyright (c) 2015 dnwin. All rights reserved.
//

#import "BNRItem.h"

@implementation BNRItem


- (void)dealloc
{
    NSLog(@"Destroyed %@", self);
}

+ (instancetype)randomItem
{
    // arrays of adj and nounts
    NSArray *randomAdjectiveList = @[@"Fluffy", @"Rusty", @"Shiny"];
    NSArray *randomNounList = @[@"Bear", @"Spork", @"Mac"];
    
    // get two random indexes from array
    NSInteger adjectiveIndex = arc4random() % [randomAdjectiveList count];
    NSInteger nounIndex = arc4random() % [randomNounList count];
    
    // make a random name from two arrays
    NSString *randomName = [NSString stringWithFormat:@"%@ %@",
                            randomAdjectiveList[adjectiveIndex],
                            randomNounList[nounIndex]];
    
    
    // random int
    int randomValue = arc4random() % 100;
    
    // random serial
    NSString *randomSerial = [NSString stringWithFormat:@"%c%c%c%c%c",
                              '0' + arc4random() % 10,
                              'A' + arc4random() % 26,
                              '0' + arc4random() % 10,
                              'A' + arc4random() % 26,
                              '0' + arc4random() % 10];
    
    
    // use self for class methods in case of subclassing
    BNRItem *newItem = [[self alloc] initWithItemName:randomName valueInDollars:randomValue serialNumber:randomSerial];
    
    return newItem;
}


// designated initializer - createas an item with name, value, serial, date, uuid
-(instancetype)initWithItemName:(NSString *)name valueInDollars:(int)value serialNumber:(NSString *)sNumber
{
    // call superclass init
    self = [super init];
    
    if(self)
    {
        _itemName = name;
        _valueInDollars = value;
        _serialNumber = sNumber;
        
        // current date and time
        _dateCreated = [[NSDate alloc] init];
        
        // set UID
        NSUUID *uuid = [[NSUUID alloc]init]; // make key
        NSString *key = [uuid UUIDString]; // key as string
        _itemKey = key;
    }
    
    return self;
}

- (instancetype)initWithItemName:(NSString *)name
{
    return [self initWithItemName:name valueInDollars:0 serialNumber:@""];
}

// override init to fulfill designated initializer
- (instancetype)init
{
    return [self initWithItemName:@"Item"];
}



// override description
- (NSString *)description
{
    NSString *descriptionString = [[NSString alloc] initWithFormat:@"%@ (%@): Worth $%d, recorded on %@", self.itemName, self.serialNumber, self.valueInDollars, self.dateCreated];
    
    return descriptionString;
}
//
//- (void)setContainedItem:(BNRItem *)item
//{
//    _containedItem = item;
//    // When given an item to contain, the contained
//    // item will be given a pointer to its container
//    item.container = self;
//}
//
//// setters and getters

//
//- (BNRItem *)containedItem
//{
//    return _containedItem;
//}
//- (void)setContainer:(BNRItem *)item
//{
//    _container = item;
//}
//- (BNRItem *)container
//{
//    return _container;
//}
//
//- (void)setItemName:(NSString *)str
//{
//    _itemName = str;
//}
//- (NSString *)itemName
//{
//    return _itemName;
//}
//
//- (void)setSerialNumber:(NSString *)str
//{
//    _serialNumber = str;
//}
//- (NSString *)serialNumber
//{
//    return _serialNumber;
//}
//
//- (void)setValueInDollars:(int)v
//{
//    _valueInDollars = v;
//}
//- (int)valueInDollars
//{
//    return _valueInDollars;
//}
//
//- (NSDate *)dateCreated
//{
//    return _dateCreated;
//}
//




@end
