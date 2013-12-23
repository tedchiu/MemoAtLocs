//
//  ImageViewController.h
//  Locations Memo
//
//  Created by Tedchiu on 13/9/25.
//  Copyright (c) 2013年 Tedchiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "PhotoLibrary.h"
#import "PhotoStorage.h"

#import "MyViewController.h"

@interface ImageViewController : UIViewController

@property (nonatomic, strong) NSArray *photos ;
@property NSInteger photoIndex ;
@property BOOL isHelpMode ;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) UIImageView *imageView ;
@property (weak, nonatomic) Event *detailItem;

- (void)setPhotos: (NSArray *)photos index:(NSInteger)index isHelpMode:(BOOL)isHelpMode ;

@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;

@end
