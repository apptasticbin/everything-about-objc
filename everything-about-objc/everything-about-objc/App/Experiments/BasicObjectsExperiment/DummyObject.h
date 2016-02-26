//
//  DummyObject.h
//  everything-about-objc
//
//  Created by Bin Yu on 27/02/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
    int dummyIvar;
} DummyStructure;

@interface DummyObject : NSObject

@property(nonatomic, assign) NSInteger dummyProperty;

@end
