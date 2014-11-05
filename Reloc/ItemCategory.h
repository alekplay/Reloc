//
//  ItemCategory.h
//  Reloc
//
//  Created by Aleksander Skjølsvik on 13.09.14.
//  Copyright (c) 2014 alekApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"

@interface ItemCategory : NSObject

@property NSString *categoryName;
@property NSMutableArray *items;

- (id)initWithCategoryName:(NSString *)name andItem:(Item *)item;
- (void)addItemToCategory:(Item *)item;

@end
