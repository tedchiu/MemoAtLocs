//
//  LocationMapViewController.m
//  Locations Memo
//
//  Created by Tedchiu on 13/9/23.
//  Copyright (c) 2013年 Tedchiu. All rights reserved.  test pull....
//

#import "LocationMapViewController.h"

@interface LocationMapViewController ()
@property (strong, nonatomic) UIImagePickerController *imagePicker ;
@property (strong, nonatomic) IBOutlet UIView *overlayView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *takePictureButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *donButton;

@end

@implementation LocationMapViewController



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1 ;
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"photoTime" ascending:NO ] ;
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil] ;
    
    self.photos = [self.detailItem.photoAround sortedArrayUsingDescriptors:sortDescriptors] ;
    
    self.totalPhotos = [self.photos count] ;
 
    return  self.totalPhotos ;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    

    
  CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCollect" forIndexPath:indexPath] ;
    
    PhotoLibrary *photoLibrary = [self.photos objectAtIndex:indexPath.item] ;
    
    cell.cellImageView.image = [UIImage imageWithData:photoLibrary.thumbnail] ;
    
    return cell ;
}



- (BOOL) collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.photoIndex = indexPath.item ;

    [self performSegueWithIdentifier:@"setPhotos:" sender:self] ;
    
    return YES ;
}



-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"editName:"])
    {
        
        EditViewController *editVC = (EditViewController *)segue.destinationViewController ;
        
        editVC.mapView = self.mapView ;
        [editVC setEditItem:self.detailItem] ;

    } else if ([segue.identifier isEqualToString:@"setPhotos:"])
    {
        
        ImageViewController *imageVC = (ImageViewController *)segue.destinationViewController ;
        
        imageVC.detailItem = self.detailItem ;
        
        [imageVC setPhotos:self.photos index:self.photoIndex isHelpMode:NO] ;
        
    }
}



#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
    }
}




- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    self.annotationView = view ;
    
    [self performSegueWithIdentifier:@"editName:" sender:view] ;
    

    [self.mapView deselectAnnotation:view.annotation animated:NO] ;
    

}


- (IBAction)photoButtonPress:(UIBarButtonItem *)sender
{

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
 
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init] ;
        
        imagePicker.videoQuality = UIImagePickerControllerQualityTypeLow ;
        
        imagePicker.modalPresentationStyle = UIModalPresentationCurrentContext;

        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera ;
        imagePicker.modalPresentationStyle = UIModalPresentationCurrentContext ;
        imagePicker.delegate = self ;

        self.imagePicker = imagePicker ;
        
        [self performSelector:@selector(presentCameraView) withObject:nil afterDelay:0.5f];
        
 
    }

}


-(void)presentCameraView
{
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}



-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage] ;

     NSManagedObjectContext *context = self.detailItem.managedObjectContext ;
    

     PhotoLibrary *newPhoto = [NSEntityDescription insertNewObjectForEntityForName:@"PhotoLibrary" inManagedObjectContext:context];
    
     PhotoStorage *newPhotoData = [NSEntityDescription insertNewObjectForEntityForName:@"PhotoStorage" inManagedObjectContext:context];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);

    
    newPhotoData.photo = imageData ;
    imageData = nil ;
    
    newPhotoData.photoInfo = newPhoto ;

    newPhoto.photoTime = [NSDate date] ;
    newPhoto.placeOfPhoto = self.detailItem ;
    newPhoto.photoData = newPhotoData ;
    
 
    CGSize imageSize = image.size;
    CGSize viewSize = CGSizeMake(80.0, 80.0);
    
    UIGraphicsBeginImageContextWithOptions(viewSize, YES, [UIScreen
                                                           mainScreen].scale);
    
    float hfactor = imageSize.width / viewSize.width;
    float vfactor = imageSize.height / viewSize.height;
    
    float factor = fminf(hfactor, vfactor);
    
    float newWidth = imageSize.width / factor;
    float newHeight = imageSize.height / factor;
    
    CGRect newRect ;
//
    if (newHeight > newWidth) {
        newRect = CGRectMake(0.0, -(newHeight - newWidth)/2.0, newWidth, newHeight);
        
    } else {
        newRect = CGRectMake(-(newWidth - newHeight)/2.0, 0.0, newWidth, newHeight);
        
    }
    
    [image drawInRect:newRect];
    
    UIImage *myThumbnailImage = UIGraphicsGetImageFromCurrentImageContext();
    
    newPhoto.thumbnail = UIImagePNGRepresentation(myThumbnailImage);
    
    UIGraphicsEndImageContext();


    [self.detailItem addPhotoAroundObject:newPhoto] ;
    
  
     NSError *error ;
     
     
     if (![context save:&error]) {
     // Replace this implementation with code to handle the error appropriately.
     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
     NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
     abort();
     }
    
    [self.photoCollectionView reloadData] ;
    

    [self dismissViewControllerAnimated:YES completion:nil] ;
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil] ;
    self.imagePicker = nil ;
}


- (void)viewDidLoad
{

    [super viewDidLoad];
    [self reload];
    

    
    self.sharedMc = [UIMenuController sharedMenuController];

}



- (void)reload
{
    
    [self.mapView addAnnotation:self ];

    
    [self.photoCollectionView reloadData] ;
}


//
//
//
- (CLLocationCoordinate2D)coordinate
{
    
    CLLocationCoordinate2D coord ;
    
    coord.latitude = [self.detailItem.latitude floatValue] ;
    coord.longitude = [self.detailItem.longitude floatValue] ;
    
    return coord ;
}

- (NSString *)title
{


    return self.detailItem.name ;
}

- (NSString *)subtitle
{
    NSString *myString = self.detailItem.address ;
    myString = [myString stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    
    return myString ;
}


- (void)viewDidUnload
{
    self.photoCollectionView = nil ;
    
    
    [super viewDidUnload] ;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}




- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
{
 
    UICollectionViewCell *cell = [self.photoCollectionView cellForItemAtIndexPath:indexPath];
    
    [self.sharedMc setTargetRect:cell.frame inView:self.photoCollectionView];
    
    [self.sharedMc setMenuVisible:YES animated:YES];
//
    
    self.indexPathOfMyItem = indexPath  ;

    return YES ;
}




#pragma mark - UICollectionViewDelegate methods

//
- (BOOL)collectionView:(UICollectionView *)collectionView
      canPerformAction:(SEL)action
    forItemAtIndexPath:(NSIndexPath *)indexPath
            withSender:(id)sender
{
    if (action == @selector(delete:)) {
   
        self.indexPathOfMyItem = indexPath  ;
        return YES ;
    }

    return NO;  //YES for the Cut, copy, paste actions + customAction
                // NO for customerAction only
}


- (void)collectionView:(UICollectionView *)collectionView
         performAction:(SEL)action
    forItemAtIndexPath:(NSIndexPath *)indexPath
            withSender:(id)sender
{

    
    if (action == @selector(delete:)) {
        
        [self delete:sender] ;
 
    }

}



- (void)delete:(id)sender
{
    
    NSManagedObjectContext *context = self.detailItem.managedObjectContext ;
    PhotoLibrary *photoLibrary = [self.photos objectAtIndex:self.indexPathOfMyItem.item] ;
    PhotoStorage *photoStorage = photoLibrary.photoData ;
    
    [context deleteObject:photoLibrary] ;
    [context deleteObject:photoStorage] ;
    
    
    [self.detailItem removePhotoAroundObject:photoLibrary] ;
    NSError *error ;
    
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    NSArray *indexPathArray = [[NSArray alloc] initWithObjects:self.indexPathOfMyItem, nil] ;
                               
    [self.photoCollectionView deleteItemsAtIndexPaths:indexPathArray] ;

    self.photos = nil;
     
    [self.photoCollectionView reloadData] ;
    
}


#pragma mark - UIMenuController required methods
- (BOOL)canBecomeFirstResponder
{

    return YES;
}

//
//
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{

    if (action == @selector(delete:)) {
        return YES;
    }

    return NO;
}


- (IBAction)takePhoto:(id)sender
{
    [self.imagePicker takePicture] ;
}

- (IBAction)finish:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL] ;
    
    self.imagePicker = nil ;
    
}


@end
