//
//  Event.h
//  MemoAtLocations
//
//  Created by Tedchiu on 2013/10/27.
//  Copyright (c) 2013年 Tedchiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PhotoLibrary;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSSet *photoAround;
@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addPhotoAroundObject:(PhotoLibrary *)value;
- (void)removePhotoAroundObject:(PhotoLibrary *)value;
- (void)addPhotoAround:(NSSet *)values;
- (void)removePhotoAround:(NSSet *)values;

@end
