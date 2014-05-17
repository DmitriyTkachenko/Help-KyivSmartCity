//
//  HLPFirstScreenViewController.m
//  HELP
//
//  Created by WildSpirit on 17.05.14.
//  Copyright (c) 2014 WildSpirit. All rights reserved.
//

#import "HLPFirstScreenViewController.h"

@interface HLPFirstScreenViewController ()

@end

@implementation HLPFirstScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    if ( [[NSUserDefaults standardUserDefaults] objectForKey:@"token"] == nil ) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(turnOffModal:) name:@"TurnRegistrationOff" object:nil];
        [self performSegueWithIdentifier:@"registration" sender:nil];
    }
}

-(void)turnOffModal:(NSNotification *)notification
{
    NSLog(@"TurnRegistrationOff");
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
//    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
    
#warning notif off
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    HLPThirdScreenViewController *tsvc = [[HLPThirdScreenViewController alloc] init];
//    [self.navigationController pushViewController:tsvc animated:YES];
//}
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
