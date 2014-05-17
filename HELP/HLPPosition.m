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
@property (nonatomic, strong) CLGeocoder *geocoder;

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

- (void)setCoordinates:(CLLocationCoordinate2D)coordinates
{
    _coordinates = coordinates;
    if (!self.geocoder) {
        self.geocoder = [[CLGeocoder alloc] init];
    }
    [_geocoder
     reverseGeocodeLocation:[[[CLLocation alloc] init] initWithLatitude:coordinates.latitude longitude:coordinates.longitude]
     completionHandler:^(NSArray *placemarks, NSError *error) {
         if (placemarks) {
             NSDictionary *dictionary = [(CLPlacemark *) placemarks[0] addressDictionary];
             //NSString *house = [[NSString alloc] initWithString:dictionary[@"subThoroughfare"]];
             if (dictionary[@"Street"] && dictionary[@"SubThoroughfare"]) {
                 _street = [[NSString alloc] initWithString:dictionary[@"Street"]];
                 _house = [[NSString alloc] initWithString:dictionary[@"SubThoroughfare"]];
             }
             self.address = [[NSString alloc] initWithString:dictionary[@"Street"]];
             [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"Geocoding Done" object:self.address]];
         }
     }];
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
    [self requestAddress];
    
}

- (void)requestAddress
{
    GMSGeocoder *geocoder = [GMSGeocoder geocoder];
    [geocoder reverseGeocodeCoordinate:self.coordinates
                     completionHandler:^(GMSReverseGeocodeResponse *response, NSError *error) {
                         if (response.firstResult) {
                             
                         }
                     }];
    
    // NSLog(self.address);
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

