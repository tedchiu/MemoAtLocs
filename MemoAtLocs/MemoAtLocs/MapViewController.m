//
//  MapViewController.m
//  Locations Memo
//
//  Created by Tedchiu on 13/9/16.
//  Copyright (c) 2013年 Tedchiu. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()
@property (nonatomic) BOOL needUpdateRegion;
@end

@implementation MapViewController


- (void)viewDidLoad
{

    [super viewDidLoad];
    self.mapView.delegate = self;
    self.needUpdateRegion = YES;
    
}

- (void)viewDidUnload
{
    self.mapView.delegate = nil ;
    self.mapView = nil ;
    
    [super viewDidUnload];
    
    
}



- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view.leftCalloutAccessoryView isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView *)(view.leftCalloutAccessoryView);
        if ([view.annotation respondsToSelector:@selector(thumbnail)]) {
            // this should be done in a different thread!
            imageView.image = [view.annotation performSelector:@selector(thumbnail)];
        }
    }
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    
    static NSString *reuseId = @"MapViewController";
    MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
    if (!view) {
        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
        view.canShowCallout = YES;
        if ([mapView.delegate respondsToSelector:@selector(mapView:annotationView:calloutAccessoryControlTapped:)]) {
            view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        }
    }
    
    return view;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.needUpdateRegion) [self updateRegion];
//
    [self.mapView selectAnnotation:[self.mapView.annotations firstObject] animated:YES] ;
    
}

- (void)updateRegion
{
    
    self.needUpdateRegion = NO;
    
    CGRect boundingRect;
    BOOL started = NO;
    for (id <MKAnnotation> annotation in self.mapView.annotations) {
        
        
        CGRect annotationRect = CGRectMake(annotation.coordinate.latitude, annotation.coordinate.longitude, 0, 0);
        if (!started) {
            started = YES;
            boundingRect = annotationRect;
        } else {
            boundingRect = CGRectUnion(boundingRect, annotationRect);
        }
    }
    if (started) {
        
        //
        MKCoordinateRegion currentRegion ;
        currentRegion = self.mapView.region ;
       
        
        boundingRect = CGRectInset(boundingRect, -0.2, -0.2);
        if ((boundingRect.size.width < 20) && (boundingRect.size.height < 20)) {
            MKCoordinateRegion region;
            region.center.latitude = boundingRect.origin.x + boundingRect.size.width / 2;
            region.center.longitude = boundingRect.origin.y + boundingRect.size.height / 2;
            
            region.span.latitudeDelta = 0.005 ;
            region.span.longitudeDelta = 0.005 ;
            [self.mapView setRegion:region animated:NO];
        }
    }

}

//

@end
