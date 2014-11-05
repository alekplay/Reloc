//
//  HTAutoCompleteManager.m
//  Reloc
//
//  Created by Aleksander Skjølsvik on 13.09.14.
//  Copyright (c) 2014 alekApps. All rights reserved.
//

#import "HTAutoCompleteManager.h"

static HTAutoCompleteManager *sharedManager;

@implementation HTAutoCompleteManager {
    NSMutableArray *_autoCompleteArray;
}

+ (HTAutoCompleteManager *)sharedManager {
    static dispatch_once_t done;
    dispatch_once(&done, ^{
        sharedManager = [[HTAutoCompleteManager alloc] init];
    });
    return sharedManager;
}

- (NSString *)textField:(HTAutocompleteTextField *)textField completionForPrefix:(NSString *)prefix ignoreCase:(BOOL)ignoreCase {
    if (textField.autocompleteType == HTAutocompleteTypeCategory) {
        NSString *stringToLookFor = [prefix lowercaseString];
        for (NSString *stringFromReference in self.autoCompleteArray) {
            NSString *stringToCompare = [stringFromReference lowercaseString];
            
            if ([stringToCompare hasPrefix:stringToLookFor]) {
                return [stringFromReference stringByReplacingCharactersInRange:[stringToCompare rangeOfString:stringToLookFor] withString:@""];
            }
        }
    }
    
    return @"";
}

@end
