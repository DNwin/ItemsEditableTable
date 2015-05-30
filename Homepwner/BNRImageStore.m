//
//  BNRImageStore.m
//  Homepwner
//
//  Created by Dennis Nguyen on 5/23/15.
//  Copyright (c) 2015 dnwin. All rights reserved.
//

#import "BNRImageStore.h"
@interface BNRImageStore()

@property (nonatomic, strong) NSMutableDictionary *dictionary;

@end
@implementation BNRImageStore


// singleton
+ (instancetype)sharedStore
{
    static BNRImageStore *sharedStore = nil;
//    
//    if (!sharedStore)
//    {
//        sharedStore = [[BNRImageStore alloc] initPrivate];
//    }
    
    // Thread safe singleton, prevents multi allocation if multithreaded
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[BNRImageStore alloc] initPrivate];
    });
    return sharedStore;
    
    
    return sharedStore;
}

// no one should call init
- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[BNRImageStore sharedStore]" userInfo:nil];
    
    return nil;
}
- (instancetype)initPrivate
{
    self = [super init];
    
    // setup dictionary on init
    if (self)
    {
        _dictionary = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

// METHODS //

// add object to dictionary using key
- (void)setImage:(UIImage *)image forKey:(NSString *)key
{
    //[self.dictionary setObject:image forKey:key];
    self.dictionary[key] = image;
}

// get image using a certain key
- (UIImage *)imageForKey:(NSString *)key
{
    // return [self.dictionary objectForKey:key];
    return self.dictionary[key];
}

- (void)deleteImageForKey:(NSString *)key
{
    if (!key)
    {
        return;
    }
    
    [self.dictionary removeObjectForKey:key];
}

@end
