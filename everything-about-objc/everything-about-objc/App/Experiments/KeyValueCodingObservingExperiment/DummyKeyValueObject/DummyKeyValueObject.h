//
//  DummyKeyValueObject.h
//  everything-about-objc
//
//  Created by Bin Yu on 14/03/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DummyKeyValueObject : NSObject

/**
 An attribute is a property that is a simple value, such as a scalar, string, or Boolean value. 
 Value objects such as NSNumber and other immutable types such as as NSColor are also considered attributes
 */
@property(nonatomic, strong) NSString *dummyStringProperty;
@property(nonatomic, assign) NSInteger dummyIntegerProperty;
@property(nonatomic, assign) BOOL dummyBooleanProperty;
@property(nonatomic, strong) NSMutableArray *dummyArray;

@end
