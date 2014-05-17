//
//  HLPServerManipulator.m
//  HELP
//
//  Created by Vladislav on 5/17/14.
//  Copyright (c) 2014 WildSpirit. All rights reserved.
//

#import "HLPServerManipulator.h"

@implementation HLPServerManipulator
{
    NSMutableData * mutableData;
}

-(void)registerRequestWithName:(NSString *)name Phone:(NSString *)phoneNumber
{
    NSString *post = [NSString stringWithFormat:@"name=%@&phone=%@", [self urlEncodeValue: name], [self urlEncodeValue: phoneNumber]];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://www.nowhere.com/sendFormHere.php"]];
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
    NSLog(@"Response : %@", responseStringWithEncoded);
    
    // You can do your functions here. If your repines is in XML you have to parse the response using NSXMLParser. If your response in JSON you have use SBJSON.
}

- (NSString *)urlEncodeValue:(NSString *)str
{
    NSString *result = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, NULL, CFSTR("?=&+"), kCFStringEncodingUTF8));
    return result;
}

@end
