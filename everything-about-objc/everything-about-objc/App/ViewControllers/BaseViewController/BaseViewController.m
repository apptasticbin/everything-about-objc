//
//  BaseViewController.m
//  everything-about-objc
//
//  Created by Bin Yu on 20/02/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UIResponser

/**
 - In Xcode 7, Apple has introduced 'Lightweight Generics' to Objective-C
 - In Objective-C, they will generate compiler warnings if there is a type mismatch
 - http://www.miqu.me/blog/2015/06/09/adopting-objectivec-generics/
 - http://stackoverflow.com/questions/848641/are-there-strongly-typed-collections-in-objective-c
 */
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
