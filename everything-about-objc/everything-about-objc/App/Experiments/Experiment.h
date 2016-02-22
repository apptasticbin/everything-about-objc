//
//  ExperimentCase.h
//  everything-about-objc
//
//  Created by Bin Yu on 21/02/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Experiment <NSObject>

@required
+ (NSString *)displayName;
+ (NSString *)displayDesc;

@end
