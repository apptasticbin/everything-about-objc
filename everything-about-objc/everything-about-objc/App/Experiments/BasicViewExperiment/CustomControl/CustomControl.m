//
//  CustomControl.m
//  everything-about-objc
//
//  Created by Bin Yu on 29/02/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "CustomControl.h"
#import "MLog.h"

static inline float AngleFromNorth(CGPoint p1, CGPoint p2, BOOL flipped) {
    CGPoint v = CGPointMake(p2.x-p1.x,p2.y-p1.y);
    float vmag = sqrt(v.x*v.x + v.y*v.y), result = 0;
    v.x /= vmag;
    v.y /= vmag;
    double radians = atan2(v.y,v.x);
    result = radians;
    return (result >=0  ? result : result + 2*M_PI);
}

@interface CustomControl ()

@property(nonatomic, readwrite, assign) CGFloat endAngle;

@end

@implementation CustomControl

- (instancetype)init {
    self = [super init];
    if (self) {
        _endAngle = M_PI/2;
        self.backgroundColor = [UIColor greenColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGRect insetRect = CGRectInset(rect, 20.0f, 20.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    // math.h
    CGContextAddArc(context, rect.size.width/2, rect.size.height/2,
                    insetRect.size.width/2, 0, self.endAngle, 0);
    CGContextSetStrokeColorWithColor(context, [[UIColor redColor] CGColor]);
    CGContextSetLineWidth(context, 10);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextDrawPath(context, kCGPathStroke);
}

#pragma mark - UIControl override

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super beginTrackingWithTouch:touch withEvent:event];
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchPoint = [touch locationInView:self];
    CGPoint centerPoint = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
    float currentAngle = AngleFromNorth(centerPoint, touchPoint, NO);
    self.endAngle = 2*M_PI_2 - currentAngle;
    // need redraw view rect
    [self setNeedsDisplay];
    // send value changed event
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
}

@end
