//
//  Artist.h
//  CoreDataDemo
//
//  Created by T. Binkowski on 11/4/11.
//  Copyright (c) 2011 Argonne National Laboratory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Application;

@interface Artist : NSManagedObject

@property (nonatomic, retain) NSString * artistId;
@property (nonatomic, retain) NSString * artistName;
@property (nonatomic, retain) NSSet *applications;
@end

@interface Artist (CoreDataGeneratedAccessors)

- (void)addApplicationsObject:(Application *)value;
- (void)removeApplicationsObject:(Application *)value;
- (void)addApplications:(NSSet *)values;
- (void)removeApplications:(NSSet *)values;
@end
