//
//  HLPPosition.m
//  HELP
//
//  Created by WildSpirit on 17.05.14.
//  Copyright (c) 2014 WildSpirit. All rights reserved.
//

#import "HLPPosition.h"

@interface HLPPosition ()
{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}
@end

@implementation HLPPosition

static HLPPosition *hLPPosition = nil;

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
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    if ([locationManager locationServicesEnabled])
    {
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        [locationManager startUpdatingLocation];
    }
    
    
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    NSString *str=[[NSString alloc] initWithFormat:@" latitude:%f longitude:%f",coordinate.latitude,coordinate.longitude];
    NSLog(@"%@",str);
    
    
}

-(void) update
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    currentLocation = newLocation;
//    currentLat =  newLocation.coordinate.latitude;
//    currentLong =  newLocation.coordinate.longitude;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}



@end

