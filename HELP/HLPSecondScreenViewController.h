//
//  HLPSecondScreenViewController.h
//  HELP
//
//  Created by WildSpirit on 17.05.14.
//  Copyright (c) 2014 WildSpirit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "HLPPosition.h"

@interface HLPSecondScreenViewController : UIViewController

-(void) didUpdateToLocation:(CLLocation *)newLocation;

@end
