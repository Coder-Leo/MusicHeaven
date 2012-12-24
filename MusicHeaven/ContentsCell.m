//
//  ContentsCell.m
//  MusicHeaven
//
//  Created by user on 12-12-24.
//  Copyright (c) 2012年 ABC. All rights reserved.
//

#import "ContentsCell.h"

@implementation ContentsCell

@synthesize columnImageView = _columnImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.columnImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
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
    
}

@end
