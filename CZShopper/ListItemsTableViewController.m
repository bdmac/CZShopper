//
//  ListItemsTableViewController.m
//  CZShopper
//
//  Created by Brian McManus on 11/16/12.
//  Copyright (c) 2012 Brian McManus. All rights reserved.
//

#import "ListItemsTableViewController.h"
#import <RestKit/UI.h>
#import "ShoppingListItem.h"
#import "CZShopperMappingProvider.h"
#import "SVProgressHUD.h"

@interface ListItemsTableViewController () {
    BOOL _loadingItems;
    BOOL _isEditing;
}
@property (strong, nonatomic) RKFetchedResultsTableController *tableController;
@property (strong, nonatomic) NSArray *items;
@end

@implementation ListItemsTableViewController

@synthesize items, tableController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Create and configure our RKFetchedResultsTableController
    self.tableController = [[RKObjectManager sharedManager] fetchedResultsTableControllerForTableViewController:self];
    self.tableController.delegate = self;
    self.tableController.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableController.heightForHeaderInSection = 30;
    self.tableController.canEditRows = YES;
    self.tableController.pullToRefreshEnabled = YES;
    self.tableController.autoRefreshFromNetwork = YES;
    self.tableController.resourcePath = @"/items.json";
    
    // This bit handles sorting our items into sections and alphabetizes them by item.name.
    NSSortDescriptor *categoryDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"category" ascending:YES];
    NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    self.tableController.sortDescriptors = [NSArray arrayWithObjects:categoryDescriptor, nameDescriptor, nil];
    self.tableController.sectionNameKeyPath = @"category";
    
    // Very simplistic cell mapping.  No reason to use a custom UITableViewCell here...
    RKTableViewCellMapping *cellMapping = [RKTableViewCellMapping cellMapping];
    cellMapping.cellClassName = @"UITableViewCell";
    cellMapping.reuseIdentifier = @"ItemCell";
    [cellMapping mapKeyPath:@"name" toAttribute:@"textLabel.text"];
    [self.tableController mapObjectsWithClass:[ShoppingListItem class] toTableCellsWithMapping:cellMapping];    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableController loadTable];
}

// Swipe to delete
- (void)tableController:(RKAbstractTableController *)tableController didDeleteObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    RKLogTrace(@"SWIPED TO DELETE");
    [self.tableController loadTable];
}

/**
 * We have two possible segues to content with for this controller.
 *
 * 1. Adding a new item (from the navbar button).
 * 2. Editing an existing item (by clicking its row).
 * 
 * In either case we wind up on ItemDetailsViewController and this method gets things
 * set up for that.
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"EditItemSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ShoppingListItem *item = [self.tableController objectForRowAtIndexPath:indexPath];
        _isEditing = YES;
        [[segue destinationViewController] setItem:item];
        [[segue destinationViewController] setDelegate:self];
    }
    else if ([segue.identifier isEqualToString:@"AddItemSegue"]) {
        _isEditing = NO;
        [[[[segue destinationViewController] viewControllers] objectAtIndex:0] setDelegate:self];
    }
}

// Handles returning to our list view appropriately whether we are editing an item or creating a new one.
- (void)returnToListView {
    if (_isEditing) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)showNetworkError {
    [[[UIAlertView alloc] initWithTitle:@"Network Error"
                                message:@"Please check your network connection and try again."
                               delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:@"Okay", nil] show];
}

#pragma mark - ItemDetailsControllerDelegate methods

- (void)didCancel {
    [self returnToListView];
}

- (void)didSave:(ShoppingListItem *)item {
    if ([[RKObjectManager sharedManager] isOnline]) {
        if (item.name && item.category && item.name.length > 0 && item.category.length > 0) {
            [SVProgressHUD showWithStatus:@"Saving..." maskType:SVProgressHUDMaskTypeGradient];
            if (_isEditing) {
                [[RKObjectManager sharedManager] putObject:item usingBlock:^(RKObjectLoader *loader) {
                    loader.onDidLoadResponse = ^(RKResponse *response) {
                        [SVProgressHUD showSuccessWithStatus:@"Saved!"];
                        [self returnToListView];
                    };
                }];
            }
            else {
                [[RKObjectManager sharedManager] postObject:item usingBlock:^(RKObjectLoader *loader) {
                    loader.onDidLoadResponse = ^(RKResponse *response) {
                        [SVProgressHUD showSuccessWithStatus:@"Saved!"];
                        [self returnToListView];
                    };
                }];
            }
        }
        else {
            [[[UIAlertView alloc] initWithTitle:@"Item Errors"
                                        message:@"Please fill in all item fields."
                                       delegate:nil
                              cancelButtonTitle:nil
                              otherButtonTitles:@"Okay", nil] show];
        }
    }
    else {
        if (!_isEditing) {
            [item deleteEntity];
        }
        [self showNetworkError];
    }
}

- (void)didDelete:(ShoppingListItem *)item {
    if ([[RKObjectManager sharedManager] isOnline]) {
        if (item) {
            [SVProgressHUD showWithStatus:@"Deleting..." maskType:SVProgressHUDMaskTypeGradient];
            [[RKObjectManager sharedManager] deleteObject:item usingBlock:^(RKObjectLoader *loader) {
                loader.onDidLoadResponse = ^(RKResponse *response) {
                    [SVProgressHUD showSuccessWithStatus:@"Deleted!"];
                    [self returnToListView];
                };
            }];
        }
        else {
            [self returnToListView];
        }
    }
    else {
        [self showNetworkError];
    }
}
@end
