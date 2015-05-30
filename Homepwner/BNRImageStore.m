//
//  BNRImageStore.m
//  Homepwner
//
//  Created by Dennis Nguyen on 5/23/15.
//  Copyright (c) 2015 dnwin. All rights reserved.
//

#import "BNRImageStore.h"
@interface BNRImageStore()

@property (nonatomic, strong) NSMutableDictionary *dictionary; // Stores UIimages paired with a unique key  


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
        
        // On low memory warning, clear the dictionary
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self
               selector:@selector(clearCache:)
                   name:UIApplicationDidReceiveMemoryWarningNotification
                 object:nil];
    }
    
    return self;
}



// METHODS //




// add object to dictionary using key
- (void)setImage:(UIImage *)image forKey:(NSString *)key
{
    //[self.dictionary setObject:image forKey:key];
    self.dictionary[key] = image;
    
    // Create full path for image
    NSString *imagePath = [self imagePathForKey:key];
    // convert image into NSData
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    
    // Write to the path
    [data writeToFile:imagePath atomically:YES];
}

// get image using a certain key
- (UIImage *)imageForKey:(NSString *)key
{
    // return [self.dictionary objectForKey:key];
    
    // Try to get image from dictionary
    UIImage *result = self.dictionary[key];
    
    // Get from file system if unsuccessful
    if (!result) {
        NSString *imagePath = [self imagePathForKey:key];
        // Get UIImage from file
        result = [UIImage imageWithContentsOfFile:imagePath];
        
        // If file is found, place into the cache
        if (result) {
            self.dictionary[key] = result;
        }
        else {
            NSLog(@"Error: unable to find %@", [self imagePathForKey:key]);
        }
    }
    
    return result;
}

- (void)deleteImageForKey:(NSString *)key
{
    if (!key)
    {
        return;
    }
    
    [self.dictionary removeObjectForKey:key];
    
    NSString *imagePath = [self imagePathForKey:key];
    [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
}


#pragma mark Storage

// Returns a directory path for a single image as string using a key
- (NSString *)imagePathForKey:(NSString *)key
{
    // Get valid directories
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:key];
}

- (void)clearCache:(NSNotification *)n
{
    // Relinquish all ownership on images, when they are needed again then call from filesystem.
    NSLog(@"flushing %d images out of the cache", (int)[self.dictionary count]);
    [self.dictionary removeAllObjects];
}


@end
