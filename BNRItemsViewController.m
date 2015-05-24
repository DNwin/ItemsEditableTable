//
//  BNRItemsViewController.m
//  Homepwner
//
//  Created by Dennis Nguyen on 5/20/15.
//  Copyright (c) 2015 dnwin. All rights reserved.
//

#import "BNRItemsViewController.h"
#import "BNRItemStore.h"
#import "BNRItem.h"
#import "BNRDetailViewController.h" // this controller is responsible for pushing this new controller on stack

@interface BNRItemsViewController ()

@end

@implementation BNRItemsViewController


// methods for two buttons


#pragma mark Controller Life Cycle

// replace superclass designated initializer with init
- (instancetype)init
{
    // call superclass init
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Homelist";
        
        // ADD new item, new bar button item that adds by calling addNewItem
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
        navItem.rightBarButtonItem = bbi;
        
        // new bar button item for edit
        // AUTOMATICALLY toggles editing mode (setEditing property)
        navItem.leftBarButtonItem = self.editButtonItem;
    }
    return self;
}

// make sure the superclass designated initializer calls this class's designated init
- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

#pragma mark View Life Cycle
///////// view appear

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
     //reload all table cells from data source when view reappears
    [self.tableView reloadData];
}
// implement required TableView protocol
//- (NSInteger)tableView:(UITableView *)tableView
// numberOfRowsInSection:(NSInteger)section

// FOR CUSTOM VIEWS ON TOP OF TABLE VIEW
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // register the type of cell to use if no cells in reuse pool
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

#pragma mark Actions
// Adds a new item
- (IBAction)addNewItem:(id)sender
{
    // new bnr item
    BNRItem *newItem = [[BNRItemStore sharedStore] createItem]; // create random item
    // get index of random item in array
    NSInteger lastRow = [[[BNRItemStore sharedStore] allItems] indexOfObject:newItem];
    
    // get index path
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
}


#pragma mark Table view data source
////////////////////// REQUIRED PROTOCOLS

// tableView asks delegate for number of rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // returns how many items in table
    NSInteger number;
    number = [[[BNRItemStore sharedStore] allItems] count];
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // make cell
//    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    
    // use reusable pool cells, autocreate cells
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    NSArray *items = [BNRItemStore sharedStore].allItems;
    BNRItem *item = items[indexPath.row];
    
    cell.textLabel.text = [item description];
    
    return cell;
}

// protocol for deletion


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // IF table view is asking to commit a delte command
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSArray *items = [[BNRItemStore sharedStore] allItems];
        BNRItem *item = items[indexPath.row]; // get item in array at equivalent row
        [[BNRItemStore sharedStore] removeItem:item]; // remove item from array
        
        // remove the row from table view
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}

//// protocol for moving,
//// *** Implementing this protocol method allows rows to be moved when editing is on
//
- (void)tableView:(UITableView *)tableView
    moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
            toIndexPath:(NSIndexPath *)toIndexPath
{
    // move item in array
    [[BNRItemStore sharedStore] moveItemAtIndex:fromIndexPath.row
                                        toIndex:toIndexPath.row];
    
}

#pragma mark Table view delegate

// protocol for selecting a row
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // make new controller
    BNRDetailViewController *detailViewController = [[BNRDetailViewController alloc] init];
    
    NSArray *items = [[BNRItemStore sharedStore] allItems];
    BNRItem *selectedItem = items[indexPath.row];
    detailViewController.item = selectedItem;
    
    // push to top of stack
    [[self navigationController]pushViewController:detailViewController animated:YES];
}


@end
