//
//  LayerExperiment.m
//  everything-about-objc
//
//  Created by Bin Yu on 01/03/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "LayerExperiment.h"

@implementation LayerExperiment

+ (NSString *)displayName {
    return @"Layers";
}

+ (NSString *)displayDesc {
    return @"Try out different layers and layer animations";
}

#pragma mark - Experiments

- (void)BasicLayerOperationExperimentCase {
    UIView *rootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    rootView.backgroundColor = [UIColor whiteColor];
    
    CALayer *normalLayer = [CALayer layer];
    normalLayer.position = CGPointMake(CGRectGetMidX(rootView.layer.frame),
                                       CGRectGetMidY(rootView.layer.frame));
    normalLayer.bounds = CGRectMake(0, 0, 150, 150);
    normalLayer.backgroundColor = [[UIColor redColor] CGColor];
    
    [rootView.layer addSublayer:normalLayer];
    
    NSArray<ExperimentCaseStep> *steps =
    @[
      ^(UIView *view) {
          /**
           layer property will trigger animation ONLY when new value is different
           */
          normalLayer.backgroundColor = [[UIColor blueColor] CGColor];
          normalLayer.cornerRadius = 30.0f;
          normalLayer.anchorPoint = CGPointMake(0.2, 0.2);
          normalLayer.borderWidth = 5;
          normalLayer.borderColor = [[UIColor redColor] CGColor];
          normalLayer.bounds = CGRectInset(normalLayer.bounds, -20, -20);
          normalLayer.opacity = 0.2;
      },
       ^(UIView *view) {
           CATransform3D transform = CATransform3DIdentity;
           transform = CATransform3DTranslate(transform, -50, -50, 0);
           transform = CATransform3DRotate(transform, M_PI_4, 0, 0, 1);
           normalLayer.transform = transform;
       },
       ^(UIView *view) {
           CATransform3D transform = CATransform3DIdentity;
           transform = CATransform3DRotate(transform, M_PI_2, 0, 0, 1);
           normalLayer.transform = transform;
       }
       ];
    [self setupCaseSteps:steps forView:rootView];
    [self showResultView:rootView];
}

- (void)LayerMaskExperimentCase {
    // CALayer and mask
    UIView *rootView = [self rootView];
    CALayer *contentLayer = [CALayer layer];
    contentLayer.position = CGPointMake(CGRectGetMidX(rootView.layer.frame),
                                       CGRectGetMidY(rootView.layer.frame));
    contentLayer.bounds = CGRectMake(0, 0, 250, 250);
    contentLayer.backgroundColor = [[UIColor redColor] CGColor];
    [rootView.layer addSublayer:contentLayer];
    
    UIImage *dummyImage = [self dummyImage];
    
    NSArray<ExperimentCaseStep> *steps =
    @[
      ^(UIView *view) {
          // resize contents gravity
          contentLayer.contentsGravity = @"resizeAspect";
          contentLayer.contents = (id)dummyImage.CGImage;
      },
       ^(UIView *view) {
           /**
            http://stackoverflow.com/questions/16512761/calayer-with-transparent-hole-in-it
            */
           CAShapeLayer *holeShapeLayer = [CAShapeLayer layer];
           // Center the hole rect in the middle
           CGRect holeRect = CGRectMake(75, 75, 100, 100);
           UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:contentLayer.bounds];
           UIBezierPath *holePath = [UIBezierPath bezierPathWithRoundedRect:holeRect cornerRadius:100];
           [rectPath appendPath:holePath];
           rectPath.usesEvenOddFillRule = YES;
           holeShapeLayer.path = [rectPath CGPath];;
           // MUST set fill rule to even-odd rule
           holeShapeLayer.fillRule = kCAFillRuleEvenOdd;
           // ONLY area that has color can be displayed
           holeShapeLayer.fillColor = [UIColor grayColor].CGColor;
           holeShapeLayer.opacity = 0.5;
           
           contentLayer.mask = holeShapeLayer;
       }
       ];
    [self setupCaseSteps:steps forView:rootView];
    [self showResultView:rootView];
}

- (void)ShapeLayerExperimentCase {
    /**
     The even-odd rule is simply this:
     
     As you progress in a straight line across the canvas containing the path, 
     count the number of times you cross the path. If you have crossed an odd number of times, 
     you are "inside" the path. If you have crossed an even number of times, you are outside the path.
     */
}

- (void)CoreAnimationWithLayerExperimentCase {
    // Core Animation, Layers, Anchor points, transform, Path, CABasicAnimation, CAKeyFrameAnimation
}

- (void)CoreAnimationPausingWithLayerExperimentCase {
    // Pause and resume layer animations ( try to understand timeOffset, beginTime)
}

- (void)CustomLayerAction {
    // Custom Layer action (CAAction)
}

@end
