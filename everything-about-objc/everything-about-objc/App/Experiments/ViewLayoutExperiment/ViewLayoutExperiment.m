//
//  ViewLayoutExperiment.m
//  everything-about-objc
//
//  Created by Bin Yu on 10/03/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "ViewLayoutExperiment.h"
#import "AdvancedAutoLayoutView.h"
#import "DummyAutoLayoutView.h"
#import "DynamicSizeView.h"

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

/**
 - When working with constant values, the second item is left blank, 
 the second attribute is set to Not An Attribute, and the multiplier is set to 0.0.
 - When Auto Layout solves these equations, it does not just assign the value of the 
 right side to the left. Instead, it calculates the value for both attribute 1 and attribute 2 
 that makes the relationship true. This means we can often freely reorder the items in the equation
 - As soon as you start using inequalities, the two constraints per view per dimension 
 rule breaks down. You can always replace a single equality relationship with two inequalities
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
    /**
     https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIView_Class/#//apple_ref/occ/instm/UIView/intrinsicContentSize
     http://stackoverflow.com/questions/24127032/proper-usage-of-intrinsiccontentsize-and-sizethatfits-on-uiview-subclass-with-a
     - The intrinsic content size is the size a view prefers to have for a specific content it displays.
     For example, UILabel has a preferred height based on the font, and a preferred width based on t
     he font and the text it displays. A UIProgressView only has a preferred height based on its artwork, 
     but no preferred width. A plain UIView has neither a preferred width nor a preferred height
     - Note that the intrinsic content size must be independent of the view’s frame. For example, 
     it’s not possible to return an intrinsic content size with a specific aspect ratio based 
     on the frame’s height or width
     - Custom views typically have content that they display of ### which the layout system is UNAWARE ###.
     Overriding this method allows a custom view to communicate to the layout system what size it 
     would like to be based on its content. This intrinsic size must be independent of the content frame,
     because there’s no way to dynamically communicate a changed width to the layout system based on a changed height
     */
    UIView *rootView = [self rootView];
    DynamicSizeView *dynamicSizeView =
    [[[NSBundle mainBundle] loadNibNamed:@"DynamicSizeView" owner:nil options:nil] firstObject];
    dynamicSizeView.translatesAutoresizingMaskIntoConstraints = NO;
    [rootView addSubview:dynamicSizeView];
    
    NSLayoutConstraint *dynamicSizeViewCenterX =
    [NSLayoutConstraint constraintWithItem:dynamicSizeView
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:rootView
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1.0f
                                  constant:0];
    NSLayoutConstraint *dynamicSizeViewCenterY =
    [NSLayoutConstraint constraintWithItem:dynamicSizeView
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:rootView
                                 attribute:NSLayoutAttributeCenterY
                                multiplier:1.0f
                                  constant:0];
    /**
     http://stackoverflow.com/questions/17491376/ios-autolayout-multi-line-uilabel
     - preferredMaxLayoutWidth can limit width of label
     - but in order to control the super view's width, we need constraints to super view's
     leading and trailing, so that the width information can be provided.
     */
    [rootView addConstraints:@[dynamicSizeViewCenterX, dynamicSizeViewCenterY]];
    
    /**
     - when we fix the width and height, then the super view CAN NOT change along with subview's changing.
     - text can not be fully displayed, if constraint width is less than preferredMaxLayoutWidth
     */
    NSLayoutConstraint *dynamicSizeViewWidth =
    [NSLayoutConstraint constraintWithItem:dynamicSizeView
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1.0f
                                  constant:250];
    NSLayoutConstraint *dynamicSizeViewHeight =
    [NSLayoutConstraint constraintWithItem:dynamicSizeView
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1.0f
                                  constant:170];
    [dynamicSizeView addConstraints:@[dynamicSizeViewWidth, dynamicSizeViewHeight]];
    
    /**
     now we change the height constraint to low priority, and make it equal to 0
     then size will change dynamically again.
     
     dynamicSizeViewHeight.priority = UILayoutPriorityDefaultLow;
     dynamicSizeViewHeight.constant = 0;
     */
    
    NSString *shortText = @"You have to decide, ...";
    NSString *longText = @"You have to decide, based on the content to be displayed, if your custom view has an intrinsic content size, and if so, for which dimensions.";
    dynamicSizeView.dummyLabel.text = shortText;
    
    NSArray<ExperimentCaseStep> *steps =
    @[
      ^(UIView *view) {
          /**
           Question: how to animate text change ?
           - Solution 1: http://stackoverflow.com/questions/33632266/animate-text-change-of-uilabel
           - Solution 2: ?
           */
          CATransition *transition = [CATransition animation];
          transition.type = kCATransitionFade;
          transition.duration = 0.5f;
          [dynamicSizeView.dummyLabel.layer addAnimation:transition forKey:@"kCATransitionFade"];
          dynamicSizeView.dummyLabel.text = longText;
      }, ^(UIView *view) {
          /**
           now we try to shrink the height less than 110, system has to break some constraints
           in order to prevent system breaking constraints, we lower the priority of height constraint of
           dynamicSizeView less than label's vertical compression resistance,
           so that it will break its height when there isn't enough space
           */
          dynamicSizeViewHeight.constant = 70.0f;
          [UIView animateWithDuration:1.0f animations:^{
              [dynamicSizeView layoutIfNeeded];
          }];
      }
       ];
    [self setupCaseSteps:steps forView:rootView];
    [self showResultView:rootView];
}

- (void)PriorityAndIntrinsicSizeExperimentCase {
    /**
     https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/AutolayoutPG/AnatomyofaConstraint.html
     - By default, all constraints are required. Auto Layout must calculate a solution that satisfies all the constraints. 
     If it cannot, there is an error. Auto Layout prints information about the unsatisfiable constraints to the console, 
     and chooses one of the constraints to break. It then recalculates the solution without the broken constraint
     - When calculating solutions, Auto Layout attempts to satisfy all the constraints in priority order from highest 
     to lowest. If it cannot satisfy an optional constraint, that constraint is ### skipped ### and it continues on to the
     next constraint
     - Even if an optional constraint cannot be satisfied, it can still influence the layout. 
     If there is any ambiguity in the layout after skipping the constraint, the system selects 
     the solution that comes closest to the constraint. In this way, unsatisfied optional constraints 
     act as a force pulling views towards them
     - When stretching a series of views to fill a space, if all the views have an identical content-hugging priority, 
     the layout is ambiguous. Auto Layout doesn’t know which view should be stretched.
     */
    
    /**
     Intrinsic Content Size Versus Fitting Size:
     - The intrinsic content size acts as an input to Auto Layout. When a view has an intrinsic content size,
     the system generates constraints to represent that size and the constraints are used to calculate the layout.
     - The fitting size, on the other hand, is an output from the Auto Layout engine. 
     It is the size calculated for a view based on the view’s constraints. 
     If the view lays out its subviews using Auto Layout, then the system may be able to 
     calculate a fitting size for the view based on its content.
     */
    
    UIView *rootView = [self rootView];
    AdvancedAutoLayoutView *advancedAutoLayoutView =
    [[[NSBundle mainBundle] loadNibNamed:@"AdvancedAutoLayoutView" owner:nil options:nil] firstObject];
    advancedAutoLayoutView.layer.borderColor = [[UIColor yellowColor] CGColor];
    advancedAutoLayoutView.layer.borderWidth = 2.0f;
    advancedAutoLayoutView.translatesAutoresizingMaskIntoConstraints = NO;
    [rootView addSubview:advancedAutoLayoutView];
    
    NSLayoutConstraint *viewCenterX =
    [NSLayoutConstraint constraintWithItem:advancedAutoLayoutView
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:rootView
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1.0f
                                  constant:0];
    NSLayoutConstraint *viewCenterY =
    [NSLayoutConstraint constraintWithItem:advancedAutoLayoutView
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:rootView
                                 attribute:NSLayoutAttributeCenterY
                                multiplier:1.0f
                                  constant:0];
    NSLayoutConstraint *viewWidth =
    [NSLayoutConstraint constraintWithItem:advancedAutoLayoutView
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1.0f
                                  constant:270];
    NSLayoutConstraint *viewHeight =
    [NSLayoutConstraint constraintWithItem:advancedAutoLayoutView
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:advancedAutoLayoutView
                                 attribute:NSLayoutAttributeWidth
                                multiplier:1.0f
                                  constant:0];
    [advancedAutoLayoutView addConstraints:@[viewWidth, viewHeight]];
    [rootView addConstraints:@[viewCenterX, viewCenterY]];
    
    NSArray<ExperimentCaseStep> *steps =
    @[
      ^(UIView *view) {
          /**
           https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/AutolayoutPG/ViewswithIntrinsicContentSize.html#//apple_ref/doc/uid/TP40010853-CH13-SW1
           */
          [advancedAutoLayoutView.longButton setTitle:@"Long Button" forState:UIControlStateNormal];
      }, ^(UIView *view) {
          advancedAutoLayoutView.nameLabel.font = [UIFont systemFontOfSize:36.0f];
      }, ^(UIView *view) {
          viewWidth.constant = 250.0f;
          [UIView animateWithDuration:1.0f animations:^{
              [advancedAutoLayoutView layoutIfNeeded];
          }];
      }
       ];
    [self setupCaseSteps:steps forView:rootView];
    [self showResultView:rootView];
}

@end
