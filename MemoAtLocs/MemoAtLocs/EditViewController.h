//
//  EditViewController.h
//  Locations Memo
//
//  Created by Tedchiu on 13/9/16.
//  Copyright (c) 2013年 Tedchiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import <MapKit/MapKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "PhotoLibrary.h"
#import "PhotoStorage.h"


@interface EditViewController : UIViewController <UITextFieldDelegate, UIActivityItemSource, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) Event *editItem;
@property (weak, nonatomic) IBOutlet UITextField *editLocationName;
@property (weak, nonatomic) IBOutlet UITextField *editLocationAddress;

@property (strong, nonatomic) MKMapView *mapView ;
@property (weak, nonatomic) IBOutlet UILabel *memoTime;
@property (weak, nonatomic) IBOutlet UILabel *memoLocation;

@end
