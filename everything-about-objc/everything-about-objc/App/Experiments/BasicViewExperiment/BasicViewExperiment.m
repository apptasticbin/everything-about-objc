//
//  BasicViewExperiment.m
//  everything-about-objc
//
//  Created by Bin Yu on 27/02/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "BasicViewExperiment.h"
#import "ViewGeometricViewController.h"

@implementation BasicViewExperiment

+ (NSString *)displayName {
    return @"Basic View";
}

+ (NSString *)displayDesc {
    return @"Try out UIView related APIs";
}

/**
 View Frame, Bound, Center, Coordination, contentMode, transform
 */
- (void)UIViewExperimentCase {
    ViewGeometricViewController *geometricViewController = [ViewGeometricViewController new];
    [self showResultViewController:geometricViewController];
}

- (void)UIControlExperimentCase {
    
}

- (void)LayerAndCoreAnimationExperimentCase {
    
}

- (void)ViewDrawCycelExperimentCase {
    
}

- (void)ViewAnimationExperimentCase {
    /**
     UIView animation and nested animation
     transitionWithView:duration:options:animations:completion:
     */
}

- (void)HitTestExperimentCase {
    
}

@end
