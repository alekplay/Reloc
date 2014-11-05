//
//  ItemCategory.m
//  Reloc
//
//  Created by Aleksander Skjølsvik on 13.09.14.
//  Copyright (c) 2014 alekApps. All rights reserved.
//

#import "ItemCategory.h"

@implementation ItemCategory

- (id)initWithCategoryName:(NSString *)name andItem:(Item *)item {
    if (self = [super init]) {
        self.categoryName = name;
        self.items = [NSMutableArray arrayWithObject:item];
    }
    
    return self;
}

- (void)addItemToCategory:(Item *)item {
    [self.items addObject:item];
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.categoryName forKey:@"categoryName"];
    [aCoder encodeObject:self.items forKey:@"items"];
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super init]) {
        self.categoryName = [aDecoder decodeObjectForKey:@"categoryName"];
        self.items = [aDecoder decodeObjectForKey:@"items"];
    }
    
    return self;
}

@end
