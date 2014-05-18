//
//  GKViewController.m
//  GKContactImage
//
//  Created by Georg Kitz on 18/05/14.
//  Copyright (c) 2014 Aurora Apps. All rights reserved.
//

#import "GKViewController.h"
#import "UIImage+GKContact.h"

@interface GKViewController ()

@end

@implementation GKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    self.bigImageView.image = [UIImage imageForName:@"Georg Kitz" size:self.bigImageView.frame.size];
    self.middleImageView.image = [UIImage imageForName:@"Georg Kitz" size:self.middleImageView.frame.size];
    self.smallImageView.image = [UIImage imageForName:@"Georg Kitz" size:self.smallImageView.frame.size];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
