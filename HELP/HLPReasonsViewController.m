//
//  HLPReasonsViewController.m
//  HELP
//
//  Created by Vladislav on 5/18/14.
//  Copyright (c) 2014 WildSpirit. All rights reserved.
//

#import "HLPReasonsViewController.h"

#import "HLPFirstAidViewController.h"

@interface HLPReasonsViewController ()
{
    NSMutableData * mutableData;
    
    NSMutableArray * syms;
}

@property (nonatomic, strong) NSMutableArray * symptomes;

@end

@implementation HLPReasonsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//    self.navigationItem.rightBarButtonItem = self.n;
    
    UIBarButtonItem *barDoneButton = [[UIBarButtonItem alloc] initWithTitle:@"Дальше" style:UIBarButtonItemStylePlain target:self action:@selector(nextTouched:)];
    
    [self.navigationItem setRightBarButtonItem:barDoneButton];
    
    self.symptomes = [NSMutableArray arrayWithObjects: @"Критическое состояние", @"Больной – ребёнок", @"Психоз", @"Роды", @"Отравление", @"Ожог", @"Затруднение дыхания", @"Кровотечение", @"Политравма", nil];
    
    
}

- (IBAction)nextTouched:(id)sender
{
    [self sendSymtomes];
    [self performSegueWithIdentifier:@"firstAid" sender:nil];
}

-(void)sendSymtomes
{
    NSString * token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    syms = [NSMutableArray array];
    
    NSString * sentStr = @"";
    for(NSIndexPath * path in self.tableView.indexPathsForSelectedRows)
    {
        NSString * str = [NSString stringWithFormat:@"%@", self.symptomes[path.row] ];
        [syms addObject:str];
        sentStr = [sentStr stringByAppendingString:[NSString stringWithFormat:@"'%@', ", str]];
    }
    sentStr = [NSString stringWithFormat:@"%@%@%@", @"[", sentStr, @"]"];
    
    NSString *post = [NSString stringWithFormat:@"token=%@&ticketId=%@&symptomes=%@", [self urlEncodeValue: token], [self urlEncodeValue: self.tiketID], [self urlEncodeValue: sentStr] ];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://tilastserver.pp.ua:3000/api/additionalInfo"]];
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
    
//    if ([dictionary[@"status"] isEqualToString:@"we have got your ticket"] && !alertWasShown)
//    {
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Скорая помощь вызвана" message:@"Ваш запрос поступил диспетчеру. Спасибо, что спасаете жизни!" delegate:self cancelButtonTitle:@"ОК" otherButtonTitles:nil, nil];
//        [alert show];
//        alertWasShown = YES;
//        ticketID = dictionary[@"ticketID"];
//    }
}


- (NSString *)urlEncodeValue:(NSString *)str
{
    NSString *result = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, NULL, CFSTR("?=&+"), kCFStringEncodingUTF8));
    return result;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.symptomes count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"symptomeCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"symptomeCell"];
    }
    
    cell.textLabel.text = self.symptomes[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@" sel:%@", tableView.indexPathsForSelectedRows);
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@" desel:%d", indexPath.row);
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"firstAid"])
    {
        // Get reference to the destination view controller
        HLPFirstAidViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
//        vc.symptomes = @[@"Over Fuck", @"Programmer", @"Koala"];
        vc.symptomes = syms;
    }
}


@end
