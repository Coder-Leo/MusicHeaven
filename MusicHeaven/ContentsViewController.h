//
//  ContentsViewController.h
//  MusicHeaven
//
//  Created by 梁 黄 on 12-12-24.
//  Copyright (c) 2012年 ABC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentsCell.h"

@interface ContentsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *contentsView;

@end
