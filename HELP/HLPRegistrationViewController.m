//
//  HLPRegistrationViewController.m
//  HELP
//
//  Created by Vladislav on 5/17/14.
//  Copyright (c) 2014 WildSpirit. All rights reserved.
//

#import "HLPRegistrationViewController.h"

#import "HLPServerManipulator.h"

@implementation HLPRegistrationViewController
{
    NSMutableData * mutableData;
}

- (IBAction)sendTouched:(id)sender
{
    NSString *post = [NSString stringWithFormat:@"name=%@&phone=%@", [self urlEncodeValue: self.nameField.text], [self urlEncodeValue: self.phoneField.text]];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://tilastserver.pp.ua:3000/api/register"]];
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

-(void)saveUserWithName:(NSString *)name andPhone:(NSString *)phone andToken:(NSString *)token
{
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"name"];
    [[NSUserDefaults standardUserDefaults] setObject:phone forKey:@"phone"];
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
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
    
    [self saveUserWithName:self.nameField.text andPhone:self.phoneField.text andToken:@""];
    
    if([dictionary[@"status"] isEqualToString:@"waiting for sms"])
    {
        // segue
        [self performSegueWithIdentifier:@"sms" sender:nil];
    }
    
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

@end
