//
//  DummyCoreDataManager.h
//  everything-about-objc
//
//  Created by Bin Yu on 16/03/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DummyEntryMO;
@class DummyFriendsInfo;

@interface DummyCoreDataManager : NSObject

- (DummyEntryMO *)createDummyEntry;
- (DummyFriendsInfo *)createDummyFriendsInfo;
- (NSArray *)loadContextObjectsWithEntityName:(NSString *)entityName;
- (NSArray *)loadContextObjectsWithEntityName:(NSString *)entityName withFilter:(NSPredicate *)filterPredicate;
- (void)saveContext;
- (void)clearContext;

@end
