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
    [self setupResultView];

}

#pragma mark - Private

- (void)setupRootView {
    /**
     http://stackoverflow.com/questions/26644820/touches-on-transparent-uicontrol-are-ignored-not-handled-by-added-action-funct
     */
    self.view.backgroundColor = [UIColor blackColor];
}

#pragma mark - Private

- (void)setupResultView {
    /**
     - The content mode specifies how the cached bitmap of the view’s layer is adjusted when the view’s bounds change.
     - ######For an image view, this is talking about the image. For a view that draws its content, this is talking about the drawn content. ######
     It does not affect the layout of subviews.
     - You need to look at the autoresizing masks in place on the subviews. Content mode is a red herring here.
     If you can't achieve the layout you need using autoresizing masks,
     then you need to implement layoutSubviews and calculate the subview positions and frames manually
     */
    self.resultView.contentMode = UIViewContentModeScaleAspectFit;
    self.resultView.bounds = [self scaleBounds:self.resultView.bounds aspectFitBounds:self.view.bounds];
    self.resultView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    [self.view addSubview:self.resultView];
}

- (CGRect)scaleBounds:(CGRect)rect aspectFitBounds:(CGRect)containerRect {
    CGRect scaleBounds = CGRectZero;
    if (CGRectIsEmpty(rect)) {
        scaleBounds.size.width = containerRect.size.width;
        scaleBounds.size.height = scaleBounds.size.width;
    } else {
        CGFloat ratio = containerRect.size.width / rect.size.width;
        scaleBounds.size.width = containerRect.size.width;
        scaleBounds.size.height = rect.size.height * ratio;
    }
    return CGRectIntegral(scaleBounds);
}

- (CGFloat)widthHeightRatio:(CGRect)bounds {
    return bounds.size.width / bounds.size.height;
}

@end
