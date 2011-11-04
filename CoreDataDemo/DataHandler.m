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


- (void)addApplication:(NSString *)application fromArtist:(NSString *)artist withCategories:(NSArray *)categories
{
    NSLog(@"Adding %@",artist);

    // Create a new instance of the app
	Application *app = (Application *)[NSEntityDescription insertNewObjectForEntityForName:@"Application" inManagedObjectContext:self.managedObjectContext];
    app.trackName = application;
    
    // Create a new artist (if needed)
   	NSError *error = nil;
    
    //NSEntityDescription *ent = [NSEntityDescription entityForName:@"Artist" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Artist"];
    //fetchRequest.entity = ent;
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"artistName == %@", artist];
    fetchRequest.propertiesToFetch = [NSArray arrayWithObjects:@"artistName", nil];
    NSArray *fetchedItems = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    //NSLog(@"Fectched:%@",fetchedItems);
    if (fetchedItems.count == 0) {
        Artist *art = (Artist *)[NSEntityDescription insertNewObjectForEntityForName:@"Artist" inManagedObjectContext:self.managedObjectContext];
        art.artistName = artist;
        //NSLog(@"New Artist:%@",artist);
        app.artist = art;
    } else {
        app.artist = [fetchedItems lastObject];
    }
    
    
    
    NSEntityDescription *cat = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *fetchRequest2 = [[NSFetchRequest alloc] init];
    fetchRequest2.entity = cat;
    //fetchRequest.predicate = [NSPredicate predicateWithFormat:@"name == %@", category];
    //fetchRequest.propertiesToFetch = [NSArray arrayWithObjects:@"name", nil];
    NSArray *fetchedItems2 = [self.managedObjectContext executeFetchRequest:fetchRequest2 error:&error];
    NSLog(@"Fectched:%@",fetchedItems2);
    
    NSMutableSet *seenCategories = [[NSMutableSet alloc] init];
    for (Category *c in fetchedItems2)
        [seenCategories addObject:c.name];
        
    for (NSString *cs in categories) {
        if (![[seenCategories allObjects] containsObject:cs] ) {
            Category *newCat = (Category *)[NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:self.managedObjectContext];
            newCat.name = cs;
            NSLog(@"New Categories:%@",cs);
            [newCat addApplicationsObject:app];
            [app addCategoriesObject:newCat];
        }
        
        for (Category *c in fetchedItems2) {
            if ([c.name isEqualToString:cs]) {
                [c addApplicationsObject:app];
                [app addCategoriesObject:c];
            }
        }

    }
    /*
     [[anEntityAObj mutableSetValueForKey:@"bees"] addObject:aNewBObj];
     
     
     
    - (IBAction)addLessonPlan:(id)sender {
        NSManagedObjectContext *context = [self managedObjectContext];
        NSArray * selectedArray = [curriculums selectedObjects];
        NSManagedObject * selected = [selectedArray objectAtIndex:0];
        id lessonPlan = [NSEntityDescription insertNewObjectForEntityForName:@"LessonPlan" inManagedObjectContext:context];
        NSMutableSet * lessonPlansSet = [selected mutableSetValueForKey:@"lessonPlans"];
        [lessonPlansSet addObject:lessonPlan];
        [lessonPlanSet setValue:lessonPlansSet forKey:@"lessonPlans"];
        [context processPendingChanges];
    }
     */

    /*
    //NSLog(@"Fectched:%@",fetchedItems);
    if (fetchedItems.count == 0) {
        Artist *art = (Artist *)[NSEntityDescription insertNewObjectForEntityForName:@"Artist" inManagedObjectContext:self.managedObjectContext];
        art.artistName = artist;
        NSLog(@"New Artist:%@",artist);
    } else {
        app.artist = [fetchedItems lastObject];
    }
*/
    
    
/*
    
	// Configure the new event with information from the location.
	CLLocationCoordinate2D coordinate = [location coordinate];
    [app setArtist:<#(Artist *)#>
	[event setLatitude:[NSNumber numberWithDouble:coordinate.latitude]];
	[event setLongitude:[NSNumber numberWithDouble:coordinate.longitude]];
	
	// Should be timestamp, but this will be constant for simulator.
	// [event setCreationDate:[location timestamp]];
	[event setCreationDate:[NSDate date]];
*/	
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
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
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
    NSEntityDescription *ent = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = ent;
    
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
    NSEntityDescription *ent = [NSEntityDescription entityForName:@"Artist" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = ent;
    
    NSArray *fetchedItems = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (Artist *a in fetchedItems) {
        NSLog(@"Artist:%@",a.artistName);
        for (Application *apps in a.applications)
            NSLog(@"\t%@",apps.trackName);
    }
}

@end

