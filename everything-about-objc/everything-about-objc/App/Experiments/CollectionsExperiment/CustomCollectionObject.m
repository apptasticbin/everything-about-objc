//
//  CustomCollectionObject.m
//  everything-about-objc
//
//  Created by Bin Yu on 27/02/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "CustomCollectionObject.h"

@implementation CustomCollectionObject

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    CustomCollectionObject *copyObject = [[CustomCollectionObject allocWithZone:zone] init];
    copyObject.value = _value;
    return copyObject;
}

+ (instancetype)objectWithValue:(NSInteger)value {
    return [[CustomCollectionObject alloc] initWithValue:value];
}

- (instancetype)initWithValue:(NSInteger)value {
    self = [super init];
    if (self) {
        _value = value;
    }
    return self;
}

/**
 NSArray calles 'isEqual' for checking object equality
 */
- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    }
    if (!object ||
        ![object isKindOfClass:CustomCollectionObject.class]) {
        return NO;
    }
    CustomCollectionObject *otherObject = object;
    if (self.value == otherObject.value) {
        return YES;
    }
    return NO;
}

- (NSUInteger)hash {
    return self.value;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%ld", self.value];
}

/**
 Custom Indexed Subscripting
 
 To add custom-indexed subscripting support to your class, simply declare and implement the following methods:
 
 - (id)objectAtIndexedSubscript:(*IndexType*)idx;
 - (void)setObject:(id)obj atIndexedSubscript:(*IndexType*)idx;
 
 *IndexType* can be any integral type, such as char, int, or NSUInteger, as used by NSArray.
 
 Custom Keyed Subscripting
 
 Similarly, custom-keyed subscripting can be added to your class by declaring and implementing these methods:
 
 - (id)objectForKeyedSubscript:(*KeyType*)key;
 - (void)setObject:(id)obj forKeyedSubscript:(*KeyType*)key;
 
 *KeyType* can be any Objective-C object pointer type.
 */

@end

