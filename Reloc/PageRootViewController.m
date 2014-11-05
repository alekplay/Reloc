//
//  PageRootViewController.m
//  Reloc
//
//  Created by Aleksander Skjølsvik on 13.09.14.
//  Copyright (c) 2014 alekApps. All rights reserved.
//

#import "PageRootViewController.h"
#import "PageContentViewController.h"

@interface PageRootViewController ()



@end

@implementation PageRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _pageTitles = @[@"Your homescreen is a simple map you can use to scroll around.", @"You can store your location by tapping the 'plus'-icon in the right corner.", @"Your map will be filled with annotations from places you've visited.", @"You can delete an annontation by tapping it, and then the 'x' in the lower right corner.", @"You can access all your categories from the pause menu in the upper left corner. Tap to begin using Reloc."];
    _pageImages = @[@"Image 1.png", @"Image 2.png", @"Image 3.png", @"Image 4.png", @"Image 5.png"];
    
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    [self.view setBackgroundColor:[[UIColor clearColor] colorWithAlphaComponent:0.0]];
    CALayer *layer = [self.view layer];
    [layer setRasterizationScale:0.75];
    [layer setShouldRasterize:YES];
}

- (IBAction)startWalkthrough:(id)sender {
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageTitles count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index {
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentController"];
    pageContentViewController.imageFile = self.pageImages[index];
    pageContentViewController.titleText = self.pageTitles[index];
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

@end
