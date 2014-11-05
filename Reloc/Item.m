//
//  Item.m
//  Reloc
//
//  Created by Aleksander Skjølsvik on 13.09.14.
//  Copyright (c) 2014 alekApps. All rights reserved.
//

#import "Item.h"

@implementation Item

- (id)initWithCategory:(NSString *)category andTitle:(NSString *)title andCoordinates:(CLLocationCoordinate2D)coordinates {
    if (self = [super init]) {
        self.category = category;
        self.title = title;
        self.latitude = coordinates.latitude;
        self.longitude = coordinates.longitude;
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.category forKey:@"category"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeDouble:self.latitude forKey:@"latitude"];
    [aCoder encodeDouble:self.longitude forKey:@"longitude"];
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super init]) {
        self.category = [aDecoder decodeObjectForKey:@"category"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.latitude = [aDecoder decodeDoubleForKey:@"latitude"];
        self.longitude = [aDecoder decodeDoubleForKey:@"longitude"];
    }
    
    return self;
}

@end
