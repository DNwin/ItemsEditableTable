//
//  BNRImageViewController.m
//  Homepwner
//
//  Created by Dennis Nguyen on 5/31/15.
//  Copyright (c) 2015 dnwin. All rights reserved.
//

#import "BNRImageViewController.h"

@interface BNRImageViewController ()

@end

@implementation BNRImageViewController

- (void)loadView
{
    // Load a custom image popover
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.view = imageView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    
    // Cast so that its ok to set image
    UIImageView *imageView = (UIImageView *)self.view;
    imageView.image = self.image;
}







- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
