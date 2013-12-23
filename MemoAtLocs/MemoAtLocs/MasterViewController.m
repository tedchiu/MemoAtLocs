//
//  MasterViewController.m
//  Locations Memo
//
//  Created by Tedchiu on 13/9/16.
//  Copyright (c) 2013年 Tedchiu. All rights reserved.
//

#import "MasterViewController.h"

#import "LocationMapViewController.h"



@interface MasterViewController ()

@property  (weak, nonatomic) NSArray *placemarks ;
@property (nonatomic, retain) NSFetchedResultsController *searchFetchedResultsController;
@property (nonatomic, retain) UISearchDisplayController *mySearchDisplayController;

@end

@implementation MasterViewController



- (CLLocationManager *)locationManager
{
    
    if( _locationManager != nil) {
        return _locationManager ;
    }
    
    _locationManager = [[CLLocationManager alloc] init] ;
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters ;
    _locationManager.delegate = self ;
    
    return _locationManager ;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //    addButton.enabled = YES ;
}






- (void)awakeFromNib
{
    [super awakeFromNib];
}



- (void)viewDidLoad
{
    [super viewDidLoad];


    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    
    NSArray *buttonArray = [NSArray array] ;

    if ([CLLocationManager locationServicesEnabled]) {
//
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
        
        buttonArray = [buttonArray arrayByAddingObject:addButton] ;
//
    
        [[self locationManager] startUpdatingLocation] ;
        
    } else {
        
        UIAlertView *alertViewOfLocationManager = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Location Manager is not enabled !", nil)
                                                            message:NSLocalizedString(@"Please enable the location service",nil)
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"Cancel",nil)
                                                  otherButtonTitles:nil, nil] ;
        [alertViewOfLocationManager show] ;
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoDark];
    [btn addTarget:self action:@selector(showInfoScreen:) forControlEvents:UIControlEventTouchUpInside] ;
    
    UIBarButtonItem *infoButton = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    
    buttonArray = [buttonArray arrayByAddingObject:infoButton] ;

    self.navigationItem.rightBarButtonItems = buttonArray ;
    
    if (self.savedSearchTerm)
    {
        [self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:self.savedScopeButtonIndex];
        //        [self.searchDisplayController.searchBar setText:savedSearchTerm];
        [self.searchDisplayController.searchBar setText:self.savedSearchTerm];
        
        
        self.savedSearchTerm = nil;
    }
    
    [self createAdBannerView];
    
}

- (IBAction)showInfoScreen:(id)sender
{
    
    [self performSegueWithIdentifier:@"showHelp:" sender:self] ;

}


- (void)alertView:alertView clickedButtonAtIndex:(NSInteger *)buttonIndex
{
    int index = (int) buttonIndex ;
    if (index == 1)
    {

        NSURL*url=[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];

        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            

            [[UIApplication sharedApplication] openURL:url];
        } else {
        }

    }

}



- (void)viewDidUnload
{
    // Start the location manager.
    
    [[self locationManager] stopUpdatingLocation] ;
    
    self.geocoder = nil ;
    self.locationManager = nil ;
    self.fetchedResultsController = nil ;
    
    [super viewDidUnload] ;
    
}


- (void)insertNewObject:(id)sender
{
    

    
    CLLocation *location = [self.locationManager location] ;
    
    
    if (!location) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Location Manager is not ready !", nil)
                                                            message:NSLocalizedString(@"Please check internet connection",nil)
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK",nil)
                                                  otherButtonTitles:nil, nil] ;
        [alertView show] ;

        return ;
    }
    
    
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
        // If the event is recent, do something with it.
//        NSLog(@"latitude %+.6f, longitude %+.6f\n",
//              location.coordinate.latitude,
//              location.coordinate.longitude);
    }
    
    
    CLLocationCoordinate2D coordinate = [location coordinate] ;
    
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError * error) {
        
        CLPlacemark * placemark = [placemarks lastObject] ;
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        //
        self.nObject = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:context];
        
        
        if (error){
            NSLog(@"geocoder failed with error: %@", error);
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Geocoder is fail !",nil)
                                                                message:NSLocalizedString(@"Please check internet connection",nil)
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"OK",nil)
                                                      otherButtonTitles:nil, nil] ;
            [alertView show] ;
            
            //            [self displayError:error];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
            [dateFormatter setDateStyle:NSDateFormatterLongStyle];
            
            self.nObject.name = [dateFormatter stringFromDate:[NSDate date]] ;

            

            NSString *string = [NSString stringWithFormat:NSLocalizedString(@"LAT:%+.4f, LON:%+.4f", nil), coordinate.latitude, coordinate.longitude ] ;

            self.nObject.address = string ;
            
        } else {
            
           
            NSString *myString = (ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO));
            self.nObject.address = [myString stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
            
            myString = placemark.name ;
            self.nObject.name = [myString stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
            
        }
        
        
        self.nObject.timeStamp = [NSDate date] ;
        self.nObject.latitude =  [NSNumber numberWithDouble:coordinate.latitude] ;
        self.nObject.longitude = [NSNumber numberWithDouble:coordinate.longitude] ;
        
        
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        [self performSegueWithIdentifier:@"showDetail" sender:self] ;
        
    }];
    
} ;




- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        
        if ( [sender isKindOfClass:[UITableViewCell class]]) {
            

                NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            
            
                self.object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
                
        } else if ( [sender isKindOfClass:[self.searchDisplayController.searchResultsTableView class]]) {
            
            
                NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            
            
                self.object = [[self searchFetchedResultsController] objectAtIndexPath:indexPath];
            
        } else {

            self.object = self.nObject ;
        }
        
        LocationMapViewController *myMapVC = (LocationMapViewController *)segue.destinationViewController ;
        
        
        [myMapVC setDetailItem:self.object];
        

    } else if ([[segue identifier] isEqualToString:@"showHelp:"]) {
        
        
        ImageViewController *helpImages = (ImageViewController *)segue.destinationViewController ;
        

        UIImage *image1 = [UIImage imageNamed:@"helpScreen-1.jpg"] ;
        UIImage *image2 = [UIImage imageNamed:@"helpScreen-2.jpg"] ;
        UIImage *image3 = [UIImage imageNamed:@"helpScreen-3.jpg"] ;
        UIImage *image4 = [UIImage imageNamed:@"helpScreen-4.jpg"] ;
        self.helpScreenArray = [NSArray arrayWithObjects:image1, image2, image3, image4, nil] ;
        
        [helpImages setPhotos:self.helpScreenArray index:0 isHelpMode:YES];
        
    }
}

//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if( tableView == self.searchDisplayController.searchResultsTableView) {
        

        [self performSegueWithIdentifier:@"showDetail" sender:tableView];
    }
}
//



- (void)configureCell:(NSFetchedResultsController *)fetchedResultsController cell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    Event *object = [fetchedResultsController objectAtIndexPath:indexPath];
    
    
    cell.textLabel.text = object.name ;
    
    NSString *myString = object.address ;
    cell.detailTextLabel.text = [myString stringByReplacingOccurrencesOfString:@"\n" withString:@" "];


    
    PhotoLibrary *photoLibrary = [object.photoAround  anyObject] ;
    
    
    if (photoLibrary) {
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit ;
        
        cell.imageView.image = [UIImage imageWithData:photoLibrary.thumbnail] ;
        
    } else {
        cell.imageView.image = nil ;
    }
    
}


#pragma mark - Table View

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{

    
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{

    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (editingStyle == UITableViewCellEditingStyleDelete) {

        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


#pragma mark - Fetched results controller


#pragma mark - searh display controller



- (NSFetchedResultsController *)fetchedResultsControllerForTableView:(UITableView *)tableView
{

    return tableView == self.tableView ? self.fetchedResultsController : self.searchFetchedResultsController;
}

- (void)fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController configureCell:(UITableViewCell *)theCell atIndexPath:(NSIndexPath *)theIndexPath
{
    
    [self configureCell:fetchedResultsController cell:theCell atIndexPath:theIndexPath] ;

}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)theIndexPath
{

    
    UITableViewCell *cell = (UITableViewCell *)[theTableView dequeueReusableCellWithIdentifier:@"Cell"];

    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"] ;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator ;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault ;
        
    }
    
    
    [self fetchedResultsController:[self fetchedResultsControllerForTableView:theTableView] configureCell:cell atIndexPath:theIndexPath];
    

    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    
    NSInteger count = [[[self fetchedResultsControllerForTableView:tableView] sections] count];
    
    return count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSInteger numberOfRows = 0;
    NSFetchedResultsController *fetchController = [self fetchedResultsControllerForTableView:tableView];
    NSArray *sections = fetchController.sections;
    if(sections.count > 0)
    {
        id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
        numberOfRows = [sectionInfo numberOfObjects];
    }
    
    return numberOfRows;
    
}



#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSInteger)scope
{
    self.searchFetchedResultsController.delegate = nil;
    self.searchFetchedResultsController = nil;

    self.savedScopeButtonIndex = scope;
    
}


#pragma mark -
#pragma mark Search Bar

- (void)searchDisplayController:(UISearchDisplayController *)controller willUnloadSearchResultsTableView:(UITableView *)tableView;
{

    self.searchFetchedResultsController.delegate = nil;
    self.searchFetchedResultsController = nil;
    
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[self.searchDisplayController.searchBar selectedScopeButtonIndex]];
    
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text]
                               scope:[self.searchDisplayController.searchBar selectedScopeButtonIndex]];
    

    return YES;
}



- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    
    UITableView *tableView = controller == self.fetchedResultsController ? self.tableView : self.searchDisplayController.searchResultsTableView;
    [tableView beginUpdates];
    
}


- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    UITableView *tableView = controller == self.fetchedResultsController ? self.tableView : self.searchDisplayController.searchResultsTableView;
    
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)theIndexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{

    UITableView *tableView = controller == self.fetchedResultsController ? self.tableView : self.searchDisplayController.searchResultsTableView;
    
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:theIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self fetchedResultsController:controller configureCell:[tableView cellForRowAtIndexPath:theIndexPath] atIndexPath:theIndexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:theIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
    
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{

    UITableView *tableView = controller == self.fetchedResultsController ? self.tableView : self.searchDisplayController.searchResultsTableView;
    [tableView endUpdates];
    

}


- (void)loadView
{
    [super loadView];
    
    CGRect rect = [[UIScreen mainScreen] bounds]  ;
    self.view.frame = rect ;
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44.0)];

    searchBar.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    
    searchBar.scopeButtonTitles = [NSArray arrayWithObjects:NSLocalizedString(@"Name",nil), NSLocalizedString(@"Address", nil), nil] ;
    
    self.tableView.tableHeaderView = searchBar;
    
    self.mySearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self] ;

    self.mySearchDisplayController.delegate = self;
    self.mySearchDisplayController.searchResultsDataSource = self;
    self.mySearchDisplayController.searchResultsDelegate = self;
    
}

- (void)didReceiveMemoryWarning
{

    self.searchWasActive = [self.searchDisplayController isActive];
    self.savedSearchTerm = [self.searchDisplayController.searchBar text];
    self.savedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];

    _fetchedResultsController.delegate = nil;
    _fetchedResultsController = nil ;

    _searchFetchedResultsController.delegate = nil;
    _searchFetchedResultsController = nil;

    [super didReceiveMemoryWarning];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    self.searchWasActive = [self.searchDisplayController isActive];
    self.savedSearchTerm = [self.searchDisplayController.searchBar text];
    self.savedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];

    
}



- (NSFetchedResultsController *)newFetchedResultsControllerWithSearch:(NSString *)searchString
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];

    NSPredicate *filterPredicate = nil ; // your predicate here
    
    /*
     Set up the fetched results controller.
     */
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSMutableArray *predicateArray = [NSMutableArray array];
    if(searchString.length)
    {

        switch (self.savedScopeButtonIndex) {
            case 0:
                [predicateArray addObject:[NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", searchString]];
                break;
            default:
                [predicateArray addObject:[NSPredicate predicateWithFormat:@"address CONTAINS[cd] %@", searchString]];
                break;
        }

        if(filterPredicate)
        {
            filterPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:filterPredicate, [NSCompoundPredicate orPredicateWithSubpredicates:predicateArray], nil]];
        }
        else
        {
            filterPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:predicateArray];
        }
    }
    
    [fetchRequest setPredicate:filterPredicate];
    
    [fetchRequest setFetchBatchSize:20];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                managedObjectContext:self.managedObjectContext
                                                                                                  sectionNameKeyPath:nil
                                                                                                           cacheName:nil];
    aFetchedResultsController.delegate = self;
    
    fetchRequest = nil ;
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error])
    {

        abort();
    }

    return aFetchedResultsController;
}



- (NSFetchedResultsController *)fetchedResultsController
{

    if (_fetchedResultsController != nil)
    {
        return _fetchedResultsController;
    }
    _fetchedResultsController = [self newFetchedResultsControllerWithSearch:nil];
    

    return _fetchedResultsController ;
}


- (NSFetchedResultsController *)searchFetchedResultsController
{

    if (_searchFetchedResultsController != nil)
    {
        return _searchFetchedResultsController ;
    }
    _searchFetchedResultsController = [self newFetchedResultsControllerWithSearch:self.searchDisplayController.searchBar.text];
    

    return _searchFetchedResultsController ;
}

#pragma mark iAd1


#pragma mark iAd2
- (int)getBannerHeight:(UIDeviceOrientation)orientation
{
    /*
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        return 32;
    } else {
        return 50;
    }
     */
    return 50 ;
}

- (int)getBannerHeight
{
    return [self getBannerHeight:[UIDevice currentDevice].orientation];
}

- (void)createAdBannerView {
    Class classAdBannerView = NSClassFromString(@"ADBannerView");
    if (classAdBannerView != nil) {
        self.bannerView = [[classAdBannerView alloc]
                              initWithFrame:CGRectZero] ;
        
        CGRect bounds = [[UIScreen mainScreen] bounds] ;
        

        [_bannerView setFrame:CGRectOffset([_bannerView frame], 0, bounds.size.height - [self getBannerHeight])];
        [_bannerView setDelegate:self];
        
        [self.view addSubview:_bannerView];
    }
}


- (void)fixupAdView:(UIInterfaceOrientation)toInterfaceOrientation {
    if (_bannerView != nil) {
        
        
        [UIView beginAnimations:@"fixupViews" context:nil];
        if (_bannerViewIsVisible) {
            CGRect bannerViewFrame = [_bannerView frame];
            bannerViewFrame.origin.x = 0;

            bannerViewFrame.origin.y = self.view.frame.size.height - [self getBannerHeight:toInterfaceOrientation] ;
            
            [_bannerView setFrame:bannerViewFrame];
            
            
            CGRect contentViewFrame = _contentView.frame;
            contentViewFrame.size.height = self.view.frame.size.height -
            [self getBannerHeight:toInterfaceOrientation];
            _contentView.frame = contentViewFrame;
            
        } else {
            CGRect bannerViewFrame = [_bannerView frame];
            bannerViewFrame.origin.x = 0;

            bannerViewFrame.origin.y = self.view.frame.size.height ;


            [_bannerView setFrame:bannerViewFrame];
            

            CGRect contentViewFrame = _contentView.frame;
            contentViewFrame.size.height = self.view.frame.size.height;
            
            _contentView.frame = contentViewFrame;
            
        }
        [UIView commitAnimations];
    }
}


 
- (void) viewWillAppear:(BOOL)animated {
///    [self refresh];
    [self fixupAdView:[UIDevice currentDevice].orientation];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self fixupAdView:toInterfaceOrientation];
}

#pragma mark ADBannerViewDelegate

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    if (!_bannerViewIsVisible) {
        _bannerViewIsVisible = YES;
        [self fixupAdView:[UIDevice currentDevice].orientation];
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (_bannerViewIsVisible)
    {
        _bannerViewIsVisible = NO;
        [self fixupAdView:[UIDevice currentDevice].orientation];
    }
}

@end
