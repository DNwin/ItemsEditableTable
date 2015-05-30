//
//  BNRDetailViewController.m
//  Homepwner
//
//  Created by Dennis Nguyen on 5/22/15.
//  Copyright (c) 2015 dnwin. All rights reserved.
//

#import "BNRDetailViewController.h"
#import "BNRItem.h"
#import "BNRImageStore.h" 
#import "BNRItemStore.h"

@interface BNRDetailViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIPopoverControllerDelegate>
// uinavcontdelegate is superclass of imagepicker, popover controller camera for iPads

@property (strong, nonatomic) UIPopoverController *imagePickerPopover; // Popover controller for iPad, takePicture:

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialNumberField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;


@end

@implementation BNRDetailViewController

// New designated initializer, checks if it is for a new item and adds new bar button items
- (instancetype)initForNewItem:(BOOL)isNew
{
    // Call originial designated init
    self = [super initWithNibName:nil bundle:nil];
    
    if (self)
    {
        // Show Done and cancel buttons if detailview is making a new item
        if (isNew)
        {
            // Done button as right bar button
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
            self.navigationItem.rightBarButtonItem = doneItem;
            
            // Cancel button as left bar button
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
            self.navigationItem.leftBarButtonItem = cancelItem;
        }
    }
    
    return self;
}

// Override designated initializer of UIViewController, throw exception if called
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    @throw [NSException exceptionWithName:@"Wrong initializer" reason:@"Use initForNewItem" userInfo:nil];
}

- (void)viewDidLoad
{
    // Programmatically add UIImageView
    UIImageView *iv = [[UIImageView alloc] init];
    
    // scale images to fit (Aspect Fit)
    iv.contentMode = UIViewContentModeScaleAspectFit;
    // No translated constraints, iOS used this before autolayout, IMPORTANT
    iv.translatesAutoresizingMaskIntoConstraints = NO;
    // Add subview
    [self.view addSubview:iv];
    // Point to the property
    self.imageView = iv;
    [self.imageView setContentHuggingPriority:200 forAxis:UILayoutConstraintAxisVertical];
    [self.imageView setContentCompressionResistancePriority:700 forAxis:UILayoutConstraintAxisVertical];
    
    // Make a dictionary to prepare adding of constraints
    NSDictionary *nameMap = @{@"imageView" : self.imageView,
                              @"dateLabel" : self.dateLabel,
                              @"toolbar"   : self.toolbar};
    
    // imageview is 0 points from superview at left and right edges
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|" options:0 metrics:nil views:nameMap];
    // 8 points (default) between them
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[dateLabel]-[imageView]-[toolbar]" options:0 metrics:nil views:nameMap];
    
    // add constraint to the view that contains all views effected, in this case the superview
    [self.view addConstraints:horizontalConstraints];
    [self.view addConstraints:verticalConstraints];
}


// Send this method when device is rotated
- (void)preparesViewForOrientation:(UIInterfaceOrientation)orientation
{
    // Do nothing if ipad
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        return;
    }
    
    // IF in landscape
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        // disable camera button
        self.imageView.hidden = YES;
        self.cameraButton.enabled = NO;
    }
    else // if in portrait
    {
        self.imageView.hidden = NO;
        self.cameraButton.enabled = YES;
    }
    
}


// Override - this is sent everytime there's a rotation
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self preparesViewForOrientation:toInterfaceOrientation];
}


- (IBAction)backgroundTapped:(id)sender {
    // changed xib class from UIView to UIControl enable it to handle touch events
    [self.view endEditing:YES]; // end first responder, remove keyboard
    
    // FOR TESTING - exercise any ambiguity in views
//    for (UIView *subview in self.view.subviews)
//    {
//        if ([subview hasAmbiguousLayout])
//        {
//             [subview exerciseAmbiguityInLayout];
//        }
//       
//    }
}

// Gets called anytime view changes in size, override to check if any subviews have anbiguous layout
//- (void)viewDidLayoutSubviews
//{
//    for (UIView *subview in self.view.subviews)
//    {
//        if ([subview hasAmbiguousLayout])
//        {
//            NSLog(@"AMBIGUOUS: %@", subview);
//            // will get called
//        }
//    }
//}


// override item getter
- (void)setItem:(BNRItem *)item
{
    _item = item;
    self.navigationItem.title = _item.itemName;
}

// called everytime view loads
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    BNRItem *item = self.item;
    
    self.nameField.text = item.itemName;
    self.serialNumberField.text = item.serialNumber;
    self.valueField.text = [NSString stringWithFormat:@"%d", item.valueInDollars];
    
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    
    self.dateLabel.text = [dateFormatter stringFromDate:item.dateCreated];
    
    // load image
    NSString *imageKey = self.item.itemKey;
    UIImage *imageToDisplay = [[BNRImageStore sharedStore] imageForKey:imageKey];
    
    self.imageView.image = imageToDisplay;
    
    // Check for current orientation
    UIInterfaceOrientation io = [[UIApplication sharedApplication] statusBarOrientation];
    [self preparesViewForOrientation:io];
}

// call everytime view gets popped off stack
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // clear first responder, dismisses any keyboard
    [self.view endEditing:YES];
    
    // save all textfields back to item
    
    BNRItem *item = self.item;
    
    item.itemName = self.nameField.text;
    item.serialNumber = self.serialNumberField.text;
    item.valueInDollars = [self.valueField.text intValue];
    
}

#pragma Button Methods
- (void)save:(id)sender
{
    // To dismiss modal VC, the calling controller needs to be dismiss it.
    // The property presentingViewController points to the original BRNViewController
    // also send a block to reload the data upon completion
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

- (void)cancel:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
    
    // Remove the current item from sharedstore
    [[BNRItemStore sharedStore] removeItem:self.item];
    
}


// action - when camera button is pressed
- (IBAction)takePicture:(id)sender {
    
    // If the popover is up, remove it
    if ([self.imagePickerPopover isPopoverVisible])
    {
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        self.imagePickerPopover = nil;
        return;
    }
    // Make image picker controller
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // if device has camera, take picture else pick from photo library
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    imagePicker.delegate = self;
    

//    // IF ipad
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
//    {
//        // initialize popover camera, add it to the image picker controller
//        self.imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
//    }
//    else // IF iphone
//    {
//        // Present viewcontroller modaly
//        [self presentViewController:imagePicker animated:YES completion:nil];
//    };
    
        [self presentViewController:imagePicker animated:YES completion:nil];
}


#pragma mark Protocol Methods

// PROTOCOL - Dismisses iPad imagepopover
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.imagePickerPopover = nil;
}


// Protocol - Sent when picture is taken
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // get image from dictionary
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // store image using the current object's UID into imagestore
    [[BNRImageStore sharedStore] setImage:image
                                   forKey:self.item.itemKey];
    // put image onto image view
    self.imageView.image = image;
    
    // Do I have a popover?
    if (self.imagePickerPopover)
    {
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        self.imagePickerPopover = nil;
    }
    else
    {
        // DISMISS - take modal image picker off screen
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

// Protocol - sent when return key is pressed
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder]; // resign keyboard when return is pressed
    return YES;
}


@end
