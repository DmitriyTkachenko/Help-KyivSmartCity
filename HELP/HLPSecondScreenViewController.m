//
//  HLPThirdScreenViewController.m
//  HELP
//
//  Created by WildSpirit on 17.05.14.
//  Copyright (c) 2014 WildSpirit. All rights reserved.
//

#import "HLPSecondScreenViewController.h"

#import "HLPReasonsViewController.h"

@interface HLPSecondScreenViewController () <MKMapViewDelegate>
{
    NSMutableData * mutableData;
    BOOL alertWasShown;
    BOOL wasSent;
    NSString * ticketID;
    NSTimer * countdownTimer;
    int secondsRemaining;
}

@property (weak, nonatomic) IBOutlet MKMapView * mapView;
@property (weak, nonatomic) IBOutlet UIButton * addressButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView * spinner;
@property (weak, nonatomic) IBOutlet UILabel * countdown;
@property (weak, nonatomic) IBOutlet UITextView *callProcessedText;

@end

@implementation HLPSecondScreenViewController

- (IBAction)carArrived:(id)sender
{
    NSString * token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    NSString *post = [NSString stringWithFormat:@"token=%@&ticketId=%@", [self urlEncodeValue: token], [self urlEncodeValue: ticketID] ];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://tilastserver.pp.ua:3000/api/closeTicket"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if ( connection )
    {
        mutableData = [[NSMutableData alloc] init];
        wasSent = YES;
        
        [self setSecondsRemaining:0];
    }

}

- (void)sendCoordinateData
{
    if (wasSent)
        return;
    
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
    if ( connection )
    {
        mutableData = [[NSMutableData alloc] init];
        wasSent = YES;
    }
}

-(void)timeRequest
{
    NSString * token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString * lat = [NSString stringWithFormat:@"%f", [HLPPosition sharedHLPPositionManager].coordinates.latitude];
    NSString * lon = [NSString stringWithFormat:@"%f", [HLPPosition sharedHLPPositionManager].coordinates.longitude];
    
    NSString *post = [NSString stringWithFormat:@"token=%@&ticketId=%@", [self urlEncodeValue: token],[self urlEncodeValue: ticketID] ];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://tilastserver.pp.ua:3000/api/supposedTime"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if ( connection )
    {
        mutableData = [[NSMutableData alloc] init];
//        wasSent = YES;
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
        ticketID = dictionary[@"ticketId"];
    }
    else if ([dictionary[@"status"] isEqualToString:@"time"])
    {
        NSString * timeStr = dictionary[@"supposedTime"];
        if ( [timeStr intValue]) {
            [self setSecondsRemaining:[timeStr intValue]];
            [self countdownTimer];
        }
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
    wasSent = NO;
    
//    [self setSecondsRemaining:30];
//    [self countdownTimer];
    if ([[self.addressButton titleForState:UIControlStateNormal] isEqualToString:@"Определение адреса..."]) {
        [self.spinner startAnimating];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    if(wasSent) {
        [self timeRequest];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Geocoding Done" object:nil];
}

- (void)awakeFromNib
{
    [self.navigationItem setHidesBackButton:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"");
    if ([[segue identifier] isEqualToString:@"reasons"])
    {
        // Get reference to the destination view controller
        HLPReasonsViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        NSLog(@"ticket:%@", ticketID);
        [vc setTiketID:ticketID];
    }
}

- (void)updateCounter:(NSTimer *)theTimer {
    if(secondsRemaining > 0 ){
        secondsRemaining -- ;
        int minutes = (secondsRemaining % 3600) / 60;
        int seconds = (secondsRemaining % 3600) % 60;
        self.countdown.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    }
    else {
        self.countdown.text = [NSString stringWithFormat:@"%02d:%02d", 0, 0];
    }
}

- (void)countdownTimer {
    countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
}

- (void)setSecondsRemaining:(int)seconds {
    secondsRemaining = seconds;
    self.callProcessedText.text = [NSString stringWithFormat:@"Машина отправлена. Ориентировочное время прибытия:"];
    self.callProcessedText.textAlignment = NSTextAlignmentCenter;
}
    
@end
    
