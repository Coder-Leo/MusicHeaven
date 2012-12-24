//
//  HeaderForContentsTable.m
//  MusicHeaven
//
//  Created by user on 12-12-25.
//  Copyright (c) 2012年 ABC. All rights reserved.
//

#import "HeaderForContentsTable.h"

@implementation HeaderForContentsTable

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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
    [self setFrame:CGRectMake(0, 0, 320, 200)];
    [self setBackgroundColor:[UIColor purpleColor]];
}

@end
