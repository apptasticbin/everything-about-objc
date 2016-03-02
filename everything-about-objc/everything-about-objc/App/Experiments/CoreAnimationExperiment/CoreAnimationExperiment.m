//
//  CoreAnimationExperiment.m
//  everything-about-objc
//
//  Created by Bin Yu on 02/03/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "CoreAnimationExperiment.h"
#import "MLog.h"

@implementation CoreAnimationExperiment

+ (NSString *)displayName {
    return @"Core Animation";
}

+ (NSString *)displayDesc {
    return @"Try out basic layer-based core animation and transitions.";
}

#pragma mark - Experiment Cases

- (void)BasicAnimationExperimentCase {
    // Core Animation: CABasicAnimation, CAKeyFrameAnimation
    UIView *rootView = [self rootView];
    CALayer *redLayer = [CALayer layer];
    redLayer.position = CGPointMake(CGRectGetMidX(rootView.layer.frame),
                                    CGRectGetMidY(rootView.layer.frame));
    redLayer.bounds = CGRectMake(0, 0, 150, 150);
    redLayer.backgroundColor = [[UIColor redColor] CGColor];
    [rootView.layer addSublayer:redLayer];
    
    NSArray<ExperimentCaseStep> *steps =
    @[
      ^(UIView *view) {
          CGPoint originalPosition = redLayer.position;
          /**
           http://oleb.net/blog/2012/11/prevent-caanimation-snap-back/
           Animation doesn't change the real value. So we need to assign it mannually
           */
          redLayer.position = CGPointMake(200, 200);
          
          CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
          animation.fromValue = [NSValue valueWithCGPoint:originalPosition];
          animation.toValue = [NSValue valueWithCGPoint:redLayer.position];
          animation.timingFunction =
            [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
          animation.duration = 2.0f;
          animation.delegate = self;
          [redLayer addAnimation:animation forKey:@"position"];
      },
       ^(UIView *view) {
           redLayer.backgroundColor = [[UIColor orangeColor] CGColor];
           CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"backgroundColor"];
           keyFrameAnimation.duration = 3.0f;
           keyFrameAnimation.keyTimes = @[@(0), @(0.5), @(1)];
           keyFrameAnimation.values = @[
                                        (id)[[UIColor greenColor] CGColor],
                                        (id)[[UIColor blueColor] CGColor],
                                        (id)[[UIColor orangeColor] CGColor]];
           keyFrameAnimation.delegate = self;
           [redLayer addAnimation:keyFrameAnimation forKey:@"color"];
       }
       ];
    
    [self setupCaseSteps:steps forView:rootView];
    [self showResultView:rootView];
}

- (void)CATransitionExperimentCase {
    
}

- (void)AnimationPausingExperimentCase {
    // Pause and resume layer animations ( try to understand timeOffset, beginTime)
}

#pragma mark - Core Animation Delegate

- (void)animationDidStart:(CAAnimation *)anim {
    MLog(@"Animaiton %@ started", anim);
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    MLog(@"Animaiton %@ stopped", anim);
}

@end
