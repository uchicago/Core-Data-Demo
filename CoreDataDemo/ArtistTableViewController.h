//
//  ArtistTableViewController.h
//  CoreDataDemo
//
//  Created by T. Andrew Binkowski on 11/5/11.
//  Copyright (c) 2011 Argonne National Laboratory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArtistTableViewController : UITableViewController <NSFetchedResultsControllerDelegate,UISearchDisplayDelegate,UISearchBarDelegate>
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (assign) BOOL isSearchType;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSString *currentPredicate;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope;
@end
