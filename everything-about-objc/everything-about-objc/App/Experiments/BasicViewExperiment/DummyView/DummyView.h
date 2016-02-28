//
//  DummyView.h
//  everything-about-objc
//
//  Created by Bin Yu on 27/02/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DummyView : UIView

@property(nonatomic, strong) NSString *name;

+ (instancetype)dummyViewWithName:(NSString *)name color:(UIColor *)color;
- (instancetype)initWithName:(NSString *)name color:(UIColor *)color;

- (UIView *)subviewNamed:(NSString *)name;
- (void)addSubviewAtCenter:(UIView *)subview;
+ (DummyView *)dummyViewHierarchy;

@end
