//
//  PopupViewController.m
//  Reloc
//
//  Created by Aleksander Skjølsvik on 13.09.14.
//  Copyright (c) 2014 alekApps. All rights reserved.
//

#import "PopupViewController.h"

@interface PopupViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *pennAppsImageView;

@end

@implementation PopupViewController {
    NSTimer *_timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pennAppsImageView.image = [self.pennAppsImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.pennAppsImageView setTintColor:[UIColor colorWithRed:192.0f/255.0f green:208.0f/255.0f blue:230.0f/255.0f alpha:1.0f]];
    
    _timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(changeColor) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

- (void)changeColor {
    double r = drand48();
    double g = drand48();
    double b = drand48();
    
    [self.pennAppsImageView setTintColor:[UIColor colorWithRed:(r * 255.0f)/255.0f green:(g * 255.0f)/255.0f blue:(b * 255.0f)/255.0f alpha:1.0f]];
}

- (CGSize)preferredContentSize {
    return CGSizeMake(280, 200);
}


@end
