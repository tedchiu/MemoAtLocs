//
//  MasterViewController.h
//  Locations Memo
//
//  Created by Tedchiu on 13/9/16.
//  Copyright (c) 2013年 Tedchiu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "Event.h"

#import <iAd/iAd.h>


@interface MasterViewController : UIViewController <NSFetchedResultsControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate, ADBannerViewDelegate, UITableViewDataSource, UITableViewDelegate>

{

}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) ADBannerView *bannerView ;
@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIView *view;
@property (nonatomic) BOOL bannerViewIsVisible ;
@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@property (nonatomic, strong) CLLocationManager *locationManager ;
@property (strong, nonatomic) CLGeocoder *geocoder ;
@property (nonatomic, strong) Event *nObject ;
@property (nonatomic, weak) Event *object ;

@property (nonatomic, strong) NSArray *helpScreenArray ;


@end
