//
//  HLPSmsViewController.m
//  HELP
//
//  Created by Vladislav on 5/17/14.
//  Copyright (c) 2014 WildSpirit. All rights reserved.
//

#import "HLPSmsViewController.h"

@interface HLPSmsViewController ()
{
    NSMutableData * mutableData;
}
@property (weak, nonatomic) IBOutlet UITextField *codeField;

@end

@implementation HLPSmsViewController

- (IBAction)confirmTouched:(id)sender
{
    NSString * name = [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
    
    NSString *post = [NSString stringWithFormat:@"phone=%@&activationCode=%@", [self urlEncodeValue: name], [self urlEncodeValue: self.codeField.text]];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://tilastserver.pp.ua:3000/api/activate"]];
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
    NSString *responseStringWithEncoded = [[NSString alloc] initWithData: mutableData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", responseStringWithEncoded);
    
    NSError * error;
    //    NSData * data = [@"{\"status\":\"asd\"}" dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:mutableData options:kNilOptions error:&error];
    
    if(error)
    {
        NSLog(@"fuckup %@", [error localizedDescription]);
    }
    
    NSLog(@"Response : %@", dictionary);
    
    [[NSUserDefaults standardUserDefaults] setObject:dictionary[@"token"] forKey:@"token"];
    
//    if([dictionary[@"status"] isEqualToString:@"waiting for sms"])
//    {
//        // segue
//        [self performSegueWithIdentifier:@"sms" sender:nil];
//    }
    
    // You can do your functions here. If your repines is in XML you have to parse the response using NSXMLParser. If your response in JSON you have use SBJSON.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"sms"])
    {
        //        TranslationQuizAssociateVC *translationQuizAssociateVC = [segue destinationViewController];
        //        translationQuizAssociateVC.nodeID = self.nodeID; //--pass nodeID from ViewNodeViewController
        //        translationQuizAssociateVC.contentID = self.contentID;
        //        translationQuizAssociateVC.index = self.index;
        //        translationQuizAssociateVC.content = self.content;
    }
}

- (NSString *)urlEncodeValue:(NSString *)str
{
    NSString *result = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, NULL, CFSTR("?=&+"), kCFStringEncodingUTF8));
    return result;
}

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
