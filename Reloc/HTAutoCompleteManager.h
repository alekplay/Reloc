//
//  HTAutoCompleteManager.h
//  Reloc
//
//  Created by Aleksander Skjølsvik on 13.09.14.
//  Copyright (c) 2014 alekApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTAutocompleteTextField.h"

typedef enum {
    HTAutocompleteTypeCategory,
} HTAutocompleteType;


@interface HTAutoCompleteManager : NSObject <HTAutocompleteDataSource>

@property NSMutableArray *autoCompleteArray;

+ (HTAutoCompleteManager *)sharedManager;

@end