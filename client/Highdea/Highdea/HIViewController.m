//
//  HIViewController.m
//  Highdea
//
//  Created by Mason on 8/26/13.
//  Copyright (c) 2013 Tych. All rights reserved.
//

#import "HIViewController.h"

@interface HIViewController ()

@end

@implementation HIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) popHomeURL {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.reddit.com/r/trees"]];
}

- (IBAction) popBTCURL {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://blockchain.info/address/15SJSbbb6E3VynFgzH4tAbh3MEJEnietBS"]];
}


@end
