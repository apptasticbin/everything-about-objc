//
//  KeyValueCodingObservingExperiment.m
//  everything-about-objc
//
//  Created by Bin Yu on 14/03/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "KeyValueCodingObservingExperiment.h"
#import "DummyKeyValueObject.h"
#import "MLog.h"

@implementation KeyValueCodingObservingExperiment

+ (NSString *)displayName {
    return @"KVC and KVO";
}

+ (NSString *)displayDesc {
    return @"Try out key-value coding and key-value observing.";
}

#pragma mark - Experiment Case

- (void)KeyValueCodingFundamentalExperimentCase  {
    /**
     https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/KeyValueCoding/Articles/Overview.html
     
     - Key-value coding is a mechanism for accessing an object’s properties indirectly, 
     using strings to identify properties, rather than through invocation of an accessor 
     method or accessing them directly through instance variables. In essence, key-value 
     coding defines the patterns and method signatures that your application’s accessor 
     methods implement.
     - The essential methods for key-value coding are declared in the NSKeyValueCoding Objective-C 
     informal protocol and default implementations are provided by NSObject.
     - @interface NSObject(NSKeyValueCoding) ... @end category
     - scripting support: NSScriptKeyValueCoding
     - Key-value coding provides support for scalar values and data structures by 
     automatically wrapping and unwrapping NSNumber and NSValue instance values
     */
    DummyKeyValueObject *dummyObject = [DummyKeyValueObject new];
    /**
     - The default implementation of setValue:forKey: automatically unwraps NSValue
     objects that represent scalars and structs and assigns them to the property
     - If the specified key does not exist, the receiver is sent a setValue:forUndefinedKey: message.
     The default implementation of setValue:forUndefinedKey: raises an NSUndefinedKeyException; 
     however, subclasses can override this method to handle the request in a custom manner.
     */
    [dummyObject setValue:@"123.456" forKey:@"dummyStringProperty"];
    MLog(@"Dummy object string property double value: %.2f", [[dummyObject valueForKey:@"dummyStringProperty"] doubleValue]);
    /**
     By default, wrong property name will raise exception,
     unless you override -(id)valueForUndefinedKey
     */
    [dummyObject valueForKey:@"wrongProperty"];
    
    MLog(@"Dummy string length: %lu", [[dummyObject valueForKeyPath:@"dummyStringProperty.length"] unsignedIntegerValue]);
    
    /**
     https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/KeyValueCoding/Articles/DataTypes.html
     - The default implementations of valueForKey: and setValue:forKey: provide support
     for automatic object wrapping of the non-object data types, both scalars and structs
     - wrapped and unwrapped values will be used by accessor methods.
     - NSNumber, NSColor, or NSValue(CGRect, CGPoint, and other structure types)
     */
    [dummyObject setValue:@(99) forKey:@"dummyIntegerProperty"];
    NSDictionary *keyValueDictionary = [dummyObject dictionaryWithValuesForKeys:@[@"dummyStringProperty", @"dummyIntegerProperty"]];
    MLog(@"Kay-value dictionary: %@", keyValueDictionary);
    
    [dummyObject setValue:nil forKey:@"dummyBooleanProperty"];
    MLog(@"nil value for dummy integer: %@", dummyObject.dummyBooleanProperty ? @"YES" : @"NO");
    
    /**
     - Although your application can implement accessor methods for to-many relationship properties
     using the -<key> and -set<Key>: accessor forms, you should typically only use those to create 
     the collection object. For manipulating the contents of the collection it is best practice to 
     implement the additional accessor methods referred to as the collection accessor methods. 
     You then use the collection accessor methods, or a ### Mutable Collection Proxy ### returned by
     mutableArrayValueForKey: or mutableSetValueForKey:
     - Mutable collection proxy for KVO
     */
    
    /**
     Collection Operators
     - Collection operators allow actions to be performed on the items of a collection using 
     key path notation and an action operator
     */
    [dummyObject setValue:@[@"123", @"4567w", @"7891122", @"123"] forKey:@"dummyArray"];
    // Simple Collection Operators
    MLog(@"Count of dummy array: %@", [dummyObject valueForKeyPath:@"dummyArray.@count"]);
    MLog(@"Average length of strings in dummy array: %@", [dummyObject valueForKeyPath:@"dummyArray.@avg.length"]);
    MLog(@"Max length of strings in dummy array: %@", [dummyObject valueForKeyPath:@"dummyArray.@max.length"]);
    MLog(@"Sum of length of strings in dummy array: %@", [dummyObject valueForKeyPath:@"dummyArray.@sum.length"]);
    // Object Operators
    MLog(@"Unique item dummy array: %@", [dummyObject valueForKeyPath:@"dummyArray.@distinctUnionOfObjects.length"]);
    
    // NSClassDescription and NSScriptClassDescription
    
    /**
     Customized scripting
     */
}

@end
