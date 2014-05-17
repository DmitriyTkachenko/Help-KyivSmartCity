//
//  HLPDecisionController.m
//  HELP
//
//  Created by WildSpirit on 17.05.14.
//  Copyright (c) 2014 WildSpirit. All rights reserved.
//

#import "HLPDecisionController.h"

#import "HLPRegistrationViewController.h"
#import "HLPFirstScreenViewController.h"

@interface HLPDecisionController ()
{
    UIViewController * secondVC;
}
@end

@implementation HLPDecisionController

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
    
    if( [[NSUserDefaults standardUserDefaults] objectForKey:@"token"] ) {
        [self performSegueWithIdentifier:@"normal" sender:nil];
    } else {
        [self performSegueWithIdentifier:@"registration" sender:nil];
    }

    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
