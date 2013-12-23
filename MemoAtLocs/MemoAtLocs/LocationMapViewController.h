//
//  LocationMapViewController.h
//  Locations Memo
//
//  Created by Tedchiu on 13/9/23.
//  Copyright (c) 2013年 Tedchiu. All rights reserved.
//

#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "EditViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import "ImageViewController.h"
#import "CollectionViewCell.h"
#import <CoreData/CoreData.h>

#import "Event.h"
#import "PhotoLibrary.h"
#import "PhotoStorage.h"

#import <AssetsLibrary/AssetsLibrary.h>

@interface LocationMapViewController : MapViewController <MKMapViewDelegate, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate>



@property (weak, nonatomic) Event *detailItem;
@property (nonatomic, weak) NSString *name ;
@property (nonatomic, weak) NSString *address ;
@property (nonatomic, weak) NSManagedObject *editingObject ;
@property NSInteger photoIndex ;
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (nonatomic, strong) NSArray *photos ;
@property NSInteger totalPhotos ;
@property (nonatomic, strong)NSIndexPath *indexPathOfMyItem ;
@property(copy) NSArray *menuItems;
@property (nonatomic, retain) UIMenuItem *deleteMenuItem ;
@property (nonatomic, retain) UIMenuController *sharedMc ;
@property (nonatomic, strong) MKAnnotationView *annotationView ;

@end
