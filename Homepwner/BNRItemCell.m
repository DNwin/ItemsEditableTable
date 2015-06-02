//
//  BNRItemCell.m
//  Homepwner
//
//  Created by Dennis Nguyen on 5/31/15.
//  Copyright (c) 2015 dnwin. All rights reserved.
//

#import "BNRItemCell.h"

@interface BNRItemCell()

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;


@end

@implementation BNRItemCell

- (IBAction)showImage:(id)sender
{
    if (self.actionBlock)
    {
        self.actionBlock();
    }
}

- (void)updateInterfaceforDynamicTypeSize
{
    // Set all fonts to preferred text styles
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.nameLabel.font = font;
    self.valueLabel.font = font;
    
    font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    
    self.serialNumberLabel.font = font;
    
    // Get current font size
    static NSDictionary *imageSizeDictionary;
    
    if (!imageSizeDictionary)
    {
        imageSizeDictionary = @{ UIContentSizeCategoryExtraSmall : @40,
                                 UIContentSizeCategorySmall : @40,
                                 UIContentSizeCategoryMedium : @40,
                                 UIContentSizeCategoryLarge : @40,
                                 UIContentSizeCategoryExtraLarge : @45,
                                 UIContentSizeCategoryExtraExtraLarge : @55,
                                 UIContentSizeCategoryExtraExtraExtraLarge : @65 };
    }
    
    // Get preferred content size
    NSString *userSize = [[UIApplication sharedApplication] preferredContentSizeCategory];
    NSNumber *imageSize = imageSizeDictionary[userSize];
    
    // Set constraint value to height. Since a width/height equal constraint was added, only one needs to be adjusted.
    self.imageViewHeightConstraint.constant = imageSize.floatValue;

}

// Called when loaded with NIB (For views, not view controllers)

- (void)awakeFromNib
{
    // Update fonts everytime cells are loaded
    [self updateInterfaceforDynamicTypeSize];
    
    // NSNotificationCenter - Change font size if user changes
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(updateInterfaceforDynamicTypeSize)
               name:UIContentSizeCategoryDidChangeNotification
             object:nil];
    
    // Constraint - Equal height and width constraint on ImageView
    // ** Make sure to remove the current width constraint by making it
    // ** a placeholder constraint. Check "Remove at build time".
    NSLayoutConstraint *constraint =
    [NSLayoutConstraint constraintWithItem:self.thumbnailView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.thumbnailView attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    [self.thumbnailView addConstraint:constraint];
}

- (void)dealloc
{
    // NSNotificationCenter - Remove Observer
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}
@end
