//
//  ContentsViewController.h
//  MusicHeaven
//
//  Created by user on 12-12-24.
//  Copyright (c) 2012年 ABC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentsCell.h"
#import "HeaderForContentsTable.h"

@class ContentsViewController;

@protocol ContentsViewControllerDataSource <NSObject>

- (NSArray *)getColumnTrumbsImageWithDataSource:(id)dataSource;

@end

@interface ContentsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) id<ContentsViewControllerDataSource> dataSource;

@property (nonatomic, strong) UITableView *contentsTableView;

@property (nonatomic, assign) NSUInteger allColumnsCounted;         //总栏目数

@end
