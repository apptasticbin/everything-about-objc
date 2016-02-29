//
//  CustomDrawView.m
//  everything-about-objc
//
//  Created by Bin Yu on 29/02/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "CustomDrawView.h"
#import "MLog.h"

@implementation CustomDrawView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // default circle color
        _circleColor = [UIColor greenColor];
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    MLog(@"Custom Draw: %@", NSStringFromSelector(_cmd));
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGRect circleRect = CGRectInset(rect, 20, 20);
    CGContextAddEllipseInRect(contextRef, circleRect);
    
    CGContextSetFillColor(contextRef, CGColorGetComponents([self.circleColor CGColor]));
    CGContextSetStrokeColor(contextRef, CGColorGetComponents([[UIColor whiteColor] CGColor]));
    CGContextSetLineWidth(contextRef, 2.0);
    
    CGContextFillPath(contextRef);
}

/**
 https://developer.apple.com/library/ios/documentation/EventHandling/Conceptual/EventHandlingiPhoneOS/multitouch_background/multitouch_background.html
 For instances of your subclass to receive multitouch events:
 - Your subclass MUST implement the UIResponder methods for touch-event handling,
 described in Implementing the Touch-Event Handling Methods in Your Subclass.
 - The view receiving touches must have its userInteractionEnabled property set to YES. 
 If you are subclassing a view controller, the view that it manages must support user interactions.
 - The view receiving touches must be visible; it can’t be transparent or hidden.

 */

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    MLog(@"Custom draw view caunt touch event began");
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    MLog(@"Custom draw view caunt touch event moved");
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    MLog(@"Custom draw view caunt touch event ended");
    // redraw couldn't be triggered
    self.circleColor = [UIColor blueColor];
    // now redraw triggered; drawRect: will be triggered again
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    MLog(@"Custom draw view caunt touch event cancelled");
}

@end
