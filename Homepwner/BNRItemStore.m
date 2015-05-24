//
//  BNRItemStore.m
//  Homepwner
//
//  Created by Dennis Nguyen on 5/20/15.
//  Copyright (c) 2015 dnwin. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"
#import "BNRImageStore.h"

@interface BNRItemStore()

@property (nonatomic) NSMutableArray *privateItems;

@end



@implementation BNRItemStore




// SINGLETON - lazy instantiation
+ (instancetype)sharedStore
{
    // check to see if a instance exists, then returnl
    static BNRItemStore *sharedStore = nil; // not destroyed when done executing
    
    if (!sharedStore)
    {
        sharedStore = [[self alloc] initPrivate];
    }
    
    return sharedStore;
}

#pragma mark View controller lifecycle

// if init is called, throw exception
- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[BNRItemStore sharedStore]"
                                 userInfo:nil];
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    
    // initialize array
    if (self)
    {
        _privateItems = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark Properties

- (NSArray *)allItems
{
    return self.privateItems;
}

#pragma mark Data manipulation

// adds random item to private array
- (BNRItem *)createItem
{
    BNRItem *item = [BNRItem randomItem];
    // make random item add it to private items array
    [self.privateItems addObject:item];
    
    return item;
}

// removes an item from the private array
- (void)removeItem:(BNRItem *)item
{
    // when item is removed, remove also remove image from storage
    NSString *key = item.itemKey;
    [[BNRImageStore sharedStore] deleteImageForKey:key];
    
    [self.privateItems removeObjectIdenticalTo:item];
}

// move item from index to another index
- (void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    // check if same indexes, do nothing
    if (fromIndex == toIndex)
    {
        return;
    }
    
    // point to the object
    BNRItem *item = self.privateItems[fromIndex];
    // remove from array
    [self.privateItems removeObjectAtIndex:fromIndex];
    // add to new position
    [self.privateItems insertObject:item atIndex:toIndex];
}



@end
