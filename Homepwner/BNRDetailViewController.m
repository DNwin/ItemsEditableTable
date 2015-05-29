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

@interface BNRDetailViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate> // uinavcontdelegate is superclass of imagepicker

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialNumberField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@end

@implementation BNRDetailViewController

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

// action - when camera button is pressed
- (IBAction)takePicture:(id)sender {
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
    
    // PRESENT viewcontroller modaly
    [self presentViewController:imagePicker animated:YES completion:nil];
}

// PROTOCOL METHODS //
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // get image from dictionary
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // store image using the current object's UID into imagestore
    [[BNRImageStore sharedStore] setImage:image
                                   forKey:self.item.itemKey];
    // put image onto image view
    self.imageView.image = image;
    
    // DISMISS - take image picker off screen
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder]; // resign keyboard when return is pressed
    return YES;
}


@end
