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
- (IBAction)addNewItem:(id)sender
{
    
}

- (IBAction)toggleEditingMode:(id)sender
{
    if (self.isEditing)
    {
        // if editing is enabled
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
    }
    else
    {
        // if editing is disabled
        [sender setTitle:@"Done" forState:UIControlStateNormal];
    }
}


// replace superclass designated initializer with init
- (instancetype)init
{
    // call superclass init
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        // make bnritemstore object (lazy instantiate), only creates singleton, add 5 items to store
        for (int i = 0; i < 5; i++)
        {
            [[BNRItemStore sharedStore] createItem];
        }
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
