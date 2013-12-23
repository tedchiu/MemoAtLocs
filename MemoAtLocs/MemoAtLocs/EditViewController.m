//
//  EditViewController.m
//  Locations Memo
//
//  Created by Tedchiu on 13/9/16.
//  Copyright (c) 2013年 Tedchiu. All rights reserved.
//

#import "EditViewController.h"

@interface EditViewController ()

@end

@implementation EditViewController


- (void)setEditItem:(id)newEditItem
{
    if (_editItem != newEditItem) {
        _editItem = newEditItem;
        
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder] ;
    
    [self changeLocationName:textField] ;
    
    return YES ;
}
- (IBAction)editCancel:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil] ;

}

- (IBAction)changeLocationName:(UITextField *)sender
{

    NSString *name = self.editLocationName.text ;
    NSString *address = self.editLocationAddress.text ;
    if ([name isEqualToString:@""]) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [dateFormatter setDateStyle:NSDateFormatterLongStyle];
        
        name = [dateFormatter stringFromDate:self.editItem.timeStamp] ;

    }
    
    self.editItem.name =  name ;
    self.editItem.address = address ;

    NSManagedObjectContext *context = self.editItem.managedObjectContext;

    NSError *error ;
    
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
        [self.mapView selectAnnotation:[self.mapView.annotations firstObject] animated:NO] ;
    
    
    [self dismissViewControllerAnimated:YES completion:nil] ;
}




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];

    self.editLocationName.text = self.editItem.name ;
    self.editLocationAddress.text = self.editItem.address ;
    
    [self.editLocationName becomeFirstResponder] ;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)performActivity:(UIBarButtonItem *)sender
{
    NSString *title = self.editItem.name ;
    NSDate *timeStamp = self.editItem.timeStamp ;
    
    
     NSArray *activityItems = [[NSArray alloc] initWithObjects:title, timeStamp, nil  ] ;
    
    for ( PhotoLibrary *aObject in self.editItem.photoAround )
    {
        PhotoStorage *imageDataObject = aObject.photoData ;
        UIImage *imageObject = [[UIImage alloc] initWithData:imageDataObject.photo] ;
        
        activityItems = [activityItems arrayByAddingObject:imageObject] ;
    }
    
     UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
     
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion >= 7.0) {
        activityVC.excludedActivityTypes = @[UIActivityTypeCopyToPasteboard, UIActivityTypeMessage, UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypePostToWeibo, UIActivityTypeAirDrop];
    } else {
        activityVC.excludedActivityTypes = @[UIActivityTypeCopyToPasteboard, UIActivityTypeMessage, UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypePostToWeibo];
    }
    
    activityVC.completionHandler = ^(NSString *activityType, BOOL completed){
     };
     
     [self presentViewController:activityVC animated:YES completion:nil];
 
}




- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController
{

    return @"" ;
}


- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType
{

    return nil ;
}

#pragma mark - Table View

 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
 {
 return 1 ;
 }
 //


// Commented out for SearchDisplayController 2013.10.24
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
 {
 
 return 4 ;
 }
 //



 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"editDetail" forIndexPath:indexPath];
     

     if (indexPath.item == 0) {
         NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
         [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
         [dateFormatter setDateStyle:NSDateFormatterLongStyle];
         
         cell.textLabel.text = [dateFormatter stringFromDate:self.editItem.timeStamp] ;
         cell.detailTextLabel.text = nil ;
         
     } else if (indexPath.item == 1) {
         
        NSString *string = [NSString stringWithFormat:NSLocalizedString(@"LAT:%+.4f, LON:%+.4f", nil), [self.editItem.latitude doubleValue], [self.editItem.longitude doubleValue] ] ;
         
         cell.textLabel.text = string ;
         cell.detailTextLabel.text = nil ;
     } else if (indexPath.item == 2) {
         
         cell.textLabel.text = self.editLocationName.text ;
         cell.detailTextLabel.text = nil ;
     } else if (indexPath.item == 3) {
         
         cell.textLabel.text = nil ;
         cell.detailTextLabel.text = self.editLocationAddress.text ;

     }

     
 return cell;
 
 }
 

@end
