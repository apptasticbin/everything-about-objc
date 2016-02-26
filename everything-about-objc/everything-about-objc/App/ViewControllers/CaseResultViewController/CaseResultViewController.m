//
//  CaseResultViewController.m
//  everything-about-objc
//
//  Created by Bin Yu on 26/02/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "CaseResultViewController.h"

@implementation CaseResultViewController

- (void)viewDidLoad {
    [self setupRootView];
    [self setupResultObject];

}

#pragma mark - Private

- (void)setupRootView {
    /**
     http://stackoverflow.com/questions/26644820/touches-on-transparent-uicontrol-are-ignored-not-handled-by-added-action-funct
     */
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)setupResultObject {
    if ([self.resultObject isKindOfClass:[UIView class]]) {
        [self setupResultView:self.resultObject];
    }
    if ([self.resultObject isKindOfClass:[UIViewController class]]) {
        UIViewController *resultViewController  = self.resultObject;
        [self addChildViewController:resultViewController];
        [self setupResultView:resultViewController.view];
        [resultViewController didMoveToParentViewController:self];
    }
}

#pragma mark - Private

- (void)setupResultView:(UIView *)resultView {
    /**
     - The content mode specifies how the cached bitmap of the view’s layer is adjusted when the view’s bounds change.
     - ######For an image view, this is talking about the image. For a view that draws its content, this is talking about the drawn content. ######
     It does not affect the layout of subviews.
     - You need to look at the autoresizing masks in place on the subviews. Content mode is a red herring here.
     If you can't achieve the layout you need using autoresizing masks,
     then you need to implement layoutSubviews and calculate the subview positions and frames manually
     */
    resultView.contentMode = UIViewContentModeScaleAspectFit;
    resultView.bounds = [self scaleBounds:resultView.bounds aspectFitBounds:self.view.bounds];
    resultView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    [self.view addSubview:resultView];
}

- (CGRect)scaleBounds:(CGRect)rect aspectFitBounds:(CGRect)containerRect {
    CGFloat ratio = [self widthHeightRatio:containerRect];
    CGRect scaleBounds = CGRectZero;
    scaleBounds.size.width = containerRect.size.width;
    scaleBounds.size.height = scaleBounds.size.width / ratio;
    return CGRectIntegral(scaleBounds);
}

- (CGFloat)widthHeightRatio:(CGRect)bounds {
    return bounds.size.width / bounds.size.height;
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
