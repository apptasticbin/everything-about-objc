//
//  ViewGeometricViewController.m
//  everything-about-objc
//
//  Created by Bin Yu on 27/02/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "ViewGeometricViewController.h"
#import "MLog.h"

typedef NS_ENUM(NSUInteger, SliderTag) {
    FrameXSlider = 100,
    FrameYSlider,
    FrameWidthSlider,
    FrameHeightSlider,
    BoundsXSlider,
    BoundsYSlider,
    BoundsWidthSlider,
    BoundsHeightSlider,
    CenterXSlider,
    CenterYSlider,
    RotationSlider
};

@interface ViewGeometricViewController ()

@end

/**
 http://stackoverflow.com/questions/1210047/cocoa-whats-the-difference-between-the-frame-and-the-bounds/28917673#28917673
 Bounds.origin indicates the point that you "draw" the view,
 so all subviews frames will originate at this point
 */
/**
 To conclude:
 
 view.bounds determines all its subview's location(offset by bounds.origin), while bounds will not affect its own location in its superview.
 
 If you init a view with negative width and height, it will automatically changed to positive(which won't change the location), but its bounds.origin indicates the point that you start to "draw" the view.
 */

@implementation ViewGeometricViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadImageView];
    [self updateSliders];
    [self updateLabels];
}

- (IBAction)sliderValueChanged:(id)sender {
    UISlider *slider = sender;
    CGFloat value = slider.value;
    switch (slider.tag) {
        case FrameXSlider: {
            CGRect frame = self.imageView.frame;
            frame.origin.x = value;
            self.imageView.frame = frame;
            break;
        }
        case FrameYSlider: {
            CGRect frame = self.imageView.frame;
            frame.origin.y = value;
            self.imageView.frame = frame;
            break;
        }
        case FrameWidthSlider: {
            CGRect frame = self.imageView.frame;
            frame.size.width = value;
            self.imageView.frame = frame;
            break;
        }
        case FrameHeightSlider: {
            CGRect frame = self.imageView.frame;
            frame.size.height = value;
            self.imageView.frame = frame;
            break;
        }
        case BoundsXSlider: {
            CGRect bounds = self.imageView.bounds;
            bounds.origin.x = value;
            self.imageView.bounds = bounds;
            break;
        }
        case BoundsYSlider: {
            CGRect bounds = self.imageView.bounds;
            bounds.origin.y = value;
            self.imageView.bounds = bounds;
            break;
        }
        case BoundsWidthSlider: {
            CGRect bounds = self.imageView.bounds;
            bounds.size.width = value;
            self.imageView.bounds = bounds;
            break;
        }
        case BoundsHeightSlider: {
            CGRect bounds = self.imageView.bounds;
            bounds.size.height = value;
            self.imageView.bounds = bounds;
            break;
        }
        case CenterXSlider: {
            CGPoint center = self.imageView.center;
            center.x = value;
            self.imageView.center = center;
            break;
        }
        case CenterYSlider: {
            CGPoint center = self.imageView.center;
            center.y = value;
            self.imageView.center = center;
            break;
        }
        case RotationSlider: {
            CGAffineTransform rotationTranform = CGAffineTransformMakeRotation(value);
            self.imageView.transform = rotationTranform;
            break;
        }
        default:
            break;
    }
    [self updateLabels];
}

#pragma mark - Private

- (void)loadImageView {
    NSURL *imageUrl =
        [NSURL URLWithString:@"http://i.dailymail.co.uk/i/pix/2015/07/31/09/2AFBF3E800000578-3180983-image-a-1_1438329950442.jpg"];
    NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
//    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.zPosition = -999;
    self.imageView.translatesAutoresizingMaskIntoConstraints = YES;
    self.imageView.image = [UIImage imageWithData:imageData];
    
    UIView *dummySubview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    dummySubview.backgroundColor = [UIColor redColor];
    [self.imageView addSubview:dummySubview];
}

- (void)updateSliders {
    [self setSliderTaged:FrameXSlider withValue:self.imageView.frame.origin.x];
    [self setSliderTaged:FrameYSlider withValue:self.imageView.frame.origin.y];
    [self setSliderTaged:FrameWidthSlider withValue:self.imageView.frame.size.width];
    [self setSliderTaged:FrameHeightSlider withValue:self.imageView.frame.size.height];
    [self setSliderTaged:BoundsXSlider withValue:self.imageView.bounds.origin.x];
    [self setSliderTaged:BoundsYSlider withValue:self.imageView.bounds.origin.y];
    [self setSliderTaged:BoundsWidthSlider withValue:self.imageView.bounds.size.width];
    [self setSliderTaged:BoundsHeightSlider withValue:self.imageView.bounds.size.height];
    [self setSliderTaged:CenterXSlider withValue:self.imageView.center.x];
    [self setSliderTaged:CenterYSlider withValue:self.imageView.center.y];
    [self setSliderTaged:RotationSlider
               withValue:[(NSNumber *)[self.imageView valueForKeyPath:@"layer.transform.rotation.z"] floatValue]];
}

- (void)updateLabels {
    self.frameXLabel.text = [NSString stringWithFormat:@"frame.x = %.1f", self.imageView.frame.origin.x];
    self.frameYLabel.text = [NSString stringWithFormat:@"frame.y = %.1f", self.imageView.frame.origin.y];
    self.frameWidthLabel.text = [NSString stringWithFormat:@"frame.w = %.1f", self.imageView.frame.size.width];
    self.frameHeightLabel.text = [NSString stringWithFormat:@"frame.h = %.1f", self.imageView.frame.size.height];
    self.boundsXLabel.text = [NSString stringWithFormat:@"bounds.x = %.1f", self.imageView.bounds.origin.x];
    self.boundsYLabel.text = [NSString stringWithFormat:@"bounds.y = %.1f", self.imageView.bounds.origin.y];
    self.boundsWidthLabel.text = [NSString stringWithFormat:@"bounds.w = %.1f", self.imageView.bounds.size.width];
    self.boundsHeightLabel.text = [NSString stringWithFormat:@"bounds.h = %.1f", self.imageView.bounds.size.height];
    self.centerXLabel.text = [NSString stringWithFormat:@"center.x = %.1f", self.imageView.center.x];
    self.centerYLabel.text = [NSString stringWithFormat:@"center.y = %.1f", self.imageView.center.y];
    self.rotationLabel.text = [NSString stringWithFormat:@"rotation = %f",
                               [(NSNumber *)[self.imageView valueForKeyPath:@"layer.transform.rotation.z"] floatValue]];
}

- (void)setSliderTaged:(NSUInteger)tag withValue:(CGFloat)value {
    UISlider *slider = [self.view viewWithTag:tag];
    if (tag == RotationSlider) {
        slider.minimumValue = -1.0f;
        slider.maximumValue = 1.0f;
    } else {
        slider.minimumValue = -500.0f;
        slider.maximumValue = 500.0f;
    }
    slider.value = value;
}

@end
