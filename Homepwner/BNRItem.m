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

#pragma mark Methods

// Creates a thumbnail 40x40 image after passing in an image

-(void)setThumbnailFromImage:(UIImage *)image
{
    CGSize origImageSize = image.size;
    
    // Rectangle of the thumbnail 40x40
    CGRect newRect = CGRectMake(0, 0, 40, 40);
    
    // Make a scaling ratio to **maintain same ratio**
    float ratio = MAX(newRect.size.width / origImageSize.width, newRect.size.height / origImageSize.height);
    
    // Make transparent bitmap context with scaling factor equal to screen
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    
    // Create a rounded rect
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:5.0];
    
    // Clip to this rounded rect
    [path addClip];
    
    // Center image in thumbnail
    CGRect projectRect;
    projectRect.size.width = ratio * origImageSize.width;
    projectRect.size.height = ratio * origImageSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (newRect.size.width - projectRect.size.width) / 2.0;
    
    // Draw original image to it while scaling
    [image drawInRect:projectRect];
    
    // Get the image from image context and keep as thumbnail
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    self.thumbnail = smallImage;
    
    // Cleanup image context resources
    UIGraphicsEndImageContext();
};

#pragma mark NSCoding Protocols

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.itemName forKey:@"itemName"];
    [aCoder encodeObject:self.serialNumber forKey:@"serialNumber"];
    [aCoder encodeObject:self.dateCreated forKey:@"dateCreated"];
    [aCoder encodeObject:self.itemKey forKey:@"itemKey"];
    [aCoder encodeObject:self.thumbnail forKey:@"thumbnail"];
    
    [aCoder encodeInt:self.valueInDollars forKey:@"valueInDollars"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    
    self = [super init];
    if (self)
    {
        _itemName = [aDecoder decodeObjectForKey:@"itemName"];
        _serialNumber = [aDecoder decodeObjectForKey:@"serialNumber"];
        _dateCreated = [aDecoder decodeObjectForKey:@"dateCreated"];
        _itemKey = [aDecoder decodeObjectForKey:@"itemKey"];
        _thumbnail = [aDecoder decodeObjectForKey:@"thumbnail"];
        
        _valueInDollars = [aDecoder decodeIntForKey:@"valueInDollars"];
    }
    return self;
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
