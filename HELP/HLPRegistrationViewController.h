//
//  HLPRegistrationViewController.h
//  HELP
//
//  Created by Vladislav on 5/17/14.
//  Copyright (c) 2014 WildSpirit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLPRegistrationViewController : UIViewController <NSURLConnectionDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;

@end
