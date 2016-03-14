//
//  DummyKeyValueObject.m
//  everything-about-objc
//
//  Created by Bin Yu on 14/03/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "DummyKeyValueObject.h"
#import "MLog.h"

@implementation DummyKeyValueObject

@synthesize dummyStringProperty = _dummyStringProperty;

- (NSString *)dummyStringProperty {
    MARK;
    return _dummyStringProperty;
}

- (void)setDummyStringProperty:(NSString *)dummyStringProperty {
    MARK;
    _dummyStringProperty = dummyStringProperty;
}

/**
 Otherwise (no simple accessor method, set of collection access methods, or instance variable is found), 
 invokes -valueForUndefinedKey: and returns the result. The default implementation of -valueForUndefinedKey: 
 raises an NSUndefinedKeyException, but you can override it in your application
 */

- (id)valueForUndefinedKey:(NSString *)key {
    MARK;
    if ([key isEqualToString:@"wrongProperty"]) {
        MLog(@"Oops, it's a wrong property");
        return [NSNull null];
    }
    return [super valueForUndefinedKey:key];
}
/**
 - if the attribute is a non-object type, you must also implement a suitable means of
 representing a nil value. The key-value coding method setNilValueForKey: method is 
 called when you attempt to set an attribute to nil. This provides the opportunity to 
 provide appropriate default values for your application, or handle keys that don’t 
 have corresponding accessors in the class
 - MUST use "setValue:forKey:"
 */
- (void)setNilValueForKey:(NSString *)key {
    MARK;
    if ([key isEqualToString:@"dummyBooleanProperty"]) {
        [self setValue:@"YES" forKey:key];
    } else {
        [super setNilValueForKey:key];
    }
}

/**
 https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/KeyValueCoding/Articles/AccessorConventions.html
 
 Ensuring KVC Compliance
 https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/KeyValueCoding/Articles/Compliant.html
 
 Indexed Accessor Pattern
 - The indexed accessor methods define a mechanism for counting, retrieving, 
 adding, and replacing objects in an ordered relationship. Typically this 
 relationship is an instance of NSArray or NSMutableArray; however, any object 
 can implement these methods and be manipulated just as if it was an array
 - There are indexed accessors which return data from the collection (the getter variation) 
 and mutable accessors that provide an interface for mutableArrayValueForKey: 
 to modify the collection
 */

- (NSUInteger)countOfDummyArray {
    MARK;
    return [self.dummyArray count];
}

- (id)objectInDummyArrayAtIndex:(NSUInteger)index {
    MARK;
    return self.dummyArray[index];
}

- (NSArray *)dummyArrayAtIndexes:(NSIndexSet *)indexes {
    return [self.dummyArray objectsAtIndexes:indexes];
}

- (void)getDummyArray:(NSString **)buffer range:(NSRange)inRange {
    MARK;
    /**
     this is optional
     */
}

/**
 Mutable Indexed Accessors
 - Supporting a mutable to-many relationship with indexed accessors requires 
 implementing additional methods. Implementing the mutable indexed accessors 
 allow your application to interact with the indexed collection in an easy and 
 efficient manner by using the array proxy returned by mutableArrayValueForKey:. 
 In addition, by implementing these methods for a to-many relationship your 
 class will be key-value observing compliant for that property
 */

- (void)insertObject:(NSString *)object inDummyArrayAtIndex:(NSUInteger)index {
    MARK;
    [self.dummyArray insertObject:object atIndex:index];
}

- (void)removeObjectFromDummyArrayAtIndex:(NSUInteger)index {
    MARK;
    [self.dummyArray removeObjectAtIndex:index];
}

- (void)replaceObjectInDummyArrayAtIndex:(NSUInteger)index withObject:(id)object {
    MARK;
    [self.dummyArray replaceObjectAtIndex:index withObject:object];
}

/**
 Object scripting:
 http://nshipster.com/object-subscripting/
 - Seems that this is ONLY for customizing collection types.
 */

/**
 - (id)objectAtIndexedSubscript:(NSUInteger)idx {
 return self.dummyArray[idx];
 }
 
 - (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx {
 self.dummyArray[idx] = obj;
 }
 - (id)objectForKeyedSubscript:(NSString *)key {
 
 }
 - (void)setObject:(id)obj forKeyedSubscript:(NSString *)key {
 
 }
 */

@end
