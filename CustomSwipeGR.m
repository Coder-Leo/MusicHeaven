//
//  CustomSwipeGR.m
//  MusicHeaven
//
//  Created by 梁 黄 on 12-12-26.
//  Copyright (c) 2012年 ABC. All rights reserved.
//

#import "CustomSwipeGR.h"

#define MOVE_DISTANCE_REQUIRED 25

@implementation CustomSwipeGR

@synthesize target = _target;

@synthesize curSwipeStart;
@synthesize direction;


- (id)initWithTarget:(id)target action:(SEL)action
{
    self = [super initWithTarget:target action:action];
    
    if (self) {
        //TO DO
        self.target = target;
    }
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    UITouch *touch = [touches anyObject];
    self.curSwipeStart = [touch locationInView:self.view];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event 
{
    UITouch *touch = [touches anyObject];
    
    CGPoint swipingPoint = [touch locationInView:self.view];
    CGFloat movedDistanceX = swipingPoint.x - curSwipeStart.x;   //已滑动的水平距离
    CGFloat movedDistanceY = swipingPoint.y - curSwipeStart.y;   //已滑动的垂直距离
    
    CGFloat k = movedDistanceY / movedDistanceX;
    
    Direction curDirection;
    
    if (movedDistanceX < 0 && (fabs(k) >= 0) && (fabs(k) < 1)) 
    {
        curDirection = DirectionLeft;
    }else if (movedDistanceX > 0 && (fabs(k) >= 0) && (fabs(k) < 1)) 
    {
        curDirection = DirectionRight;
    }
    
    if (ABS(movedDistanceX) < MOVE_DISTANCE_REQUIRED) return;    //若滑动距离小于指定预设值 终止传递事件
    
    // Make sure we've switched directions
    
    if (self.direction == curDirection) {
        NSLog(@"self.direction = %d",self.direction);
    }
    
//    if (self.lastSwipeDirection == DirectionUnknown || (self.lastSwipeDirection == DirectionLeft && curDirection == DirectionLeft) || (self.lastSwipeDirection == DirectionRight && curDirection == DirectionRight)) {
//        
//        self.curSwipeStart = swipingPoint;
//        self.lastSwipeDirection = curDirection;
//        
//        if (self.state == UIGestureRecognizerStatePossible && movedDistanceX > MOVE_DISTANCE_REQUIRED) {
//            [self setState:UIGestureRecognizerStateEnded];
//        }
//    }
}

- (void)reset {
    
    self.curSwipeStart = CGPointZero;
//    self.direction = DirectionUnknown;
    if (self.state == UIGestureRecognizerStatePossible) {
        [self setState:UIGestureRecognizerStateFailed];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self reset];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self reset];
}

@end
