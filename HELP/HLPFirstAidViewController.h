//
//  HLPFirstAidViewController.h
//  HELP
//
//  Created by Vladislav on 5/18/14.
//  Copyright (c) 2014 WildSpirit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLPFirstAidPageContentViewController.h"

@interface HLPFirstAidViewController : UIViewController <UIPageViewControllerDataSource>

@property (nonatomic, strong) NSArray *symptomes;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;
@property (strong, nonatomic) NSArray *pageContents;

@end
