//
//  HLPThirdScreenViewController.m
//  HELP
//
//  Created by WildSpirit on 17.05.14.
//  Copyright (c) 2014 WildSpirit. All rights reserved.
//

#import "HLPSecondScreenViewController.h"

@interface HLPSecondScreenViewController () <MKMapViewDelegate>
{
    NSMutableData * mutableData;
    BOOL alertWasShown;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *addressButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation HLPSecondScreenViewController

- (void)sendCoordinateData
{
    NSString * token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString * lat = [NSString stringWithFormat:@"%f", [HLPPosition sharedHLPPositionManager].coordinates.latitude];
    NSString * lon = [NSString stringWithFormat:@"%f", [HLPPosition sharedHLPPositionManager].coordinates.longitude];
    
    NSString *post = [NSString stringWithFormat:@"token=%@&longitude=%@&latitude=%@", [self urlEncodeValue: token], [self urlEncodeValue: lon], [self urlEncodeValue: lat] ];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://tilastserver.pp.ua:3000/api/getAmbulance"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if( connection )
    {
        mutableData = [[NSMutableData alloc] init];
    }
}

#pragma mark -
#pragma mark NSURLConnection delegates

-(void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    [mutableData setLength:0];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [mutableData appendData:data];
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //    [mutableData release];
    //    [connection release];
    
    // If we get any connection error we can manage it here…
    //    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@”Alert” message:@”No Network Connection” delegate:self cancelButtonTitle:nil otherButtonTitles:@”OK”,nil];
    //    [alertView show];
    //    [alertView release];
    
    //    return;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError * error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:mutableData options:kNilOptions error:&error];
    
    if(error)
    {
        NSLog(@"fuckup %@", [error localizedDescription]);
    }
    
    NSLog(@"Response : %@", dictionary);
    
    if ([dictionary[@"status"] isEqualToString:@"we have got your ticket"] && !alertWasShown)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Скорая помощь вызвана" message:@"Ваш запрос поступил диспетчеру. Спасибо, что спасаете жизни!" delegate:self cancelButtonTitle:@"ОК" otherButtonTitles:nil, nil];
        [alert show];
        alertWasShown = YES;
    }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion mapRegion;
    mapRegion.center = mapView.userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.005;
    mapRegion.span.longitudeDelta = 0.005;
    
    [mapView setRegion:mapRegion animated: YES];
    [[HLPPosition sharedHLPPositionManager] setCoordinates:userLocation.location.coordinate];
    [[NSNotificationCenter defaultCenter]
                                            addObserver:self
                                            selector:@selector(processUpdatedAddress)
                                            name:@"Geocoding Done"
                                            object:nil];
    
}

- (NSString *)urlEncodeValue:(NSString *)str
{
    NSString *result = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, NULL, CFSTR("?=&+"), kCFStringEncodingUTF8));
    return result;
}

- (IBAction)cancellCall:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)setButtonTitle
{
    [self.addressButton setTitle:[[HLPPosition sharedHLPPositionManager] address] forState:UIControlStateNormal];
    [self.spinner stopAnimating];
}

- (void)processUpdatedAddress
{
    [self setButtonTitle];
    [self sendCoordinateData];
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
    alertWasShown = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.spinner startAnimating];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Geocoding Done" object:nil];
}

- (void)awakeFromNib
{
    [self.navigationItem setHidesBackButton:YES];
}

@end
