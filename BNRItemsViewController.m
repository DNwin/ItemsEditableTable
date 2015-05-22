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

@interface BNRItemsViewController ()

@property (nonatomic, strong) IBOutlet UIView *headerView; // custom view from xib, strong because it is a top level object

@end

@implementation BNRItemsViewController

- (UIView *)headerView // GETTER - lazy instantiates the headerview using getter
{
    if (!_headerView)
    {
        // if no headerview then load
        [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil];
    }
    
    return _headerView;
}

// methods for two buttons

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

- (IBAction)toggleEditingMode:(id)sender
{
    if (self.isEditing)
    {
        // if editing is enabled
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        // disable editing
        [self setEditing:NO animated:YES];
    }
    else
    {
        // if editing is disabled
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        // enter editing mode
        [self setEditing:YES animated:YES];
    }
}


// replace superclass designated initializer with init
- (instancetype)init
{
    // call superclass init
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        
    }
    return self;
}

// make sure the superclass designated initializer calls this class's designated init
- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}


// implement required TableView protocol
//- (NSInteger)tableView:(UITableView *)tableView
// numberOfRowsInSection:(NSInteger)section

// REQUIRED PROTOCOLS

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

// FOR CUSTOM VIEWS ON TOP OF TABLE VIEW
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // register the type of cell to use if no cells in reuse pool
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    // tell table view about header view
    UIView *header = self.headerView;
    // self.tableView.tableHeaderView = header;
    // set table view property
    [self.tableView setTableHeaderView:header];
}

@end
