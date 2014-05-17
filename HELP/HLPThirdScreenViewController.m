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


@end

@implementation HLPThirdScreenViewController
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion mapRegion;
    mapRegion.center = mapView.userLocation.coordinate;
    mapRegion.span.latitudeDelta = 2;
    mapRegion.span.longitudeDelta = 2;
    
    [mapView setRegion:mapRegion animated: YES];
    //[HLPPosition sharedHLPPositionManager].coordinates = userLocation.location.coordinate;
    [[HLPPosition sharedHLPPositionManager] setCoordinates:userLocation.location.coordinate];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(setButtonTitle)
     name:@"Geocoding Done"
     object:nil];
}

- (void)setButtonTitle
{
    [self.addressButton setTitle:[[HLPPosition sharedHLPPositionManager] address] forState:UIControlStateNormal];
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
