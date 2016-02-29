//
//  BasicViewExperiment.m
//  everything-about-objc
//
//  Created by Bin Yu on 27/02/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "BasicViewExperiment.h"
#import "CustomControl.h"
#import "CustomDrawView.h"
#import "DummyView.h"
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
    UIView *rootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    rootView.backgroundColor = [UIColor whiteColor];
    
    CustomControl *customControl = [CustomControl new];
    customControl.center = CGPointMake(CGRectGetMidX(rootView.frame),
                                    CGRectGetMidY(rootView.frame));
    customControl.bounds = CGRectMake(0, 0,
                                   CGRectGetWidth(rootView.frame)/2,
                                   CGRectGetHeight(rootView.frame)/2);
    customControl.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                     UIViewAutoresizingFlexibleHeight;
    [customControl addTarget:self action:@selector(handleValueChange:) forControlEvents:UIControlEventValueChanged];
    [rootView addSubview:customControl];
    [self showResultView:rootView];
}

- (void)ViewDrawCycleExperimentCase {
    CustomDrawView *drawView = [[CustomDrawView alloc] init];
    [self showResultView:drawView];
}

- (void)ViewAnimationExperimentCase {
    /**
     UIView animation and nested animation
     transitionWithView:duration:options:animations:completion:
     */
    UIView *rootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    rootView.backgroundColor = [UIColor whiteColor];
    
    UIView *normalView = [[UIView alloc] init];
    normalView.center = CGPointMake(CGRectGetMidX(rootView.frame),
                                    CGRectGetMidY(rootView.frame));
    normalView.bounds = CGRectMake(0, 0,
                                   CGRectGetWidth(rootView.frame)/2,
                                   CGRectGetHeight(rootView.frame)/2);
    normalView.backgroundColor = [UIColor redColor];
    normalView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                  UIViewAutoresizingFlexibleHeight;
    [rootView addSubview:normalView];
    
    NSData *imageData =
        [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.umbitious.com/media/16172/hello_world_crop.jpg"]];
    UIImage *image = [UIImage imageWithData:imageData];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.frame = normalView.frame;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                 UIViewAutoresizingFlexibleHeight;
    NSArray<ExperimentCaseStep> *steps = @[
        ^(UIView *view){
            [UIView animateWithDuration:1.0 delay:0
                 usingSpringWithDamping:0.5 initialSpringVelocity:1.0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 view.frame = CGRectInset(view.frame, -20, -20);
                                 // nested core animation to change the default settings
                                 CABasicAnimation *colorAnimation =
                                    [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
                                 colorAnimation.duration = 3.0;
                                 colorAnimation.fromValue = (id)[[view backgroundColor] CGColor];
                                 colorAnimation.toValue = (id)[[UIColor greenColor] CGColor];
                                 [view.layer addAnimation:colorAnimation forKey:@"ColorAnimation"];
                             } completion:^(BOOL finished) {
                                 view.layer.backgroundColor = [[UIColor greenColor] CGColor];
                             }];
        },
        ^(UIView *view) {
          /**
           http://andrewmarinov.com/working-with-uiviews-transition-animations/
           - transitionFromView:toView:duration:options:completion automatically
           handles the manipulation of the view hierarchy
           - this method executes all of its animation on the superview of the
           two views
           - [UIView transitionWithView:containerView
                               duration:0.2
                               options:UIViewAnimationOptionTransitionFlipFromLeft
                               animations:^{
                                    [fromView removeFromSuperview];
                                    [containerView addSubview:toView];
                               }
                               completion:NULL];

           */
          [UIView transitionFromView:view
                              toView:imageView
                            duration:1.0f
                             options:UIViewAnimationOptionTransitionCurlUp |
                                     UIViewAnimationOptionAutoreverse |
                                     UIViewAnimationOptionRepeat
                          completion:^(BOOL finished){

                          }];
        }
    ];
    [self setupCaseSteps:steps forView:normalView];
    [self showResultView:rootView];
}

- (void)BasicHitTestExperimentCase {
    DummyView *rootView = [DummyView dummyViewHierarchy];
    /**
     Gesture caught touchesEnded event BEFORE Hit-testing passed view
     
     Regulating the Delivery of Touches to Views
     
     There may be times when you want a view to receive a touch before a gesture recognizer. 
     But, before you can alter the delivery path of touches to views, you need to understand the default behavior. 
     In the simple case, when a touch occurs, the touch object is passed from the UIApplication object to the UIWindow object.
     Then, the window first sends touches to any gesture recognizers attached the view where the touches occurred (or to that view’s superviews), 
     before it passes the touch to the view object itself.
     */
    UITapGestureRecognizer *tapGestureRecognizer =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handleGesture)];
    [rootView addGestureRecognizer:tapGestureRecognizer];
    [self showResultView:rootView];
}

#pragma mark - Private

- (void)handleGesture {
    MLog(@"Root view gesture handler caught touch event");
}

- (void)handleValueChange:(CustomControl *)customControl {
    MLog(@"Custom control angle value: %.2f", customControl.endAngle);
}

@end
