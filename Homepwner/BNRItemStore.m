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
    
//    if (!sharedStore)
//    {
//        sharedStore = [[self alloc] initPrivate];
//    }
    
    // Thread safe
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[BNRItemStore alloc] initPrivate];
    });
    
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
        // load private array when it launches
        // Get path location
        NSString *path = [self itemArchivePath];
        // Initialize private array from file using path
        _privateItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        // If no saved array, create a new one
        if (!_privateItems)
        {
            _privateItems = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

#pragma mark Storage methods
- (BOOL)saveChanges
{
    NSString *path = [self itemArchivePath];
    // Return YES on success
    return [NSKeyedArchiver archiveRootObject:self.privateItems toFile:path];
}

// returns a string containing the item archive path
- (NSString *)itemArchivePath
{
    // function searches filesystem for a path that meets criteria
    // last two arguments always the same on iOS
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    // Get one document directory from list
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
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
//    BNRItem *item = [BNRItem randomItem];
    BNRItem *item = [[BNRItem alloc] init];

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
