//
//  HLPPosition.m
//  HELP
//
//  Created by WildSpirit on 17.05.14.
//  Copyright (c) 2014 WildSpirit. All rights reserved.
//

#import "HLPPosition.h"

#import "HLPSecondScreenViewController.h"

@interface HLPPosition ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;

@property (nonatomic, weak) HLPSecondScreenViewController * myController;

@end

@implementation HLPPosition

static HLPPosition *hLPPosition = nil;

-(void)registerView:(UIViewController *)viewC
{
    self.myController = (HLPSecondScreenViewController *) viewC;
}

+ (instancetype)sharedHLPPositionManager
{
    static HLPPosition *sharedHLPPosition = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHLPPosition = [[self alloc] init];
    });
    return sharedHLPPosition;
}

- (id)init {
    if (self = [super init]) {

    }
    return self;
}

-(void)findCurrentLocation
{
    self.locationManager = [[CLLocationManager alloc] init];
    if ( [CLLocationManager locationServicesEnabled])
    {
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        [_locationManager startUpdatingLocation];
    }
    
    self.currentLocation = [_locationManager location];
    
    CLLocationCoordinate2D coordinate = [_currentLocation coordinate];
    NSString *str=[[NSString alloc] initWithFormat:@" latitude:%f longitude:%f",coordinate.latitude,coordinate.longitude];
    NSLog(@"%@",str);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.currentLocation = newLocation;
    
    CLLocationCoordinate2D coordinate = [_currentLocation coordinate];
    NSString *str=[[NSString alloc] initWithFormat:@" latitude:%f longitude:%f",coordinate.latitude,coordinate.longitude];
    NSLog(@"%@",str);
    
    if(self.myController) {
        [self.myController didUpdateToLocation:newLocation];
    }
//    currentLat =  newLocation.coordinate.latitude;
//    currentLong =  newLocation.coordinate.longitude;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}



@end

