//
//  RotatableScorllViewController.m
//  SteelERP
//
//  Created by Xinyuan on 9/6/13.
//  Copyright (c) 2013 Xinyuan. All rights reserved.
//

#import "RotatableScorllViewController.h"

@interface RotatableScorllViewController ()

@end

@implementation RotatableScorllViewController

- (id)init
{
    self = [super init];
    if (self) {
        UIScrollView* scrollView = [[UIScrollView alloc] init];
        self.view = scrollView;
        [scrollView release];
    }
    return self;
}

@end
