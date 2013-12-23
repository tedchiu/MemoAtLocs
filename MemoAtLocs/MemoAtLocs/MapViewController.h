//
//  MapViewController.h
//  Locations Memo
//
//  Created by Tedchiu on 13/9/16.
//  Copyright (c) 2013年 Tedchiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
