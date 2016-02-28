//
//  DummyView.m
//  everything-about-objc
//
//  Created by Bin Yu on 27/02/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "DummyView.h"
#import "MLog.h"

@implementation DummyView

+ (DummyView *)dummyViewHierarchy {
    DummyView *rootView = [DummyView dummyViewWithName:@"RootView" color:[UIColor whiteColor]];
    DummyView *redView = [DummyView dummyViewWithName:@"RedView" color:[UIColor redColor]];
    DummyView *blueView = [DummyView dummyViewWithName:@"BlueView" color:[UIColor blueColor]];
    DummyView *greenView = [DummyView dummyViewWithName:@"GreenView" color:[UIColor greenColor]];
    
    [rootView addSubview:redView];
    [rootView addSubview:blueView];
    [rootView addSubview:greenView];
    return rootView;
}

+ (instancetype)dummyViewWithName:(NSString *)name color:(UIColor *)color {
    return [[DummyView alloc] initWithName:name color:color];
}

- (instancetype)initWithName:(NSString *)name color:(UIColor *)color {
    self = [super init];
    if (self) {
        _name = name;
        self.backgroundColor = color;
    }
    return self;
}

- (UIView *)subviewNamed:(NSString *)name {
    for (DummyView *view in self.subviews) {
        if ([view.name isEqualToString:name]) {
            return view;
        }
    }
    return nil;
}

- (void)addSubviewAtCenter:(UIView *)subview {
    subview.center = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addSubview:subview];
}

#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    MLog(@"Layout subviews of dummy view: %@ frame: %@", self.name, NSStringFromCGRect(self.frame));
    CGFloat rootViewWidth = self.frame.size.width;
    CGFloat rootViewHeight = self.frame.size.height;
    for (DummyView *view in self.subviews) {
        if ([view.name isEqualToString:@"RedView"]) {
            view.frame = CGRectMake(rootViewWidth/4.0f, rootViewHeight/4.0f,
                                    rootViewWidth/4.0f, rootViewHeight/4.0f);
        }
        if ([view.name isEqualToString:@"BlueView"]) {
            view.frame = CGRectMake(rootViewWidth/3.0f, rootViewHeight/3.0f,
                                    rootViewWidth/3.0f, rootViewHeight/4.0f);
        }
        if ([view.name isEqualToString:@"GreenView"]) {
            view.frame = CGRectMake(rootViewWidth/3.0f, rootViewHeight*2.0f/3.0f,
                                    rootViewWidth/3.0f, rootViewHeight/4.0f);
        }
    }
}

- (void)drawRect:(CGRect)rect {
    
}

@end
