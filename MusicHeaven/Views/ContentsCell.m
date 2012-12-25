//
//  ContentsCell.m
//  MusicHeaven
//
//  Created by user on 12-12-24.
//  Copyright (c) 2012年 ABC. All rights reserved.
//

#import "ContentsCell.h"

#define ContentsCellFrame CGRectMake(0, 0, 320, 377)

@implementation ContentsCell 

@synthesize columnImageView = _columnImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.columnImageView = [[UIImageView alloc]initWithFrame:ContentsCellFrame];
        [_columnImageView setUserInteractionEnabled:YES];
        [_columnImageView setBackgroundColor:[UIColor blueColor]];
        [self.contentView addSubview:self.columnImageView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    [self.columnImageView setFrame:CGRectMake(0, 0, 320, 377)];
//    NSLog(@"-- -- -- %@",self.columnImageView.image);
//    [self.columnImageView setImage:[UIImage imageNamed:@"liebiao.png"]];
}

@end
