//
//  AMViewController.m
//  Highdea
//
//  Created by Mason on 3/25/13.
//  Copyright (c) 2013 LoMason. All rights reserved.
//

#import "AMViewController.h"

@interface AMViewController ()

@property (weak, nonatomic) IBOutlet UILabel *idea;

@end

@implementation AMViewController

AM_INIT_VIEW_CONTROLLER

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.idea.y = self.view.height;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    self.idea.text = @"this works?";
    
    [UIView animateWithDuration:5.0 animations:^{
        self.idea.y = -self.idea.height;        
    }];
    
}


@end
