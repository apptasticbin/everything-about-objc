//
//  DummyFriendsInfo+CoreDataProperties.h
//  everything-about-objc
//
//  Created by Bin Yu on 19/03/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DummyFriendsInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface DummyFriendsInfo (CoreDataProperties)

@property (nullable, nonatomic, retain) NSManagedObject *friend;
@property (nullable, nonatomic, retain) NSManagedObject *source;

@end

NS_ASSUME_NONNULL_END
