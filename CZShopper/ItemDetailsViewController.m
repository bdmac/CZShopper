//
//  ItemDetailsViewController.m
//  CZShopper
//
//  Created by Brian McManus on 11/17/12.
//  Copyright (c) 2012 Brian McManus. All rights reserved.
//

#import "ItemDetailsViewController.h"

@interface ItemDetailsViewController ()

@end

@implementation ItemDetailsViewController

@synthesize item, delegate;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.item) {
        // Editing an item so we prepopulate the fields.
        self.itemName.text = self.item.name;
        self.itemCategory.text = self.item.category;
        self.deleteButton.hidden = NO;
    }
    else {
        self.deleteButton.hidden = YES;
    }
}

#pragma mark - UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.itemName) {
        [self.itemCategory becomeFirstResponder];
    }
    else if (textField == self.itemCategory) {
        [self savePressed:nil];
    }
    return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // We implement this to ensure that tapping anywhere in a table cell
    // gives focus to its text field.  This prevents possible problems when
    // a user taps between the text field's bounds and the table cell's bounds.
    if (indexPath.row == 0) {
        [self.itemName becomeFirstResponder];
    }
    else if (indexPath.row == 1) {
        [self.itemName becomeFirstResponder];
    }
}

- (void)viewDidUnload {
    [self setItemName:nil];
    [self setItemCategory:nil];
    [self setDeleteButton:nil];
    [super viewDidUnload];
}

// Button actions pretty much just invoke appropriate delegate methods
- (IBAction)cancelPressed:(id)sender {
    [self.delegate didCancel];
}

- (IBAction)savePressed:(id)sender {
    if (!self.item)
        self.item = [ShoppingListItem object];
    self.item.name = self.itemName.text;
    self.item.category = self.itemCategory.text;
    [self.delegate didSave:self.item];
}

- (IBAction)deletePressed:(id)sender {
    [self.delegate didDelete:self.item];
}
@end
