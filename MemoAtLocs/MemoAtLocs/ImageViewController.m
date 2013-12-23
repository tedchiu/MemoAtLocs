//
//  ImageViewController.m
//  Locations Memo
//
//  Created by Tedchiu on 13/9/25.
//  Copyright (c) 2013年 Tedchiu. All rights reserved.
//

#import "ImageViewController.h"


@interface ImageViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray *viewControllers;

@end

@implementation ImageViewController




- (void)setPhotos: (NSArray *)photos index:(NSInteger)index isHelpMode:(BOOL)isHelpMode
{
    _photos = photos ;
    _photoIndex = index ;
    
    _isHelpMode = isHelpMode ;
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)prefersStatusBarHidden
{
    return YES ;
}


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    UIApplication *sharedApplication = [UIApplication sharedApplication] ;
    sharedApplication.statusBarHidden = YES ;
    
//
    self.navigationController.navigationBar.translucent = YES ;
    
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    

    [[self navigationController] setNavigationBarHidden:YES animated:YES];

    
    if (!self.isHelpMode) {
        UIBarButtonItem *actionButton = [[UIBarButtonItem alloc]
                                         initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                         target:self
                                         action:@selector(performActivity:)] ;
        
        
        self.navigationItem.rightBarButtonItem = actionButton;
    }

    
//
    NSUInteger numberPages = [self.photos count] ;
    
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < numberPages; i++)
    {
		[controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
    
    // a page is the width of the scroll view
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize =
    CGSizeMake(CGRectGetWidth(self.scrollView.frame) * numberPages, CGRectGetHeight(self.scrollView.frame));
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;

    self.pageControl.numberOfPages = numberPages;
    

    self.pageControl.currentPage = self.photoIndex ;
    [self gotoPage:YES] ;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [self.scrollView addGestureRecognizer:singleTap];
}

- (void)viewWillDisappear:(BOOL)animated
{

    self.navigationController.navigationBar.translucent = NO ;
}



- (IBAction)performActivity:(UIBarButtonItem *)sender
{
    NSString *name = self.detailItem.name ;
    
    
    PhotoLibrary *aPhoto = [self.photos objectAtIndex:self.photoIndex] ;
    
    NSDate *photoTime = aPhoto.photoTime ;
    
    UIImage *image = [[UIImage alloc] initWithData:aPhoto.photoData.photo ] ;
    
    NSArray *activityItems = [[NSArray alloc] initWithObjects:name, image, photoTime, nil  ] ;
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                                                             applicationActivities:nil];
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


- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{

    UIApplication *sharedApplication = [UIApplication sharedApplication] ;
    
    self.navigationController.navigationBar.translucent = YES ;
    self.navigationController.navigationBar.alpha = 0.7 ;

    
    if (self.navigationController.navigationBarHidden == YES) {
        sharedApplication.statusBarHidden = NO ;
        [[self navigationController] setNavigationBarHidden:NO animated:YES];
    } else {
        sharedApplication.statusBarHidden = YES ;
        [[self navigationController] setNavigationBarHidden:YES animated:YES];
    }

}




- (UIImageView *)imageView
{
    if (!_imageView) _imageView = [[UIImageView alloc] initWithFrame:CGRectZero] ;
    return _imageView ;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView ;
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


- (void)loadScrollViewWithPage:(NSUInteger)page
{
    
    if (page >= [self.photos count])
        return;
    

    MyViewController *controller = [self.viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {
        controller = [[MyViewController alloc] initWithPageNumber:page];
        [self.viewControllers replaceObjectAtIndex:page withObject:controller];
    }
    
    if (controller.view.superview == nil)
    {
        
        CGRect frame = self.scrollView.frame;
        
        frame.origin.x = CGRectGetWidth(frame) * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [self addChildViewController:controller];
        [self.scrollView addSubview:controller.view];
        [controller didMoveToParentViewController:self];
//
        UIImage *image ;
        
        if (self.isHelpMode) {
            image = [self.photos objectAtIndex:page] ;
        } else {
            PhotoLibrary *numberItem = [self.photos objectAtIndex:page];
            image = [UIImage imageWithData:numberItem.photoData.photo] ;
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image ];

        image = nil ;
        imageView.contentMode = UIViewContentModeScaleAspectFit ;
        

        CGRect myFrame = controller.imageScrollView.bounds ;
        myFrame.origin.y += 20.0 ;
        myFrame.size.height -= 20.0 ;
        imageView.frame = myFrame ;

        controller.imageScrollView.minimumZoomScale = controller.imageScrollView.zoomScale ;
        
        controller.imageScrollView.maximumZoomScale = 5.0;
        
        controller.imageScrollView.showsHorizontalScrollIndicator = NO;
        controller.imageScrollView.showsVerticalScrollIndicator = NO;

        controller.imageScrollView.delegate = controller ;
        
        
        [controller.imageScrollView addSubview:imageView];
        imageView = nil ;
        

    }

}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;

    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
}

- (void)gotoPage:(BOOL)animated
{
    NSInteger page = self.pageControl.currentPage;
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    CGRect bounds = self.scrollView.bounds;
    bounds.origin.x = CGRectGetWidth(bounds) * page;
    bounds.origin.y = 0;
    
    
    [self.scrollView scrollRectToVisible:bounds animated:animated];
}

- (IBAction)changePage:(id)sender
{
    [self gotoPage:YES];    // YES = animate
}




@end
