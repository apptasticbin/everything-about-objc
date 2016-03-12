//
//  DummyAutoLayoutView.m
//  everything-about-objc
//
//  Created by Bin Yu on 10/03/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "DummyAutoLayoutView.h"
#import "MLog.h"

@interface DummyAutoLayoutView ()

@property(nonatomic, strong) NSLayoutConstraint *imageLabelBottomConstraint;

@end

@implementation DummyAutoLayoutView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    _imageView = [UIImageView new];
    _imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://wallpapercraze.com/images/wallpapers/purplehueofbeauty-648372.jpeg"]]];
    _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_imageView];
    
    _dummyView = [UIView new];
    _dummyView.backgroundColor = [UIColor redColor];
    _dummyView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.dummyView];
    
    _imageLabel = [UILabel new];
    _imageLabel.text = @"Click button to hide image";
    _imageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_imageLabel];
    
    _hideImageButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_hideImageButton setTitle:@"Hide" forState:UIControlStateNormal];
    [_hideImageButton addTarget:self action:@selector(hideImage:) forControlEvents:UIControlEventTouchUpInside];
    _hideImageButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_hideImageButton];
}

- (void)setupConstraints {
    NSLayoutConstraint *imageViewTopConstraint =
    [NSLayoutConstraint constraintWithItem:self.imageView
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeTop
                                multiplier:1.0f
                                  constant:20.0f];
    NSLayoutConstraint *imageViewLeadingConstraint =
    [NSLayoutConstraint constraintWithItem:self.imageView
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeLeading
                                multiplier:1.0f
                                  constant:20.0f];
    NSLayoutConstraint *imageViewTrailingConstraint =
    [NSLayoutConstraint constraintWithItem:self.imageView
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1.0f
                                  constant:-20.0f];
    NSLayoutConstraint *imageViewHeightConstraint =
    [NSLayoutConstraint constraintWithItem:self.imageView
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1.0f
                                  constant:100.0f];
    [self.imageView addConstraint:imageViewHeightConstraint];
    [self addConstraints:@[imageViewTopConstraint, imageViewLeadingConstraint,
                           imageViewTrailingConstraint]];
    
    NSLayoutConstraint *dummyViewTopConstraint =
    [NSLayoutConstraint constraintWithItem:self.dummyView
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.imageView
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0f
                                  constant:20.0f];
    NSLayoutConstraint *dummyViewLeadingConstraint =
    [NSLayoutConstraint constraintWithItem:self.dummyView
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeLeading
                                multiplier:1.0f
                                  constant:20.0f];
    NSLayoutConstraint *dummyViewTrailingConstraint =
    [NSLayoutConstraint constraintWithItem:self.dummyView
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1.0f
                                  constant:-20.0f];
    NSLayoutConstraint *dummyViewBottomConstraint =
    [NSLayoutConstraint constraintWithItem:self.dummyView
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.imageLabel
                                 attribute:NSLayoutAttributeTop
                                multiplier:1.0f
                                  constant:-20.0f];
    [self addConstraints:@[dummyViewTopConstraint, dummyViewLeadingConstraint,
                           dummyViewTrailingConstraint, dummyViewBottomConstraint]];
    
    NSLayoutConstraint *imageLabelCenterXConstraint =
    [NSLayoutConstraint constraintWithItem:self.imageLabel
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1.0f
                                  constant:0.0f];
    
    self.imageLabelBottomConstraint =
    [NSLayoutConstraint constraintWithItem:self.imageLabel
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.hideImageButton
                                 attribute:NSLayoutAttributeTop
                                multiplier:1.0f
                                  constant:-20.0f];
    NSLayoutConstraint *imageLabelHeightConstraint =
    [NSLayoutConstraint constraintWithItem:self.imageLabel
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1.0f
                                  constant:30.0f];
    [self.imageLabel addConstraint:imageLabelHeightConstraint];
    [self addConstraints:@[imageLabelCenterXConstraint, self.imageLabelBottomConstraint]];
    
    NSLayoutConstraint *hideImageButtonCenterXConstraint =
    [NSLayoutConstraint constraintWithItem:self.hideImageButton
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1.0f
                                  constant:0.0f];
    
    NSLayoutConstraint *hideImageButtonBottomConstraint =
    [NSLayoutConstraint constraintWithItem:self.hideImageButton
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0f
                                  constant:-20.0f];
    NSLayoutConstraint *hideImageHeightConstraint =
    [NSLayoutConstraint constraintWithItem:self.hideImageButton
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1.0f
                                  constant:30.0f];
    [self.hideImageButton addConstraint:hideImageHeightConstraint];
    [self addConstraints:@[hideImageButtonCenterXConstraint, hideImageButtonBottomConstraint]];
}

#pragma mark - UIView layout flow

/**
 Regarding your questions, the layout process generally works like this:
 
 - First step: updating constraints, happens bottom-up. 
 Triggered by calling [view setNeedsUpdateConstraints], 
 override [view updateConstraints] for custom views. 
 This step solves constraints.
 
 - Second step: Layout, happens top-down. 
 Triggered by calling [view setNeedsLayout], 
 [view layoutIfNeeded], override [view layoutSubviews] for custom views. 
 When layoutSubviews get called, we have frames.
 
 - Third step: display, happens top-down.
 Triggered by calling [view setNeedsDisplay], 
 override [view drawRect:] for custom views.
 */

- (void)layoutSubviews {
    MARK;
    [super layoutSubviews];
}

- (void)updateConstraints {
    MARK;
    /**
     - updateConstraints will not be called if you don't setup constraints
     */
    [super updateConstraints];
}

- (void)drawRect:(CGRect)rect {
    MARK;
    [super drawRect:rect];
}

#pragma mark - Helper

- (void)hideImage:(UIButton *)sender {
    MARK;
    [self.imageView removeFromSuperview];
    self.imageView = nil;
    
    // add new constraint after image view got removed
    NSLayoutConstraint *dummyViewTopConstraint =
    [NSLayoutConstraint constraintWithItem:self.dummyView
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeTop
                                multiplier:1.0f
                                  constant:20.0f];
    [self addConstraint:dummyViewTopConstraint];
    
    [UIView animateWithDuration:1.0 animations:^{
        [self layoutIfNeeded];
    }];
}

@end
