//
//  PopoverContentViewController.m
//  Reloc
//
//  Created by Aleksander Skjølsvik on 13.09.14.
//  Copyright (c) 2014 alekApps. All rights reserved.
//

#import "PopoverContentViewController.h"
#import "ItemCategory.h"

@interface PopoverContentViewController ()
@property (strong, nonatomic) IBOutlet HTAutocompleteTextField *categoryTextfield;
@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
- (IBAction)saveAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;

@end

@implementation PopoverContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSData *categoriesData = [[NSUserDefaults standardUserDefaults] objectForKey:@"categories"];
    NSArray *categories = [NSKeyedUnarchiver unarchiveObjectWithData:categoriesData];
    NSMutableArray *autoCompleteArray = [NSMutableArray array];
    for (ItemCategory *cat in categories) {
        NSLog(@"Adding %@ to autoCompleteArray", cat.categoryName);
        [autoCompleteArray addObject:cat.categoryName];
    }
    
    self.categoryTextfield.delegate = self;
    self.categoryTextfield.tag = 0;
    [self.categoryTextfield becomeFirstResponder];
    [HTAutocompleteTextField setDefaultAutocompleteDataSource:[HTAutoCompleteManager sharedManager]];
    [HTAutoCompleteManager sharedManager].autoCompleteArray = autoCompleteArray;
    self.categoryTextfield.autocompleteType = HTAutocompleteTypeCategory;
    self.categoryTextfield.autocompleteTextOffset = CGPointMake(0, -1.0);
    
    
    self.titleTextField.delegate = self;
    self.titleTextField.tag = 1;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)saveAction:(id)sender {
    [_delegate storeLocation:self.categoryTextfield.text andTitle:self.titleTextField.text];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if([textField.text stringByReplacingCharactersInRange:range withString:string].length == 0) {
        self.saveButton.enabled = NO;
    } else {
        UITextField *otherTextField = textField == self.categoryTextfield ? self.titleTextField : self.categoryTextfield;
        if ([otherTextField.text length] > 0) {
            if ([string length] > 0) {
                self.saveButton.enabled = YES;
            } else {
                self.saveButton.enabled = NO;
            }
        } else {
            self.saveButton.enabled = NO;
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    self.saveButton.enabled = NO;
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSInteger nextTag = textField.tag + 1;
    
    UIResponder *nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        [nextResponder becomeFirstResponder];
    } else {
        if (self.categoryTextfield.text.length > 0 && self.titleTextField.text.length > 0) {
            [textField resignFirstResponder];
            [self saveAction:self];
        }
    }
    
    return NO;
}

@end