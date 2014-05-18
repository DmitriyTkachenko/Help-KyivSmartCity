//
//  HLPFirstAidViewController.m
//  HELP
//
//  Created by Vladislav on 5/18/14.
//  Copyright (c) 2014 WildSpirit. All rights reserved.
//

#import "HLPFirstAidViewController.h"

@interface HLPFirstAidViewController ()

@end

@implementation HLPFirstAidViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Create the data model
    _pageTitles = @[@"Проверьте, в сознании ли ребёнок", @"Положите больного на спину", @"Освободите дыхательные пути", @"Попробуйте сделать вентиляцию"];
    _pageImages = @[@"step1.png", @"step2.png", @"step3.png", @"step4.png"];
    _pageContents = @[@"Нежно нажмите и потрясите за плечи, чтобы определить, в сознании ли ребёнок.", @"Если больной лежит лицом в низ, положите его на спину. Делайте это поддерживая голову, шею и живот, не перекручивая.", @"Надавите на лоб и осторожно другой рукой поднимите подбородок. Проследите, как поднимается и опускается грудная клетка. Послушайте дыхание.", @"Поддерживая голову так, чтобы дыхательные пути были освобождены, зажмите нос большим и указательным пальцами. Сделайте два глубоких вдоха."];
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HLPFirstAidPageViewController"];
    self.pageViewController.dataSource = self;
    
    HLPFirstAidPageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startWalkthrough:(id)sender {
    HLPFirstAidPageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}

- (HLPFirstAidPageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    HLPFirstAidPageContentViewController *hLPFirstAidPageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HLPFirstAidPageContentViewController"];
    hLPFirstAidPageContentViewController.imageFile = self.pageImages[index];
    hLPFirstAidPageContentViewController.titleText = self.pageTitles[index];
    hLPFirstAidPageContentViewController.contentTextString = self.pageContents[index];
    hLPFirstAidPageContentViewController.pageIndex = index;
    
    return hLPFirstAidPageContentViewController;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((HLPFirstAidPageContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((HLPFirstAidPageContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageTitles count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageTitles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}


@end
