//
//  PageContentViewController.h
//  Reloc
//
//  Created by Aleksander Skjølsvik on 13.09.14.
//  Copyright (c) 2014 alekApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageContentViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;


@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *imageFile;

@end
