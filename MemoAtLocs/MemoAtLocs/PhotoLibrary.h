//
//  PhotoLibrary.h
//  MemoAtLocations
//
//  Created by Tedchiu on 2013/10/27.
//  Copyright (c) 2013年 Tedchiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, PhotoStorage;

@interface PhotoLibrary : NSManagedObject

@property (nonatomic, retain) NSDate * photoTime;
@property (nonatomic, retain) NSData * thumbnail;
@property (nonatomic, retain) Event *placeOfPhoto;
@property (nonatomic, retain) PhotoStorage *photoData;

@end
