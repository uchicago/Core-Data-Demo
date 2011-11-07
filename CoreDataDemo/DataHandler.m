//
//  DataHandler.m
//  CoreDataDemo
//
//  Created by T. Binkowski on 11/4/11.
//  Copyright (c) 2011 Argonne National Laboratory. All rights reserved.
//

#import "DataHandler.h"
#import "Artist.h"
#import "Category.h"
#import "Application.h"

@implementation DataHandler
@synthesize managedObjectContext;


- (void)addApplication:(NSString *)application 
            fromArtist:(NSString *)artist 
        withCategories:(NSArray *)categories
{
    NSLog(@"Adding %@",artist);

    // Create a new instance of the app
	Application *app = (Application *)[NSEntityDescription insertNewObjectForEntityForName:@"Application" inManagedObjectContext:self.managedObjectContext];
    app.trackName = application;
    
    // Create a new artist (if needed)
   	NSError *error = nil;
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Artist"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"artistName == %@", artist];
    fetchRequest.propertiesToFetch = [NSArray arrayWithObjects:@"artistName", nil];
    NSArray *fetchedItems = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    //NSLog(@"Fectched:%@",fetchedItems);
    if (fetchedItems.count == 0) {
        Artist *art = (Artist *)[NSEntityDescription insertNewObjectForEntityForName:@"Artist" inManagedObjectContext:self.managedObjectContext];
        art.artistName = artist;
        app.artist = art;  // Add the artist entity to the artist property
    } else {
        app.artist = [fetchedItems lastObject];
    }
    

    // Categories
    fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Category"];
    //fetchRequest.propertiesToFetch = [NSArray arrayWithObjects:@"name", nil];
    NSArray *fetchedItems2 = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSLog(@"Fectched 2:%@",fetchedItems2);

    // Create a set of all seen categories
    NSMutableSet *seenCategories = [[NSMutableSet alloc] init];
    for (Category *c in fetchedItems2)
        [seenCategories addObject:c.name];
        
    for (NSString *cs in categories) {
        // Create a new category if we haven't seen it.
        if (![[seenCategories allObjects] containsObject:cs] ) {
            Category *newCat = (Category *)[NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:self.managedObjectContext];
            newCat.name = cs;
            [newCat addApplicationsObject:app];
            [app addCategoriesObject:newCat];
        }

        // Add the data to existing category
        for (Category *c in fetchedItems2) {
            if ([c.name isEqualToString:cs]) {
                [c addApplicationsObject:app];
                [app addCategoriesObject:c];
            }
        }
    }
    
	// Commit the change.
	if (![self.managedObjectContext save:&error]) {
		// Handle the error.
	}
    
}

/*******************************************************************************
 * @method      deleteAllObjects
 * @abstract    <# abstract #>
 * @description <# description #>
 *******************************************************************************/
- (void) deleteAllObjects: (NSString *) entityDescription  {
    NSError *error;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityDescription];
    NSArray *items = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *managedObject in items) {
        [self.managedObjectContext deleteObject:managedObject];
        NSLog(@"%@ object deleted",entityDescription);
    }
    
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error deleting %@ - error:%@",entityDescription,error);
    }
}

/*******************************************************************************
 * @method      dumpCategories
 * @abstract    <# abstract #>
 * @description <# description #>
 *******************************************************************************/
- (void)dumpCategories 
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Category"];
    
    NSArray *fetchedItems = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (Category *c in fetchedItems) {
        NSLog(@"Cat:%@",c.name);
        for (Application *a in c.applications)
            NSLog(@"\t%@",a.trackName);
    }
}

/*******************************************************************************
 * @method      dumpArtists
 * @abstract    <# abstract #>
 * @description <# description #>
 *******************************************************************************/
- (void)dumpArtists
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Artist"];
    
    NSArray *fetchedItems = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (Artist *a in fetchedItems) {
        NSLog(@"Artist:%@",a.artistName);
        for (Application *apps in a.applications)
            NSLog(@"\t%@",apps.trackName);
    }
}

@end

