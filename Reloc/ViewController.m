//
//  ViewController.m
//  Reloc
//
//  Created by Aleksander Skjølsvik on 13.09.14.
//  Copyright (c) 2014 alekApps. All rights reserved.
//

#import "ViewController.h"
#import "RWBlurPopover.h"
#import "PopupViewController.h"
#import "PageRootViewController.h"

@interface ViewController ()
- (IBAction)menuAction:(id)sender;
- (IBAction)addAction:(id)sender;
- (IBAction)locateAction:(id)sender;
- (IBAction)deleteAction:(id)sender;


@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *locateButton;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIButton *menuButton;
@property (strong, nonatomic) IBOutlet UIButton *addButton;

@end

@implementation ViewController {
    BlurMenu *_menu;
    UIPopoverController *_popover;
    CLLocationCoordinate2D _currentLocation;
    NSMutableArray *_menuItems;
    ItemCategory *_selectedCategory;
    BOOL _wantsLocateSelf;
}

#pragma mark INITIALIZATION

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // NOT YET IMPLEMENTED
    /*bool hasUsedAppBefore = [[NSUserDefaults standardUserDefaults] objectForKey:@"hasUsedAppBefore"];
    if (!hasUsedAppBefore) {
        //hasUsedAppBefore = YES;
        PageRootViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PageRootViewController"];
        [self presentViewController:vc animated:YES completion:nil];
    }*/
    
    _wantsLocateSelf = YES;
    
    NSData *arraysData = [[NSUserDefaults standardUserDefaults] objectForKey:@"categories"];
    NSMutableArray *array = [[NSKeyedUnarchiver unarchiveObjectWithData:arraysData] mutableCopy];
    
    if (array.count < 1) {
        array = [NSMutableArray array];
        arraysData = [NSKeyedArchiver archivedDataWithRootObject:array];
        [[NSUserDefaults standardUserDefaults] setObject:arraysData forKey:@"categories"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    _menuItems = [NSMutableArray arrayWithArray:array];
    _menu = [[BlurMenu alloc] initWithItems:_menuItems parentView:self.view delegate:self];
    
    UIPanGestureRecognizer *pangr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didDragMap:)];
    [pangr setDelegate:self];
    [self.mapView addGestureRecognizer:pangr];

    self.headerView.alpha = 0.5;
    CALayer *layer = [self.headerView layer];
    [layer setRasterizationScale:0.75];
    [layer setShouldRasterize:YES];
    
    // DEBUG (add annotations at any location by touching the screen)
    //[self addAnnotationsWithTouch];
    
    // DONT LEAVE THIS
    self.menuButton.alpha = 0.8;
    self.addButton.alpha = 0.8;
    self.locateButton.alpha = 0.8;
    self.deleteButton.alpha = 0.8;
}

#pragma mark MKMAPVIEW

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    if (_wantsLocateSelf) {
        [self locateAction:self];
    }
}

- (IBAction)locateAction:(id)sender {
    _wantsLocateSelf = YES;
    [UIView transitionWithView:_locateButton duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL completion:NULL];
    _locateButton.hidden = YES;
    
    MKCoordinateRegion mapRegion;
    mapRegion.center = self.mapView.userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.1;
    mapRegion.span.longitudeDelta = 0.1;
    
    [self.mapView setRegion:mapRegion animated:YES];
}

- (void)didDragMap:(UIGestureRecognizer*)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        _wantsLocateSelf = NO;
        if (self.mapView.selectedAnnotations.count == 0) {
            [UIView transitionWithView:_locateButton duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL completion:NULL];
            _locateButton.hidden = NO;
        }
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if (!_wantsLocateSelf) {
        [UIView transitionWithView:_locateButton duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL completion:NULL];
        _locateButton.hidden = YES;
    }
    
    [UIView transitionWithView:_deleteButton duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL completion:NULL];
    _deleteButton.hidden = NO;
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if (!_wantsLocateSelf) {
        [UIView transitionWithView:_locateButton duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL completion:NULL];
        _locateButton.hidden = NO;
    }
    
    [UIView transitionWithView:_deleteButton duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL completion:NULL];
    _deleteButton.hidden = YES;
}

#pragma mark BUTTONS

- (IBAction)menuAction:(id)sender {
    /*[UIView animateWithDuration:0.6f delay:0.1f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.menuButton.transform = CGAffineTransformMakeTranslation(-15, 0);
    } completion:nil];*/
    
    [_menu show];
}

- (IBAction)addAction:(id)sender {
    if (_mapView.userLocation != nil) {
        [UIView animateWithDuration:0.6f delay:0.1f options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.addButton.transform = CGAffineTransformRotate(self.addButton.transform, M_PI/2);
        } completion:nil];
        
        [self locateAction:self];
        
        PopoverContentViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PopoverContent"];
        vc.delegate = self;
        
        _popover = [[UIPopoverController alloc] initWithContentViewController:vc];
        _popover.popoverContentSize = CGSizeMake(280, 140);
        [_popover presentPopoverFromRect:CGRectMake(160, 260, 1, 1) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];

        _currentLocation = _mapView.userLocation.coordinate;
    }
}

#pragma mark SAVING

- (void)storeLocation:(NSString *)category andTitle:(NSString *)title {
    NSLog(@"Storing location");
    [_popover dismissPopoverAnimated:YES];
    
    Item *item = [[Item alloc] initWithCategory:category andTitle:title andCoordinates:_currentLocation];
    ItemCategory *cat = [self findCategoryForItem:item];
    
    for (Item *itm in cat.items) {
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(itm.latitude, itm.longitude);
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        [annotation setCoordinate:coord];
        [annotation setTitle:itm.title];
        [self.mapView addAnnotation:annotation];
        
        [_mapView selectAnnotation:annotation animated:YES];
    }
    
    [self.mapView showAnnotations:self.mapView.annotations animated:YES];
    _wantsLocateSelf = NO;
    
    self.titleLabel.text = category;
}

- (ItemCategory *)findCategoryForItem:(Item *)item {
    NSString *categoryName = item.category;
    
    NSData *arraysData = [[NSUserDefaults standardUserDefaults] objectForKey:@"categories"];
    NSMutableArray *array = [[NSKeyedUnarchiver unarchiveObjectWithData:arraysData] mutableCopy];
    
    ItemCategory *categoryForItem;
    
    for (ItemCategory *cat in array) {
        if ([cat.categoryName compare:categoryName options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            NSLog(@"They are equal!");
            categoryForItem = cat;
            [array removeObject:cat];
            break;
        }
    }
    
    if (categoryForItem == nil) {
        NSLog(@"They weren't equal!");
        categoryForItem = [[ItemCategory alloc] initWithCategoryName:categoryName andItem:item];
    } else {
        [categoryForItem addItemToCategory:item];
    }
    
    if ([_selectedCategory.categoryName compare:categoryForItem.categoryName options:NSCaseInsensitiveSearch] != NSOrderedSame || _selectedCategory.categoryName == nil) {
        NSLog(@"Selected category and new category are not equal!");
        _selectedCategory = categoryForItem;
        //[self resetView];
    }
    [self resetView];
    
    [array addObject:categoryForItem];
    _menuItems = array;
    [_menu reloadViewWithArray:_menuItems];
    
    arraysData = [NSKeyedArchiver archivedDataWithRootObject:array];
    [[NSUserDefaults standardUserDefaults] setObject:arraysData forKey:@"categories"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return categoryForItem;
}

- (IBAction)deleteAction:(id)sender {
    if (_mapView.selectedAnnotations.count == 1) {
        NSLog(@"Deleting...");
        MKPointAnnotation *annotation = _mapView.selectedAnnotations[0];
        NSString *description = annotation.title;
        
        [_menuItems removeObject:_selectedCategory];
        for (Item *itm in _selectedCategory.items) {
            if ([description isEqualToString:itm.title]) {
                NSLog(@"Removed item");
                [_selectedCategory.items removeObject:itm];
                
                [_mapView removeAnnotation:annotation];
                
                break;
            }
        }
        
        if (_selectedCategory.items.count > 0) {
            NSLog(@"Inserted category");
            [_menuItems addObject:_selectedCategory];
        }
        
        NSData *arraysData = [NSKeyedArchiver archivedDataWithRootObject:_menuItems];
        [[NSUserDefaults standardUserDefaults] setObject:arraysData forKey:@"categories"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [_menu reloadViewWithArray:_menuItems];
    }
}

#pragma mark VIEW

- (void)resetView {
    //Add code here to reset labels and pins when user adds location to new category
    self.titleLabel.text = @"";
    [self.mapView removeAnnotations:self.mapView.annotations];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    NSLog(@"Cancelled");
    _currentLocation = CLLocationCoordinate2DMake(0, 0);
}

#pragma mark MENU

- (void)selectedItemAtIndex:(NSInteger)index {
    [self resetView];
    
    ItemCategory *cat = _menuItems[index];
    _selectedCategory = cat;
    [self.titleLabel setText:cat.categoryName];
    
    for (Item *itm in cat.items) {
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(itm.latitude, itm.longitude);
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        [annotation setCoordinate:coord];
        [annotation setTitle:itm.title];
        
        [self.mapView addAnnotation:annotation];
    }
    
    _wantsLocateSelf = NO;
    _locateButton.hidden = NO;
    
    [self.mapView showAnnotations:self.mapView.annotations animated:YES];
    
    [_menu hide];
}

- (void)willPresentPopup {
    PopupViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"popupViewController"];
    RWBlurPopover *popover = [[RWBlurPopover alloc] initWithContentViewController:vc];
    [self presentViewController:popover animated:YES completion:nil];
}

#pragma mark DEBUG

- (void)addAnnotationsWithTouch {
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 2.0;
    [self.mapView addGestureRecognizer:lpgr];
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    [self addAction:self];
    _currentLocation = touchMapCoordinate;
}

#pragma mark OTHER

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
