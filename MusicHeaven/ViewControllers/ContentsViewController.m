//
//  ContentsViewController.m
//  MusicHeaven
//
//  Created by user on 12-12-24.
//  Copyright (c) 2012年 ABC. All rights reserved.
//

#import "ContentsViewController.h"



@interface ContentsViewController ()

@end

@implementation ContentsViewController

@synthesize dataSource          = _dataSource;

@synthesize allTrumbsArray      = _allTrumbsArray;
@synthesize contentsTableView   = _contentsTableView;
@synthesize allColumnsCounted   = _allColumnsCounted;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.contentsTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _contentsTableView.dataSource = self;
        _contentsTableView.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.contentsTableView setFrame:self.view.frame];
    [self.view addSubview:self.contentsTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allColumnsCounted;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    static NSString *cellIdentifier = @"cell";
    ContentsCell *cell = [[ContentsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    if (!cell) 
    {
        cell = [self.contentsTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    NSUInteger specIndex = 0;
    
    if (row == 0) {
        specIndex = row;
    }else {
        specIndex =row + 1;
    }

//    if ([self allTrumbsArray])
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(getColumnTrumbsImageWithDataSource:)]) {
        self.allTrumbsArray = [self.dataSource getColumnTrumbsImageWithDataSource:self.dataSource];
        UIImage *trumbImage = [UIImage imageWithContentsOfFile:[_allTrumbsArray objectAtIndex:specIndex]];
        //        NSLog(@"===== %@",trumbImage);
        [[cell columnImageView] setImage:trumbImage];
    }  
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(swipeToFirstArticleOfSpecifiedColumn:)]) {
//        NSLog(@"-①- swipeToFirstArticleOfSpecifiedColumn %d",row);
        [self.dataSource swipeToFirstArticleOfSpecifiedColumn:row];
    }
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(dismissContentsViewController)]) {
        [self.dataSource dismissContentsViewController];
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HeaderForContentsTable *header = [[HeaderForContentsTable alloc]initWithFrame:CGRectZero];
    NSInteger aNumber = [self.allTrumbsArray count];
    
    NSString *headerImgPath = [self.allTrumbsArray objectAtIndex:aNumber - 2];
//    NSLog(@"① !!!%@",headerImgPath);
    UIImage *headerImage = [UIImage imageWithContentsOfFile:headerImgPath];
//    NSLog(@"② !!!%@",headerImage);
    [header.headerImageView setImage:headerImage];
  
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 144.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 377.0;
}

@end
