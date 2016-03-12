//
//  ViewLayoutExperiment.m
//  everything-about-objc
//
//  Created by Bin Yu on 10/03/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "ViewLayoutExperiment.h"
#import "DummyAutoLayoutView.h"

@implementation ViewLayoutExperiment

#pragma mark - Experiment Protocol

+ (NSString *)displayName {
    return @"View Layout";
}

+ (NSString *)displayDesc {
    return @"Try out auto resizing, auto layout, intrinsic content size, internal layout changes, contraint animation, and all other topics related to layout management.";
}

#pragma mark - Expereiment Cases

/**
 - Using auto resizing with auto layout
 - Modify autolayout, managing layout subviews
 - Intrinsic content size
 - Content Hugging and Compression Resistance
 - Optional constraints, Required constraints and Priority
 - Create constraints programatically; Visual Format Language
 */

- (void)AutoResizingExperimentCase {
    UIView *rootView = [self rootView];
    UIView *redView = [self dummyViewAtPosition:CGPointMake(CGRectGetMidX(rootView.frame),
                                                            CGRectGetMidY(rootView.frame))
                                         inView:rootView withColor:[UIColor redColor]];
    redView.bounds = CGRectMake(0, 0, 250, 250);
    UIView *blueView = [self dummyViewAtPosition:CGPointMake(CGRectGetMidX(redView.frame),
                                                             CGRectGetMidY(redView.frame))
                                          inView:redView withColor:[UIColor blueColor]];
    /**
     translate auto resizing mask into constraints
     - no matter 'translatesAutoresizingMaskIntoConstraints' is YES or NO, autoresizing mask works
     */
    blueView.translatesAutoresizingMaskIntoConstraints = NO;
    blueView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [redView addSubview:blueView];
    
    NSArray<ExperimentCaseStep> *steps =
    @[
      ^(UIView *view){
          [UIView animateWithDuration:2.0f animations:^{
              redView.bounds = CGRectMake(0, 0, 350, 350);
          }];
      }
       ];
    [self setupCaseSteps:steps forView:rootView];
    [self showResultView:rootView];
}

- (void)LayoutSubviewsWithAutoLayoutExperimentCase {
    /**
     - Auto Layout introduces two additional steps to the process before 
     views can be displayed: 'updating constraints' and 'laying out views'.
     - Each step is dependent on the one before; display depends on layout,
     and layout depends on updating constraints
     */
    DummyAutoLayoutView *autoLayoutView = [DummyAutoLayoutView new];
    autoLayoutView.bounds = CGRectMake(0, 0, 300, 300);
    [self showResultView:autoLayoutView];
}

- (void)ViewDynamicSizeExperimentCase {
    
}

@end
