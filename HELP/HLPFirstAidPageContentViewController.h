//
//  HLPFirstAidPageContentViewController.h
//  HELP
//
//  Created by WildSpirit on 18.05.14.
//  Copyright (c) 2014 WildSpirit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HLPFirstAidPageContentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentText;
@property (weak, nonatomic) IBOutlet UIButton *returnToInfoButton;

@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *contentTextString;
@property NSString *imageFile;
@end
