//
//  CoreDataExperiment.m
//  everything-about-objc
//
//  Created by Bin Yu on 16/03/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "CoreDataExperiment.h"
#import "DummyCoreDataManager.h"
#import "DummyEntryMO.h"

@implementation CoreDataExperiment

+ (NSString *)displayName {
    return @"Core Data";
}

+ (NSString *)displayDesc {
    return @"Try out core data related technolegies.";
}

#pragma mark - Experiment Cases

/**
 - You can specify that an attribute is optional — that is, it is not required to have a value
 - Transient attributes are properties that you define as part of the model, but which are not saved to the persistent store as part of an entity instance’s data. (Used for Undo, for example)
 - NULL in a database is not the same as 0, and searches for 0 will not match columns with NULL. 
 Moreover, NULL in a database is not equivalent to an empty string or empty data blob
 - Fetched properties represent weak, one-way relationships
 */

/**
 - By default, though, the references between a managed object and its context are weak
 - You can change a context’s default behavior so that it does keep strong references to its
 managed objects by sending the managed object context a retainsRegisteredObjects message 
 (with the argument YES)
 - Core Data ensures that—in a given managed object context—an entry in a persistent store is 
 associated with only one managed object. The technique is known as uniquing
 */

- (void)BasicCoreDataExperimentCase {
    DummyCoreDataManager *coreDataManager = [DummyCoreDataManager new];
    DummyEntryMO *dummyEntry = [coreDataManager createDummyEntry];
    dummyEntry.dummyAttribute = @"Hello, Dummy Attribute";
    DummyEntryMO *filterOutEntry = [coreDataManager createDummyEntry];
    filterOutEntry.dummyAttribute = @"Filter me out";
    [coreDataManager saveContext];
    
    NSArray *fetchedDummyObjects = [coreDataManager loadContextObjectsWithEntityName:@"DummyEntry"];
    MLog(@"Fetched %lu dummy objects: %@", fetchedDummyObjects.count, fetchedDummyObjects);
    /**
     http://stackoverflow.com/questions/3543208/nsfetchrequest-and-predicatewithblock
     - SQLite stores being incompatible with block predicates, 
     since Core Data cannot translate these to SQL to run them in the store
     */
    NSPredicate *filter =
    [NSPredicate predicateWithFormat:@"dummyAttribute != %@", @"Filter me out"];
    NSArray *filteredDummyObjects = [coreDataManager loadContextObjectsWithEntityName:@"DummyEntry" withFilter:filter];
    MLog(@"Filtered fetched %lu dummy objects: %@", filteredDummyObjects.count, filteredDummyObjects);
    
    /**
     http://stackoverflow.com/questions/8963823/i-got-fault-when-i-fetched-my-data-from-nsmanagedobjectcontext
     - fetched objects contains "fault" objects, until you start accessing fetched objects' attributes
     - after you "really" accessing fetched objects, the "fault" objects will disappear
     */
    for (DummyEntryMO *dummyObject in fetchedDummyObjects) {
        MLog(@"dummy attribute: %@", dummyObject.dummyAttribute);
    }
    MLog(@"Fetched %lu dummy objects without fault objects: %@", fetchedDummyObjects.count, fetchedDummyObjects);
    
    [coreDataManager clearContext];
}

- (void)CoreDataRelationshipExperimentCase {
    DummyCoreDataManager *coreDataManager = [DummyCoreDataManager new];
    // create dummy entry managed objects
    DummyEntryMO *personOne = [coreDataManager createDummyEntry];
    DummyEntryMO *personTwo = [coreDataManager createDummyEntry];
    DummyEntryMO *personThree = [coreDataManager createDummyEntry];
    DummyEntryMO *personFour = [coreDataManager createDummyEntry];
    
    personOne.dummyAttribute = @"Person One";
    personTwo.dummyAttribute = @"Person Two";
    personThree.dummyAttribute = @"Person Three";
    personFour.dummyAttribute = @"Person Four";
    
    DummyEntryMO *mother = [coreDataManager createDummyEntry];
    DummyEntryMO *father = [coreDataManager createDummyEntry];
    
    mother.dummyAttribute = @"Mother";
    father.dummyAttribute = @"Father";
    
    [mother addChildren:[NSSet setWithObjects:personOne, personTwo, nil]];
    [father addChildren:[NSSet setWithObjects:personOne, personTwo, nil]];
    
    DummyFriendsInfo *friendsInfoOne = [coreDataManager createDummyFriendsInfo];
    DummyFriendsInfo *friendsInfoTwo = [coreDataManager createDummyFriendsInfo];
    DummyFriendsInfo *friendsInfoThree = [coreDataManager createDummyFriendsInfo];
    DummyFriendsInfo *friendsInfoFour = [coreDataManager createDummyFriendsInfo];
    
    friendsInfoOne.source = personOne;
    friendsInfoOne.friend = personThree;
    
    friendsInfoTwo.source = personOne;
    friendsInfoTwo.friend = personFour;
    
    friendsInfoThree.source = personTwo;
    friendsInfoThree.friend = personFour;
    
    friendsInfoFour.source = personThree;
    friendsInfoFour.friend = personOne;
    
    /**
     - valueForKeyPath will raise 'NSUnknownKeyException' if kay path is wrong.
     */
    MLog(@"PersenOne's parents: %@", [personOne valueForKeyPath:@"parents.dummyAttribute"]);
    MLog(@"PersonOne treats %@ as friends", [personOne valueForKeyPath:@"friends.friend.dummyAttribute"]);
    MLog(@"%@ treats PersonOne as friend", [personOne valueForKeyPath:@"beFriendedBy.source.dummyAttribute"]);
}

- (void)CoreDataWithUITableViewExperimentCase {
    /**
     https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CoreData/nsfetchedresultscontroller.html#//apple_ref/doc/uid/TP40001075-CH8-SW1
     */
}

- (void)CoreDataFaultingExperimentCase {
    /**
     https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CoreData/FaultingandUniquing.html#//apple_ref/doc/uid/TP40001075-CH18-SW1
     */
}

- (void)CoreDataManuallyModelGenerationExperimentCase {
    /**
     https://www.cocoanetics.com/2012/04/creating-a-coredata-model-in-code/
     */
}

@end
