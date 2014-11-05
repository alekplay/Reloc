//
//  ViewController.h
//  Reloc
//
//  Created by Aleksander Skjølsvik on 13.09.14.
//  Copyright (c) 2014 alekApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "BlurMenu.h"
#import "PopoverContentViewController.h"
#import "Item.h"
#import "ItemCategory.h"

@interface ViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, BlurMenuDelegate, PopoverContentDelegate, UIGestureRecognizerDelegate>

@end
