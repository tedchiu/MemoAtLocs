//
//  Event+MKAnnotation.m
//  Locations Memo
//
//  Created by Tedchiu on 13/9/23.
//  Copyright (c) 2013年 Tedchiu. All rights reserved.
//

#import "Event+MKAnnotation.h"

@implementation Event (MKAnnotation)
- (NSString *)title
{
    return self.name;
}

// part of the MKAnnotation protocol

- (NSString *)subtitle
{
    return self.address ;
}

// (required) part of the MKAnnotation protocol
// just picks the location of a random photo by this photographer

- (CLLocationCoordinate2D)coordinate
{
    
//    NSLog(@"==> Event+MKAnnoation ") ;
    
    CLLocationCoordinate2D coord ;
    
    coord.latitude = [self.latitude doubleValue] ;
    coord.longitude = [self.longitude doubleValue] ;
    
//    NSLog(@"Event+MKAnnoation ...coordinate: %f, %f", coord.latitude, coord.longitude) ;
    
//    NSLog(@"Event+MKAnnoation ==>") ;
    
    return coord ;
}

// MapViewController likes annotations to implement this

/*
- (UIImage *)thumbnail
{
    return [[self.photos anyObject] thumbnail];
}
*/
@end
