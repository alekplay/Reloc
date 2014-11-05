//
//  Item.h
//  Reloc
//
//  Created by Aleksander Skjølsvik on 13.09.14.
//  Copyright (c) 2014 alekApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Item : NSObject

@property NSString *category;
@property NSString *title;
@property CLLocationDegrees latitude;
@property CLLocationDegrees longitude;

- (id)initWithCategory:(NSString *)category andTitle:(NSString *)title andCoordinates:(CLLocationCoordinate2D)coordinates;

@end
