//
//  HeaderForContentsTable.m
//  MusicHeaven
//
//  Created by user on 12-12-25.
//  Copyright (c) 2012年 ABC. All rights reserved.
//

#import "HeaderForContentsTable.h"

#define TableHeaderFrame CGRectMake(0, 0, 320, 144)

@implementation HeaderForContentsTable

@synthesize headerImageView     = _headerImageView;
@synthesize dismissContentsBtn  = _dismissContentsBtn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.headerImageView = [[UIImageView alloc]initWithFrame:TableHeaderFrame];
        [self addSubview:self.headerImageView];
        
        self.dismissContentsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dismissContentsBtn setBackgroundImage:[UIImage imageNamed:@"jiaochaanniu.png"] forState:UIControlStateNormal];
        [_dismissContentsBtn setBackgroundImage:[UIImage imageNamed:@"jiaochaanniuHighLighted.png"] forState:UIControlStateHighlighted];
        [_dismissContentsBtn setFrame:CGRectMake(270, 10, 40, 40)];
        [self addSubview:_dismissContentsBtn];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    NSLog(@"%@",NSStringFromSelector(_cmd));
//    [self setFrame:CGRectMake(0, 0, 320, 144)];
//    [self setBackgroundColor:[UIColor purpleColor]];
//    [self.headerImageView setImage:[UIImage imageNamed:@"biaotou.png"]];
    
}

@end
