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
    UIView *rootView = [self rootView];
    UIView *redView =
    [self dummyViewAtPosition:rootView.center inView:rootView withColor:[UIColor redColor]];
    UIView *blueView =
    [self dummyViewAtPosition:rootView.center inView:rootView withColor:[UIColor blueColor]];
    blueView.hidden = YES;
    
    NSArray<ExperimentCaseStep> *steps =
    @[
      ^(UIView *view) {
          /**
           https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/CoreAnimation_guide/AdvancedAnimationTricks/AdvancedAnimationTricks.html#//apple_ref/doc/uid/TP40004514-CH8-SW1
           
           a transition animation manipulates a layer’s cached image to create visual effects that would be difficult 
           or impossible to do by changing properties alone
           
           seems that if using two layers belong to same view (instead of two views), system will be lazy, and dirrectly
           finish hidden animation. That's why we need to seperate two layers into two views.
           */
          CATransition *pushTransition = [CATransition animation];
          pushTransition.startProgress = 0.0f;
          pushTransition.endProgress = 1.0f;
          pushTransition.duration = 2.0f;
          pushTransition.type = kCATransitionPush;
          pushTransition.subtype = kCATransitionFromRight;
          
          [redView.layer addAnimation:pushTransition forKey:@"transition"];
          [blueView.layer addAnimation:pushTransition forKey:@"transition"];
          
          redView.hidden = YES;
          blueView.hidden = NO;
          
      },
       ^(UIView *view) {
           /**
            http://blog.csdn.net/hello_hwc/article/details/47363645
            animate layer content
            */
           UIImage *imageView = [self dummyImage];
           
           CATransition *fadeTransition = [CATransition animation];
           fadeTransition.startProgress = 0;
           fadeTransition.endProgress = 1.0f;
           fadeTransition.duration = 2.0f;
           fadeTransition.type = kCATransitionFade;
           
           [blueView.layer addAnimation:fadeTransition forKey:@"fade"];
           blueView.layer.contents = (id)[imageView CGImage];
       }
       ];
    
    [self setupCaseSteps:steps forView:rootView];
    [self showResultView:rootView];
}

- (void)CATransactionExperimentCase {
    
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
