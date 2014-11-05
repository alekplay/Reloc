//
//  PageContentViewController.m
//  Reloc
//
//  Created by Aleksander Skjølsvik on 13.09.14.
//  Copyright (c) 2014 alekApps. All rights reserved.
//

#import "PageContentViewController.h"

@interface PageContentViewController ()

@end

@implementation PageContentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.backgroundImageView.image = [UIImage imageNamed:self.imageFile];
    self.titleLabel.text = self.titleText;
    
    //self.view.alpha = 0.5;
    /*CALayer *layer = [self.view layer];
    [layer setRasterizationScale:0.75];
    [layer setShouldRasterize:YES];*/
    
    /*self.titleLabel.alpha = 1.0;
    self.backgroundImageView.alpha = 1.0;*/
    
    [self.view setBackgroundColor:[[UIColor clearColor] colorWithAlphaComponent:0.0]];
    CALayer *layer = [self.view layer];
    [layer setRasterizationScale:0.75];
    [layer setShouldRasterize:YES];
    
    if (self.pageIndex >= 4) {
        UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissVC)];
        [self.view addGestureRecognizer:tgr];
    }
}

- (void)dismissVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
