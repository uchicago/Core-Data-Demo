//
//  DataHandler.h
//  CoreDataDemo
//
//  Created by T. Binkowski on 11/4/11.
//  Copyright (c) 2011 Argonne National Laboratory. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataHandler : NSObject
@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
- (void)addApplication:(NSString *)application fromArtist:(NSString *)artist withCategories:(NSArray *)categories;
- (void)deleteAllObjects: (NSString *) entityDescription;
- (void)dumpCategories;
- (void)dumpArtists;
@end
