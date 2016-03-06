//
//  BasicObjectsExperiment.m
//  everything-about-objc
//
//  Created by Bin Yu on 21/02/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "BasicObjectsExperiment.h"
#import "DummyObject.h"

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
    /**
     An NSRange structure giving the location and length in the receiver of the first occurrence of aString. 
     Returns {NSNotFound, 0} if aString is not found or is empty (@"").
     */
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
    
    NSString *duplicatedString = @"AAABBBCCCDddEeeFffGggggg";
    // Character folding operations remove distinctions between characters
    NSString *foldString = [duplicatedString stringByFoldingWithOptions:NSCaseInsensitiveSearch locale:[NSLocale currentLocale]];
    MLog(@"Fold string: %@", foldString);
}

- (void) NSStringFormatExperimentCase {
    
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
    const char *dummyUtfString = [@"aBcDe" UTF8String];
    NSData *dummyData = [NSData dataWithBytes:dummyUtfString length:strlen(dummyUtfString)];
    unsigned char recoverUtfString[strlen(dummyUtfString)];
    [dummyData getBytes:recoverUtfString length:strlen(dummyUtfString)];
    MLog(@"Recovered utf string: %s", recoverUtfString);
    
    NSString *dummyString = [NSString stringWithUTF8String:dummyUtfString];
    dummyData = [dummyString dataUsingEncoding:NSASCIIStringEncoding];
    NSString *recoveredASKIIString = [[NSString alloc] initWithData:dummyData encoding:NSASCIIStringEncoding];
    MLog(@"ASCII dummy string: %@", recoveredASKIIString);
    
    NSString *urlString = @"http://www.umbitious.com/media/16172/hello_world_crop.jpg";
    NSData *helloWorldImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    UIImage *helloWorldImage = [UIImage imageWithData:helloWorldImageData];
    if (helloWorldImage) {
        MLog(@"Fetched image data from url: %@", urlString);
        [self showResultView:[[UIImageView alloc] initWithImage:helloWorldImage]];
    }
}

- (void)NSDateExperimentCase {
    NSDate *futureDate = [NSDate distantFuture];
    MLog(@"Future date: %@; Interval since now: %g", futureDate, futureDate.timeIntervalSinceNow);
    NSDate *passDate = [NSDate distantPast];
    MLog(@"Pass date: %@; Interval since now: %g", passDate, passDate.timeIntervalSinceNow);
    NSComparisonResult compareResult = [passDate compare:futureDate];
    MLog(@"%@ compare to %@: %@", passDate, futureDate, [self stringFromComparisonResult:compareResult]);
    
    NSDate *nowDate = [NSDate date];
    NSDate *laterDate = [NSDate dateWithTimeIntervalSinceNow:100];
    NSDate *earlierDate = [nowDate earlierDate:laterDate];
    MLog(@"Earlier date between %@ and %@: %@", nowDate, laterDate, earlierDate);
    
    NSDate *oneDayBefore = [NSDate dateWithTimeIntervalSinceNow:(-60*60*24)];
    MLog(@"One day before date: %@", oneDayBefore);
}

- (void)NSCalendarExperimentCase {
    /** NOTICE: NSDate objects encapsulate a single point in time, independent of any particular calendrical system or time zone
        UTC/GMT (Coordinated Universal Time)
     */
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    MLog(@"Calendar time zone: %@", calendar.timeZone);
    // converted from UTCN to local time zone
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:nowDate];
    MLog(@"Current local time: %ld:%ld", dateComponents.hour, dateComponents.minute);
    
    NSArray *monthSymbol = [calendar monthSymbols];
    MLog(@"Month symbel: %@", monthSymbol);
    
    NSDate *firstMomentDate = [calendar startOfDayForDate:nowDate];
    MLog(@"First moment date of %@: %@", nowDate, firstMomentDate);
    MLog(@"Is today in weekends: %@", [calendar isDateInWeekend:nowDate] ? @"YES" : @"NO");
}

- (void)NSFormaterExperimentCase {
    // NSDateFormatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = kCFDateFormatterMediumStyle;
    dateFormatter.timeStyle = kCFDateFormatterMediumStyle;
    dateFormatter.timeZone = [NSTimeZone systemTimeZone];
    
    NSString *nowDateString = [dateFormatter stringFromDate:[NSDate date]];
    MLog(@"Now date string from date formatter: %@", nowDateString);
    
    dateFormatter.dateFormat = @"yyyy'-'MM'-'dd HH':'mm':'ss";
    nowDateString = [dateFormatter stringFromDate:[NSDate date]];
    MLog(@"Customized now date string: %@", nowDateString);
    
    // NSDateComponentsFormatter
    NSDateComponentsFormatter *dateComponentsFormatter = [[NSDateComponentsFormatter alloc] init];
    dateComponentsFormatter.unitsStyle = NSDateComponentsFormatterUnitsStyleFull;
    NSDate *nowDate = [NSDate date];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents =
        [currentCalendar components:NSCalendarUnitYear | NSCalendarUnitDay |
                                    NSCalendarUnitHour | NSCalendarUnitMinute
                           fromDate:nowDate];
    nowDateString = [dateComponentsFormatter stringFromDateComponents:dateComponents];
    MLog(@"Now date string from date components formatter: %@", nowDateString);

    // NSNumberFormatter
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    NSNumber *number = @(12345.567);
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSString *formatNumberString = [numberFormatter stringFromNumber:number];
    MLog(@"Decimal style number string: %@", formatNumberString);
    numberFormatter.roundingMode = kCFNumberFormatterRoundFloor;
    formatNumberString = [numberFormatter stringFromNumber:number];
    MLog(@"Round floor number string: %@", formatNumberString);
    numberFormatter.positivePrefix = @"+++";
    formatNumberString = [numberFormatter stringFromNumber:number];
    MLog(@"Positive prefix number string: %@", formatNumberString);
    /**
     http://www.unicode.org/reports/tr35/tr35-31/tr35-numbers.html#Number_Format_Patterns
     */
    numberFormatter.positiveFormat = @"#,##0.0000#";
    formatNumberString = [numberFormatter stringFromNumber:number];
    MLog(@"Positive format number string: %@", formatNumberString);
    numberFormatter.positiveFormat = @"#####";
    formatNumberString = [numberFormatter stringFromNumber:number];
    MLog(@"No fraction number string: %@", formatNumberString);
    numberFormatter.numberStyle = NSNumberFormatterPercentStyle;
    numberFormatter.positiveFormat = nil;
    formatNumberString = [numberFormatter stringFromNumber:number];
    MLog(@"Percent number string: %@", formatNumberString);
    
    numberFormatter = [[NSNumberFormatter alloc] init];
    NSNumber *numberFromString = [numberFormatter numberFromString:@"12345.567"];
    MLog(@"Number from string: %@", numberFromString);
}

- (void)NSRangeExperimentCase {
    NSRange range = NSMakeRange(1, 5);
    MLog(@"3 is in range %@: %@", [NSValue valueWithRange:range], NSLocationInRange(3, range) ? @"YES" : @"NO");
    NSRange anotherRange = NSMakeRange(3, 5);
    MLog(@"Union %@ and %@: %@",
         [NSValue valueWithRange:range],
         [NSValue valueWithRange:anotherRange],
         [NSValue valueWithRange:NSUnionRange(range, anotherRange)]
         );
    MLog(@"Intersection %@ and %@: %@",
         NSStringFromRange(range),
         NSStringFromRange(anotherRange),
         NSStringFromRange(NSIntersectionRange(range, anotherRange))
         );
}

- (void)NSURLExperimentCase {
    NSString *baseUrlString = @"https://www.facebook.com";
    NSString *myPageUrlString = [baseUrlString stringByAppendingPathComponent:@"abc efg"];
    MLog(@"My page url string: %@", myPageUrlString);
    myPageUrlString = [myPageUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    MLog(@"Escaped my page url string: %@", myPageUrlString);
    MLog(@"Unescaped my page url string: %@", myPageUrlString.stringByRemovingPercentEncoding);
    NSURL *myPageUrl = [NSURL URLWithString:@"abc;x=yz?d=efg&h=ijk" relativeToURL:[NSURL URLWithString:baseUrlString]];
    MLog(@"My page base url: %@", [myPageUrl baseURL]);
    MLog(@"My page scheme: %@", [myPageUrl scheme]);
    MLog(@"My page base absolute url: %@", [myPageUrl absoluteURL]);
    MLog(@"My page base relative string: %@", [myPageUrl relativeString]);
    MLog(@"My page base relative path: %@", [myPageUrl relativePath]);
    MLog(@"My page parameterString: %@", [myPageUrl parameterString]);
    MLog(@"My page query: %@", [myPageUrl query]);
    MLog(@"URL query allowing character set: %@", [NSCharacterSet URLQueryAllowedCharacterSet]);
    
}

- (void)ObjectInheritanceOrderExperimentCase {
    // Object Allocation, Initialisation, Inheritance order
    MLog(@"Order of initializing derived object");
    DummyObject *dummyObject = [DummyObject new];
    MLog(@"Call parent methods");
    [dummyObject commonMethod];
    [dummyObject dummyParentMethod];
    [dummyObject dummyGrandParentMethod];
}

- (void)SingletonExperimentCase {
    DummyObject *dummySingleton = [DummyObject sharedObject];
    MLog(@"Dummy singleton value: %ld", dummySingleton.dummyProperty);
    DummyObject *anotherDummySingleton = [DummyObject sharedObject];
    anotherDummySingleton.dummyProperty = 99;
    MLog(@"Dummy singleton value: %ld", dummySingleton.dummyProperty);
}

#pragma mark - Helper

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

@end
