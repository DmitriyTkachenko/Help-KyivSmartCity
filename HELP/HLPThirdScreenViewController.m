//
//  HLPThirdScreenViewController.m
//  HELP
//
//  Created by WildSpirit on 17.05.14.
//  Copyright (c) 2014 WildSpirit. All rights reserved.
//

#import "HLPThirdScreenViewController.h"

@interface HLPThirdScreenViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *addressButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end

@implementation HLPThirdScreenViewController
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion mapRegion;
    mapRegion.center = mapView.userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.005;
    mapRegion.span.longitudeDelta = 0.005;
    
    [mapView setRegion:mapRegion animated: YES];
    [[HLPPosition sharedHLPPositionManager] setCoordinates:userLocation.location.coordinate];
    [self.spinner startAnimating];
    [[NSNotificationCenter defaultCenter]
                                            addObserver:self
                                            selector:@selector(setButtonTitle)
                                            name:@"Geocoding Done"
                                            object:nil];
}
- (IBAction)cancellCall:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)setButtonTitle
{
    [self.addressButton setTitle:[[HLPPosition sharedHLPPositionManager] address] forState:UIControlStateNormal];
    [self.spinner stopAnimating];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _mapView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)awakeFromNib
{
    [self.navigationItem setHidesBackButton:YES];
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
