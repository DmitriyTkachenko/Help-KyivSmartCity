//
//  HLPFirstAidPageContentViewController.m
//  HELP
//
//  Created by WildSpirit on 18.05.14.
//  Copyright (c) 2014 WildSpirit. All rights reserved.
//

#import "HLPFirstAidPageContentViewController.h"

@interface HLPFirstAidPageContentViewController ()

@end

@implementation HLPFirstAidPageContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.backgroundImageView.image = [UIImage imageNamed:self.imageFile];
    self.titleLabel.text = self.titleText;
    self.contentText.text = self.contentTextString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)returnToInfo:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
