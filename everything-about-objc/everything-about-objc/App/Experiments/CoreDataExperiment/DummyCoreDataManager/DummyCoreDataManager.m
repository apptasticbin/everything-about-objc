//
//  DummyCoreDataManager.m
//  everything-about-objc
//
//  Created by Bin Yu on 16/03/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "DummyCoreDataManager.h"
#import "MLog.h"
#import "DummyEntryMO.h"
#import "DummyFriendsInfo.h"
#import <CoreData/CoreData.h>

@interface DummyCoreDataManager ()

@property(nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(nonatomic, strong) NSManagedObjectModel *managedObjectModel;

@end

@implementation DummyCoreDataManager

#pragma mark - Public

- (DummyEntryMO *)createDummyEntry {
    return (DummyEntryMO *)[NSEntityDescription insertNewObjectForEntityForName:@"DummyEntry"
                                                         inManagedObjectContext:self.managedObjectContext];
}

- (DummyFriendsInfo *)createDummyFriendsInfo {
    return (DummyFriendsInfo *)[NSEntityDescription insertNewObjectForEntityForName:@"DummyFriendsInfo"
                                                             inManagedObjectContext:self.managedObjectContext];
}

- (NSArray *)loadContextObjectsWithEntityName:(NSString *)entityName {
    return [self loadContextObjectsWithEntityName:entityName withFilter:nil];
}

- (NSArray *)loadContextObjectsWithEntityName:(NSString *)entityName withFilter:(NSPredicate *)filterPredicate {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    if (filterPredicate) {
        [fetchRequest setPredicate:filterPredicate];
    }
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    /**
     If nil is returned, you have received an error from Core Data and need to respond to it.
     If the array exists, you receive possible results for the request even though the NSArray
     may be empty. An empty NSArray indicates that there were no records found
     */
    if (!fetchedObjects) {
        MLog(@"Error happened when fetching objects for entity: %@ error: %@", entityName, error.localizedDescription);
    }
    return fetchedObjects;
}

- (void)saveContext {
    NSError *error = nil;
    if ([self.managedObjectContext hasChanges] &&
        ![self.managedObjectContext save:&error]) {
        NSAssert(NO, @"Core data context saving failed: %@", error.localizedDescription);
    }
    MLog(@"Context saved");
}

- (void)clearContext {
    /**
     http://stackoverflow.com/questions/1077810/delete-reset-all-entries-in-core-data
     */
    NSURL *storeURL =
    [[self applicationDocumentDirectory] URLByAppendingPathComponent:@"DummyCoreDataManager.sqlite"];
    NSPersistentStore *persistentStore = [self.persistentStoreCoordinator persistentStoreForURL:storeURL];
    NSError *error = nil;
    [self.persistentStoreCoordinator removePersistentStore:persistentStore error:&error];
    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error];
    if (error) {
        MLog(@"Error happens during clear core data database: %@", error.localizedDescription);
    }
}

#pragma mark - Core Data Stack

/**
 - The Core Data stack is a collection of framework objects that are accessed as part of the
 initialization of Core Data and that mediate between the objects in your application and
 external data stores. The Core Data stack handles all of the interactions with the external
 data stores so that your application can focus on its business logic. The stack consists of
 - three primary objects:
 the managed object context (NSManagedObjectContext),
 the persistent store coordinator (NSPersistentStoreCoordinator),
 and the managed object model (NSManagedObjectModel)
 */

/**
 https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CoreData/InitializingtheCoreDataStack.html#//apple_ref/doc/uid/TP40001075-CH4-SW1
 Think of the managed object context as an intelligent scratch pad. When you fetch objects 
 from a persistent store, you bring temporary copies onto the scratch pad where they form an 
 object graph (or a collection of object graphs). You can then modify those objects however 
 you like. Unless you actually save those changes, however, the persistent store remains unaltered
 */
- (NSManagedObjectContext *)managedObjectContext {
    if (!_managedObjectContext) {
        _managedObjectContext =
        [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    }
    return _managedObjectContext;
}

/**
 - The NSPersistentStoreCoordinator sits in the middle of the Core Data stack. 
 The coordinator is responsible for realizing instances of entities that are defined
 inside of the model. It creates new instances of the entities in the model, 
 and it retrieves existing instances from a persistent store (NSPersistentStore). 
 - The persistent store can be on disk or in memory
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (!_persistentStoreCoordinator) {
        _persistentStoreCoordinator =
        [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        // add sqlite store file
        NSURL *storeURL =
        [[self applicationDocumentDirectory] URLByAppendingPathComponent:@"DummyCoreDataManager.sqlite"];
        NSError *error = nil;
        NSPersistentStore *store =
        [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                  configuration:nil
                                                            URL:storeURL
                                                        options:nil
                                                          error:&error];
        NSAssert(store, @"Error when initializing persistent store coordinator: %@", error.localizedDescription);
    }
    return _persistentStoreCoordinator;
}

/**
 - An NSManagedObjectModel object describes a schema—a collection of entities (data models)
 that you use in your application
 - The NSManagedObjectModel instance describes the data that is going to be accessed by 
 the Core Data stack. During the creation of the Core Data stack, the NSManagedObjectModel 
 (often referred to as the “mom”) is loaded into memory as the first step in the creation 
 of the stack.
 - The model contains one or more NSEntityDescription objects representing the entities in
 the schema. Each NSEntityDescription object has property description objects (instances of 
 subclasses of NSPropertyDescription) that represent the properties (or fields) of the entity
 in the schema.
 */
- (NSManagedObjectModel *)managedObjectModel {
    if (!_managedObjectModel) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DummyCoreDataManager" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    NSAssert(_managedObjectModel, @"Create MOM failed");
    return _managedObjectModel;
}

- (NSURL *)applicationDocumentDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}

@end
