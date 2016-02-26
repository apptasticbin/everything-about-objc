//
//  CollectionsExperiment.m
//  everything-about-objc
//
//  Created by Bin Yu on 24/02/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "CollectionsExperiment.h"
#import "CustomCollectionObject.h"

@implementation CollectionsExperiment

#pragma mark - Experiment

+ (NSString *)displayName {
    return @"Collections";
}

+ (NSString *)displayDesc {
    return @"Try out collections: NSArray, NSDictionary, NSSet, etc";
}

#pragma mark - Experiment Cases

- (void)NSArrayExperimentCase {
    // NSArray initializations
    NSArray *numberArray = @[@(5), @(1), @(3), @(4), @(1)];
    MLog(@"Number array: %@", numberArray);
    NSArray *alphabetArray = [NSArray arrayWithObjects:@"abc", @"def", @"abc", nil];
    MLog(@"Alphabet array: %@", alphabetArray);
    NSNumber *cNumbers[] = { @(6), @(7), @(8) };
    NSUInteger count = sizeof(cNumbers)/sizeof(cNumbers[0]);
    NSArray *cNumberArray = [NSArray arrayWithObjects:cNumbers count:count];
    MLog(@"C number array: %@", cNumberArray);
    // NSArray operations
    NSArray *numberAlphaArray = [numberArray arrayByAddingObjectsFromArray:alphabetArray];
    MLog(@"Number alpha array: %@", numberAlphaArray);
    MLog(@"Joint array string: %@", [numberAlphaArray componentsJoinedByString:@"xxx"]);
    MLog(@"Array contains 'def': %@", [numberAlphaArray containsObject:@"def"] ? @"YES" : @"NO");
    /**
     - If the NSBinarySearchingInsertionIndex option is specified,
     returns the index at which you should insert obj in order to maintain a sorted array
     - The elements in the array must have already been sorted using the comparator cmp. 
     If the array is not sorted, the result is undefined
     */
    NSComparator sortComparator = ^NSComparisonResult(NSNumber *first, NSNumber *second) {
        return [first compare:second];
    };
    // 'nonnull' is keyword which notify compiler that the value returned by object/parameters will never be nil
    NSArray *sortedNumberArray = [numberArray sortedArrayUsingComparator:sortComparator];
    NSUInteger insertIndex = [sortedNumberArray indexOfObject:@(2)
                                               inSortedRange:NSMakeRange(0, [sortedNumberArray count])
                                                     options:NSBinarySearchingInsertionIndex | NSBinarySearchingLastEqual
                                             usingComparator:sortComparator];
    MLog(@"Index to insert 2: %lu", insertIndex);
    NSMutableArray *insertedNumberArray = [sortedNumberArray mutableCopy];
    [insertedNumberArray insertObject:@(2) atIndex:insertIndex];
    MLog(@"Inserted array: %@", insertedNumberArray);
    
    NSEnumerator *reverseEnumerator = [numberArray reverseObjectEnumerator];
    for (NSNumber *number in reverseEnumerator) {
        MLog(@"%@", number);
    }
    
    MLog(@"Sorted alphabet array: %@", [alphabetArray sortedArrayUsingSelector:@selector(compare:)]);
    
    [numberArray makeObjectsPerformSelector:@selector(description)];
    MLog(@"Objects in index set: %@",
         [numberArray objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 2)]]);
    // stop at first occurance
    MLog(@"Index of '1': %lu", [numberArray indexOfObjectPassingTest:^BOOL(NSNumber *number, NSUInteger idx, BOOL *stop) {
        return [number isEqualToNumber:@(1)];
    }]);
    
    // NSMutableArray
    NSMutableArray *mutableNumberArray = [numberArray mutableCopy];
    [mutableNumberArray addObjectsFromArray:@[@(6), @(999)]];
    [mutableNumberArray removeLastObject];
    MLog(@"Mutable Number Array: %@", mutableNumberArray);
    [mutableNumberArray exchangeObjectAtIndex:0 withObjectAtIndex:3];
    MLog(@"Exchanged Mutable Number Array: %@", mutableNumberArray);
    
    CustomCollectionObject *anObject = [CustomCollectionObject new];
    CustomCollectionObject *anotherObject = [CustomCollectionObject new];
    NSArray *customObjectArray = @[ anObject ];
    MLog(@"Another object index: %lu", [customObjectArray indexOfObject:anotherObject]);
    /**
     The lowest index whose corresponding array value is identical to anObject. 
     If none of the objects in the array is identical to anObject, returns NSNotFound.
     */
    MLog(@"Another object index identical: %lu", [customObjectArray indexOfObjectIdenticalTo:anotherObject]);
    
    @try {
        // numberArray[numberArray.count+2];
        [numberArray objectAtIndex:numberArray.count+2];
    }
    @catch (NSException *exception) {
        MLog(@"Catched NSRangeException: %@", exception);
    }
}

- (void)NSPointerArrayExperimentCase {
    /**
     The NSPointerArray class represents a mutable collection modeled after NSArray, 
     but can also hold nil values.
     */
    NSPointerArray *pointerArray = [NSPointerArray pointerArrayWithOptions:NSPointerFunctionsStrongMemory];
    [pointerArray addPointer:nil];
    [pointerArray addPointer:nil];
    [pointerArray addPointer:nil];
    MLog(@"Pointer array count: %lu", pointerArray.count);
    [pointerArray compact];
    MLog(@"Compacted pointer array count: %lu", pointerArray.count);
    
    /**
     When enumerating a pointer array with NSFastEnumeration using for...in, 
     the loop will yield any nil values present in the array
     */
    for (id pointer in pointerArray) {
        MLog(@"pointer: %@", pointer);
    }
}

- (void)NSDictionaryExperimentCase {
    // Custom key and NSCoding protocol, hash and equal
    NSDictionary *nameDictionary = [NSDictionary dictionaryWithObjects:@[@"Bin", @"Yu", @"Chinese"]
                                                               forKeys:@[@"FirstName", @"LastName", @"Nationality"]];
    for (id key in nameDictionary.keyEnumerator) {
        MLog(@"key: %@ value: %@", key, [nameDictionary objectForKey:key]);
    }
    // No exception for unknown key
    MLog(@"Value of unknown key 'abc': %@", [nameDictionary objectForKey:@"abc"]);
    MLog(@"Value of unknown key 'abc': %@", nameDictionary[@"abc"]);
    
    [nameDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        MLog(@"key: %@ value: %@", key, value);
    }];
    // NOTICE: Keys are sorted by values, not by keys
    NSArray *sortedNameKeys = [nameDictionary keysSortedByValueUsingSelector:@selector(compare:)];
    MLog(@"Sorted name keys: %@", sortedNameKeys);
    
    // Read info.plist
    NSString *infoPlistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSDictionary *infoPlistDict = [NSDictionary dictionaryWithContentsOfFile:infoPlistPath];
    MLog(@"Info plist dictionary: %@", infoPlistDict);
    
    // Of course, here is a handy way to get key value of Info.plist
    NSString *bundleVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    MLog(@"Bundle Version: %@", bundleVersion);
    
    // Remove key that doesn't exist
    NSMutableDictionary *mutableNameDictionary = [nameDictionary mutableCopy];
    // Does nothing if aKey does not exist.
    [mutableNameDictionary removeObjectForKey:@"abc"];
    // Use nil key will rise exception
    @try {
        [mutableNameDictionary removeObjectForKey: nil];
    }
    @catch (NSException *e) {
        MLog(@"Exception for removing nil key: %@", e);
    }
    
    /**
     For cumstom key, if 'isEqual' returns YES, then 'hash' must be same
     */
    NSMutableDictionary *customKeyDict = [NSMutableDictionary dictionary];
    [customKeyDict setObject:@"abc" forKey:[[CustomCollectionObject alloc] initWithValue:2]];
    
    CustomCollectionObject *customKeyObject = [[CustomCollectionObject alloc] initWithValue:2];
    MLog(@"Value of custom key: %@", [customKeyDict objectForKey:customKeyObject]);
    
    MLog(@"All key objects of %@: %@", nameDictionary, [[nameDictionary keyEnumerator] allObjects]);
    MLog(@"All value objects of %@: %@", nameDictionary, [[nameDictionary objectEnumerator] allObjects]);
    // Set key value to nil will remove the key from dictionary
    mutableNameDictionary[@"FirstName"] = nil;
    MLog(@"Set first name to nil: %@", mutableNameDictionary);
    MLog(@"New name dictionary keys: %@ key count: %lu", mutableNameDictionary.keyEnumerator.allObjects, mutableNameDictionary.count);
}

- (void)NSSetExperimentCase {
    // NSSet and NSMutableSet
    /**
     A hash table is a fundamental data structure in programming, 
     and it’s what enables NSSet & NSDictionary to have fast (O(1)) lookup of elements
     */
    CustomCollectionObject *object1 = [CustomCollectionObject objectWithValue:1];
    CustomCollectionObject *object2 = [CustomCollectionObject objectWithValue:99];
    CustomCollectionObject *object3 = [CustomCollectionObject objectWithValue:5];
    CustomCollectionObject *object4 = [CustomCollectionObject objectWithValue:99];
    NSArray *customObjectArray = @[object1, object2, object3, object4];
    NSSet *customObjectSet = [NSSet setWithArray:customObjectArray];
    MLog(@"Custom object set: %@", customObjectSet);
    MLog(@"Set contains 2: %@", [customObjectSet member:@(2)]);
    
    NSSet *anotherSet = [NSSet setWithObjects:object1, object4, nil];
    MLog(@"set %@ is subset of set %@: %@", anotherSet, customObjectSet,
         [anotherSet isSubsetOfSet:customObjectSet] ? @"YES" : @"NO");
    NSMutableSet *mutableSet = [customObjectSet mutableCopy];
    [mutableSet minusSet:anotherSet];
    MLog(@"Minus set: %@", mutableSet);
    MLog(@"All values of custom objects set: %@", [customObjectSet valueForKeyPath:@"value"]);
    [customObjectSet setValue:@(2) forKey:@"value"];
    MLog(@"Modified custom object set: %@", customObjectSet);
    
    // NSCountedSet inherits from NSMutableSet
    NSCountedSet *customCountedSet = [NSCountedSet setWithArray:customObjectArray];
    MLog(@"Counted set: %@ count: %lu", customCountedSet, customCountedSet.count);
    for (id object in customCountedSet) {
        MLog(@"object: %@ count: %lu", object, [customCountedSet countForObject:object]);
    }
}

- (void)NSMapTableExperimentCase {
    /**
     NSDictionary based up with NSMapTable
     NSMapTable doesn’t implement object subscripting
     */
    NSMapTable *customMapTable =
        [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsStrongMemory
                              valueOptions:NSPointerFunctionsWeakMemory];
    [customMapTable setObject:@"123" forKey:@"abc"];
    MLog(@"Custom map table: %@", customMapTable);
    [customMapTable setObject:@"456" forKey:@"abc"];
    MLog(@"Custom map table: %@", customMapTable);
    // nil will be ignored for setting value of key
    [customMapTable setObject:nil forKey:@"abc"];
    MLog(@"Custom map table: %@", customMapTable);
    [customMapTable removeObjectForKey:@"abc"];
    MLog(@"Custom map table: %@", customMapTable);
}

- (void)NSHashTableExperimentCase {
    CustomCollectionObject *object1 = [CustomCollectionObject objectWithValue:1];
    CustomCollectionObject *object2 = [CustomCollectionObject objectWithValue:99];
    CustomCollectionObject *object3 = [CustomCollectionObject objectWithValue:5];
    CustomCollectionObject *object4 = [CustomCollectionObject objectWithValue:99];
    /** 
     NSSet backed up with NSHashTable
     Hash table with 'NSPointerFunctionsStrongMemory' equals to NSSet
     */
    NSHashTable *customHashTable = [NSHashTable hashTableWithOptions:NSPointerFunctionsStrongMemory];
    [customHashTable addObject:object1];
    [customHashTable addObject:object2];
    [customHashTable addObject:object3];
    [customHashTable addObject:object4];
    MLog(@"Custom hash table: %@", customHashTable);
}

- (void)SwallowCopyAndDeepCopyExperimentCase {
    /**
     you can copy a set with the copyWithZone: method—or the mutableCopyWithZone: method—or an array with
     initWithArray:copyItems: method
     */
    NSArray *numberArray = [NSArray arrayWithObjects:@(1), @(2), @(3), nil];
    NSArray *shallowCopyNumberArray = [numberArray copyWithZone:nil];
    NSNumber *secondNumber = numberArray[1];
    MLog(@"Second number index in shallow copy number array: %lu", [shallowCopyNumberArray indexOfObjectIdenticalTo:secondNumber]);
    
    NSDictionary *numberDictionary = @{ @"abc" : @(1), @"efg" : @(2) };
    NSDictionary *shallowCopyNumberDict = [[NSDictionary alloc] initWithDictionary:numberDictionary copyItems:NO];
    MLog(@"Shallow copy number dict: %@", shallowCopyNumberDict);
    
    /**
     basic deep copy
     copyWithZone: produces a shallow copy. This kind of copy is only capable of producing a one-level-deep copy
     */
    NSArray *deepCopyNumberArray = [[NSArray alloc] initWithArray:numberArray copyItems:YES];
    // WARNING: looks like this doesn't do REAL deep copy, because the address is still the same !
    MLog(@"Second number index in deep copy number array: %lu", [deepCopyNumberArray indexOfObjectIdenticalTo:secondNumber]);
    
    // try deep copy, like copy array of arrays
    NSData* archivedNumberArrayData = [NSKeyedArchiver archivedDataWithRootObject:numberArray];
    deepCopyNumberArray = [NSKeyedUnarchiver unarchiveObjectWithData:archivedNumberArrayData];
    MLog(@"Deep-copied number array: %@", deepCopyNumberArray);
    MLog(@"Second number index in deep copy number array: %lu", [deepCopyNumberArray indexOfObjectIdenticalTo:secondNumber]);
}

@end
