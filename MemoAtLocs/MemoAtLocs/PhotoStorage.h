//
//  PhotoStorage.h
//  MemoAtLocations
//
//  Created by Tedchiu on 2013/10/27.
//  Copyright (c) 2013年 Tedchiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PhotoLibrary;

@interface PhotoStorage : NSManagedObject

@property (nonatomic, retain) NSData * photo;
@property (nonatomic, retain) PhotoLibrary *photoInfo;

@end
