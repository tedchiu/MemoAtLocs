/*
     File: MyViewController.m 
 Abstract: The root view controller for the iPhone design of this app. 
  Version: 1.5 
  
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple 
 Inc. ("Apple") in consideration of your agreement to the following 
 terms, and your use, installation, modification or redistribution of 
 this Apple software constitutes acceptance of these terms.  If you do 
 not agree with these terms, please do not use, install, modify or 
 redistribute this Apple software. 
  
 In consideration of your agreement to abide by the following terms, and 
 subject to these terms, Apple grants you a personal, non-exclusive 
 license, under Apple's copyrights in this original Apple software (the 
 "Apple Software"), to use, reproduce, modify and redistribute the Apple 
 Software, with or without modifications, in source and/or binary forms; 
 provided that if you redistribute the Apple Software in its entirety and 
 without modifications, you must retain this notice and the following 
 text and disclaimers in all such redistributions of the Apple Software. 
 Neither the name, trademarks, service marks or logos of Apple Inc. may 
 be used to endorse or promote products derived from the Apple Software 
 without specific prior written permission from Apple.  Except as 
 expressly stated in this notice, no other rights or licenses, express or 
 implied, are granted by Apple herein, including but not limited to any 
 patent rights that may be infringed by your derivative works or by other 
 works in which the Apple Software may be incorporated. 
  
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE 
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION 
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS 
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND 
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS. 
  
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL 
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, 
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED 
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), 
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE 
 POSSIBILITY OF SUCH DAMAGE. 
  
 Copyright (C) 2013 Apple Inc. All Rights Reserved. 
  
 */

#import "MyViewController.h"

@interface MyViewController ()
{
    int pageNumber;
}
@end

@implementation MyViewController

// load the view nib and initialize the pageNumber ivar
- (id)initWithPageNumber:(NSUInteger)page
{
//    NSLog(@"==>MyVC... initWithPageNumber...page: %D", (int)page) ;
    
    if (self = [super initWithNibName:@"MyView" bundle:nil])
    {
        pageNumber = page;
        //
        // modified for nest ScrollView
        //
        CGRect rect = CGRectZero;
        
        rect.size = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        rect.origin.x = CGRectGetWidth(self.view.frame) * page ;
        
        // add prevView as first in line
//        UIImageView *prevView = [[UIImageView alloc] initWithFrame:rect];
//        self.prevImgView = prevView;
        
        UIScrollView *scrView = [[UIScrollView alloc] initWithFrame:rect];
// ??        [self.imageScrollView addSubview:scrView];
        
        scrView.delegate = self;
//        [scrView addSubview:prevView ];
        
//        scrView.minimumZoomScale = 0.5;
//        scrView.maximumZoomScale = 2.5;
        
//        self.prevImgView.frame = scrView.bounds;


        
    }
    return self;
}

// set the label and background color when the view has finished loading
- (void)viewDidLoad
{
//    NSLog(@"==>MyVC...viewDidLoad") ;
    
//    self.pageNumberLabel.text = [NSString stringWithFormat:@"Page %d", pageNumber + 1];
}

/*
- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"==>MyVC viewDidAppear") ;
}

- (void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"==>MyVC viewDidDisappear") ;
}
*/


- (void)didReceiveMemoryWarning
{
//    NSLog(@"==>MyVC ... didReceiveMemoryWarning") ;

    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
    
// ???
/*
    if([self isViewLoaded] && self.view.window == nil)
    {
        NSLog(@"==>MyVC ... remove view");
        self.view = nil;
    }
*/
//    self.view = nil ;
//
    
//    [self dismissViewControllerAnimated:YES completion:nil] ;
    
 }



- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView;
{
    //incase we are zooming the center image view parent
//    if (self.centerImgView.superview == scrollView){
//        return self.centerImgView;
//    }
    
//    NSLog(@"==> MyVC... viewForZoomingInScrollView") ;
    
    if (self.imageScrollView == scrollView){
        return [self.imageScrollView.subviews firstObject] ;
    }
    
//    NSLog(@"==> MyVC... viewForZoomingInScrollView return nil ==>") ;
    return nil;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
//    NSLog(@"==> MyVC... scrollViewDidZoom") ;

    UIView *subView = [scrollView.subviews objectAtIndex:0];
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
    
//    NSLog(@"MyVC... scrollViewDidZoom ==>") ;

}

/*
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    //    CGFloat pageWidth = sender.frame.size.width;
    //    pageNumber_ = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
}
*/

/*
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;{
    CGFloat pageWidth = scrollView.frame.size.width;
    previousPage_ = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
}
*/

/*
- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender {
    CGFloat pageWidth = sender.frame.size.width;
    int page = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    //incase we are still in same page, ignore the swipe action
    if(previousPage_ == page) return;
    
    if(sender.contentOffset.x >= sender.frame.size.width) {
        //swipe left, go to next image
        [self setRelativeIndex:1];
        
        // center the scrollview to the center UIImageView
        [self.imageHostScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.imageHostScrollView.frame), 0)  animated:NO];
	}
	else if(sender.contentOffset.x < sender.frame.size.width) {
        //swipe right, go to previous image
        [self setRelativeIndex:-1];
        
        // center the scrollview to the center UIImageView
        [self.imageHostScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.imageHostScrollView.frame), 0)  animated:NO];
	}
    
    UIScrollView *scrollView = (UIScrollView *)self.centerImgView.superview;
    scrollView.zoomScale = 1.0;
}
*/

/*
- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"==>MyVC ... hangleTap") ;
    
//    UIScrollView *scrollView = (UIScrollView*)self.centerImgView.superview;
//    float scale = scrollView.zoomScale;
//    scale += 1.0;
//    if(scale > 2.0) scale = 1.0;
//    [scrollView setZoomScale:scale animated:YES];
    
    UIImageView *imageView = [self.imageScrollView.subviews firstObject] ;
    imageView.frame = self.imageScrollView.bounds ;

}
*/


/*
#pragma mark - image loading-

-(UIImage *)imageAtIndex:(NSInteger)inImageIndex;{
    // limit the input to the current number of images, using modulo math
    inImageIndex = safeModulo(inImageIndex, [self totalImages]);
    
    NSString *filePath = [self.galleryImages objectAtIndex:inImageIndex];
    
	UIImage *image = nil;
    //Otherwise load from the file path
    if (nil == image)
    {
		NSString *imagePath = filePath;
		if(imagePath){
			if([imagePath isAbsolutePath]){
				image = [UIImage imageWithContentsOfFile:imagePath];
			}
			else{
				image = [UIImage imageNamed:imagePath];
			}
            
            if(nil == image){
				image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]]];
				
			}
        }
    }
    
	return image;
}

#pragma mark -

- (NSInteger)totalImages {
    return [self.galleryImages count];
}
- (NSInteger)currentIndex {
    
    return safeModulo(currentIndex_, [self totalImages]);
}

- (void)setCurrentIndex:(NSInteger)inIndex {
    currentIndex_ = inIndex;
    
    
    NSString *title = [NSString stringWithFormat:@"%d of %d",self.currentIndex+1,[self.galleryImages count]];
    self.counterTitle.text = title;
    
    if([galleryImages_ count] > 0){
        self.prevImgView.image   = [self imageAtIndex:[self relativeIndex:-1]];
        self.centerImgView.image = [self imageAtIndex:[self relativeIndex: 0]];
        self.nextImgView.image   = [self imageAtIndex:[self relativeIndex: 1]];
    }
}

- (NSInteger)relativeIndex:(NSInteger)inIndex {
    return safeModulo(([self currentIndex] + inIndex), [self totalImages]);
}

- (void)setRelativeIndex:(NSInteger)inIndex {
    [self setCurrentIndex:self.currentIndex + inIndex];
}


*/



@end
