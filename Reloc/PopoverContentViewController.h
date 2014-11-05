//
//  PopoverContentViewController.h
//  Reloc
//
//  Created by Aleksander Skjølsvik on 13.09.14.
//  Copyright (c) 2014 alekApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTAutoCompleteManager.h"
#import "HTAutocompleteTextField.h"


@protocol PopoverContentDelegate <NSObject>

- (void)storeLocation:(NSString *)category andTitle:(NSString *)title;

@end

@interface PopoverContentViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, assign) id<PopoverContentDelegate> delegate;

@end
