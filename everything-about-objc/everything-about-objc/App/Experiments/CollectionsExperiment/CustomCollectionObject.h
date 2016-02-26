//
//  CustomCollectionObject.h
//  everything-about-objc
//
//  Created by Bin Yu on 27/02/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 NSDictionary copies key, doesn't retain
 */
@interface CustomCollectionObject : NSObject<NSCopying>

@property(nonatomic, assign) NSInteger value;

+ (instancetype)objectWithValue:(NSInteger)value;
- (instancetype)initWithValue:(NSInteger)value;

@end
