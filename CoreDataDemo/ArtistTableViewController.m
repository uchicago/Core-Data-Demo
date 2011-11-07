//
//  ArtistTableViewController.m
//  CoreDataDemo
//
//  Created by T. Andrew Binkowski on 11/5/11.
//  Copyright (c) 2011 Argonne National Laboratory. All rights reserved.
//

#import "ArtistTableViewController.h"
#import "Application.h"
#import "Artist.h"

@implementation ArtistTableViewController

@synthesize fetchedResultsController;
@synthesize managedObjectContext;
@synthesize searchBar;
@synthesize isSearchType;
@synthesize currentPredicate;

#pragma mark - Fetched results controller
/*******************************************************************************
 * @method          fetchedResultsController
 * @abstract        <# Abstract #>
 * @description     <# Description #>
 ******************************************************************************/
- (NSFetchedResultsController *)fetchedResultsController 
{    
    if (fetchedResultsController != nil) {
        return fetchedResultsController; 
    }
    NSLog(@"New FRC");
    
    // Create and configure a fetch request with the Book entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Application"];
    
	// Create the sort descriptors array.
	NSSortDescriptor *authorDescriptor = [[NSSortDescriptor alloc] initWithKey:@"artist.artistName" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:authorDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	// Create and initialize the fetch results controller.
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                                                        managedObjectContext:self.managedObjectContext 
                                                                          sectionNameKeyPath:@"artist.artistName" cacheName:nil];
	self.fetchedResultsController.delegate = self;
	return fetchedResultsController;
}    

/*******************************************************************************
 * @method          initWithStyle
 * @abstract        <# Abstract #>
 * @description     <# Description #>
 ******************************************************************************/
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        isSearchType = YES;
        self.title = @"Applications";
        self.currentPredicate = nil;
    }
    return self;
}

/*******************************************************************************
 * @method          filterContentForSearchText:searchText scope:
 * @abstract        <# Abstract #>
 * @description     <# Description #>
 ******************************************************************************/
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSString *query = self.searchDisplayController.searchBar.text;
    if (query && query.length) {
        NSLog(@"SearchString:%@ Query:%@",searchText,query);  
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"trackName contains[cd] %@", query];
        [self.fetchedResultsController.fetchRequest setPredicate:predicate];
    }
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error])
        NSLog(@"Error: %@", [error localizedDescription]);
}

/*******************************************************************************
 * @method          searchDisplayController
 * @abstract        <# Abstract #>
 * @description     <# Description #>
 ******************************************************************************/
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:nil];
    return YES;
}

#pragma mark - Memory Management
/*******************************************************************************
 * @method          didReceiveMemoryWarning
 * @abstract        <# Abstract #>
 * @description     <# Description #>
 ******************************************************************************/
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
/*******************************************************************************
 * @method          viewDidLoad
 * @abstract        <# Abstract #>
 * @description     <# Description #>
 ******************************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
}

- (void)viewDidUnload
{
    [self setSearchBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.fetchedResultsController = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error])	
        NSLog(@"Error: %@", [error localizedDescription]);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

/*******************************************************************************
 * @method          <# Method Name #>
 * @abstract        <# Abstract #>
 * @description     <# Description #>
 ******************************************************************************/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

/*******************************************************************************
 * @method          <# Method Name #>
 * @abstract        <# Abstract #>
 * @description     <# Description #>
 ******************************************************************************/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];

    return cell;
}

/*******************************************************************************
 * @method          <# Method Name #>
 * @abstract        <# Abstract #>
 * @description     <# Description #>
 ******************************************************************************/
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	// Display the authors' names as section headings.
    return [[[fetchedResultsController sections] objectAtIndex:section] name];
}

/*******************************************************************************
 * @method          configureCell
 * @abstract        <# Abstract #>
 * @description     <# Description #>
 ******************************************************************************/
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	
    // Configure the cell to show the book's title
	Application *book = [fetchedResultsController objectAtIndexPath:indexPath];
	cell.textLabel.text = book.trackName;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}




@end
