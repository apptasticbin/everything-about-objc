//
//  BasicObjectsExperiment.m
//  everything-about-objc
//
//  Created by Bin Yu on 21/02/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "BasicObjectsExperiment.h"


typedef struct {
    int dummyIvar;
} DummyStructure;

@interface DummyObject : NSObject

@property(nonatomic, assign) NSInteger dummyProperty;

@end

@implementation DummyObject

- (instancetype)init {
    self = [super init];
    if (self) {
        _dummyProperty = 10;
    }
    return self;
}

@end

@implementation BasicObjectsExperiment

#pragma mark - Experiment

+ (NSString *)displayName {
    return @"Basic Objects";
}

+ (NSString *)displayDesc {
    return @"Try out APIs of basic objects: NSValue, NSString, NSNumber, etc.";
}

#pragma mark - Experiment Cases

- (void)NSStringExperimentCase {
    NSString *normalString = @"0123456789";
    MLog(@"Created a string: \"%@\"", normalString);
    unichar numberThreeCharacter = [normalString characterAtIndex:3];
    MLog(@"The 3rd unicode character: '%C'", numberThreeCharacter);
    NSString *subString = [normalString substringFromIndex:3];
    MLog(@"Substring from index 3: %@", subString);
    subString = [normalString substringToIndex:3];
    MLog(@"Substring to index 3: %@", subString);
    NSRange range = NSMakeRange(2, 3);
    subString = [normalString substringWithRange:range];
    MLog(@"Substring from 2 to %lu: %@", (unsigned long)NSMaxRange(range), subString);
    
    NSString *firstString = @"abcdefg";
    NSString *secondString = @"Gfedcba";
    NSComparisonResult comparisonResult = [firstString compare:secondString];
    MLog(@"Compare '%@' and '%@' normally: %@", firstString, secondString, [self stringFromComparisonResult:comparisonResult]);
    comparisonResult = [firstString compare:secondString options:NSCaseInsensitiveSearch];
    MLog(@"Compare '%@' and '%@' with case-insensitive: %@", firstString, secondString, [self stringFromComparisonResult:comparisonResult]);
    comparisonResult = [firstString compare:secondString options:NSBackwardsSearch];
    MLog(@"Compare '%@' and '%@' with backwards-search: %@", firstString, secondString, [self stringFromComparisonResult:comparisonResult]);
    
    NSString *baseString = @"##abc efg abcd";
    NSString *searchString = @"abc";
    NSRange searchRange = [baseString rangeOfString:searchString];
    MLog(@"Found substring '%@' from %lu to %lu", searchString, searchRange.location, NSMaxRange(searchRange));
    searchRange = [baseString rangeOfString:searchString options:NSBackwardsSearch];
    MLog(@"Found substring '%@' from %lu to %lu", searchString, searchRange.location, NSMaxRange(searchRange));
    
    NSString *alphaNumberString = @"12.345a45.678b";
    MLog(@"Double value from string '%@': %f", alphaNumberString, alphaNumberString.doubleValue);
    MLog(@"Float value from string '%@': %f", alphaNumberString, alphaNumberString.floatValue);
    MLog(@"Int value from string '%@': %d", alphaNumberString, alphaNumberString.intValue);
    MLog(@"Integer value from string '%@': %ld", alphaNumberString, alphaNumberString.integerValue);
    MLog(@"Long Long value from string '%@': %lld", alphaNumberString, alphaNumberString.longLongValue);
    MLog(@"BOOL value from string '%@': %@", alphaNumberString, @(alphaNumberString.boolValue));
    
    NSArray *alphaNumberStringComponents = [alphaNumberString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
    MLog(@"Components of string '%@': %@", alphaNumberString, alphaNumberStringComponents);
    
    NSString *newBaseString = [baseString stringByAppendingString:@" eba##"];
    NSString *baseStringWithoutSymbol = [newBaseString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    MLog(@"String without #: %@", baseStringWithoutSymbol);
    NSString *paddingBaseString = [baseString stringByPaddingToLength:baseString.length+3 withString:@"." startingAtIndex:0];
    MLog(@"Padding string: %@", paddingBaseString);
    
    NSString *xyzBaseString = [baseString stringByReplacingOccurrencesOfString:@"abc" withString:@"xyz"];
    MLog(@"xyz string: %@", xyzBaseString);
    
    unichar characters[] = {'a', 'b', 'c', 'd', 'e'};
    NSString *characterSetString = [[NSString alloc] initWithCharacters:characters length:5];
    MLog(@"String initialized by characters: %@", characterSetString);
}

- (NSString *)stringFromComparisonResult:(NSComparisonResult)comparisonResult {
    switch (comparisonResult) {
        case NSOrderedAscending:
            return @"NSOrderedAscending";
        case NSOrderedSame:
            return @"NSOrderSame";
        case NSOrderedDescending:
            return @"NSOrderedDescending";
    }
}

- (void)NSNumberExperimentCase {
    NSNumber *charNumber = @('c');
    MLog(@"Character number: %@", charNumber);
    NSNumber *boolNumber = [NSNumber numberWithBool:[charNumber isEqualToNumber:@(99)]];
    MLog(@"Bool number: %@", boolNumber.boolValue ? @"YES" : @"NO");
}

- (void)NSValueExperimentCase {
    DummyStructure dummyStructure = { 5 };
    NSValue *dummyValue = [NSValue valueWithBytes:&dummyStructure objCType:@encode(DummyStructure)];
    DummyStructure recoveryStructure;
    [dummyValue getValue:&recoveryStructure];
    MLog(@"Recovered dummy value: %d", recoveryStructure.dummyIvar);
    
    /**
     + (NSValue *)valueWithCGPoint:(CGPoint)point;
     + (NSValue *)valueWithCGVector:(CGVector)vector;
     + (NSValue *)valueWithCGSize:(CGSize)size;
     + (NSValue *)valueWithCGRect:(CGRect)rect;
     + (NSValue *)valueWithCGAffineTransform:(CGAffineTransform)transform;
     + (NSValue *)valueWithUIEdgeInsets:(UIEdgeInsets)insets;
     + (NSValue *)valueWithUIOffset:(UIOffset)insets NS_AVAILABLE_IOS(5_0);
     */
    NSValue *dataValue = [NSValue valueWithCGPoint:CGPointMake(1.0f, 2.0f)];
    MLog(@"Point value: %@", dataValue);
    
    /** valueWithNonretainedObject: add object that not conform <NSCoding> protocol to collection
        NOTICE: this method DOES NOT retain object. You need to retain it yourself.
     */
    DummyObject *dummyObject = [DummyObject new];
    NSValue *nonRetainedValue = [NSValue valueWithNonretainedObject:dummyObject];
    MLog(@"Non-retained object value: %@", nonRetainedValue);
    NSArray *arrayWithNonretainedValue = @[nonRetainedValue];
    MLog(@"Array with non-retained object: %@", arrayWithNonretainedValue);
    dummyValue = [arrayWithNonretainedValue firstObject];
    DummyObject *recoveredDummyObject = dummyValue.nonretainedObjectValue;
    MLog(@"Recovered dummy object value from array: %ld", recoveredDummyObject.dummyProperty);
}

- (void)NSDataExperimentCase {
    
}

- (void)NSDateExperimentCase {
    
}

- (void)NSRangeExperimentCase {
    
}

@end
