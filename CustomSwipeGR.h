//
//  CustomSwipeGR.h
//  MusicHeaven
//
//  Created by 梁 黄 on 12-12-26.
//  Copyright (c) 2012年 ABC. All rights reserved.
//

/**************************************************
 **************************************************
 
 http://book.2cto.com/201208/2138.html
 问题
 苹果公司提供了一系列基本的手势识别器，可是如果我们有进一步的要求，想识别更加复杂的手势怎么办呢？
 解决方案
 苹果公司从iOS 3.2开始引入了手势识别器，这对触摸识别的需求来说是最佳的解决方案。手势识别器很好用，我们不再需要编写冗长代码来管理触摸输入的各个阶段。对于基本的手势，如点击（tap）、捏夹（pinch）、旋转（rotate）、轻拂（swipe）、拖拽（pan）以及长按（long press），都有可供使用的识别器。但如果想进一步识别更加复杂的手势，比如划圆圈，就需要构建自己的手势识别器。
 我们从抽象类UIGestureRecognizer派生一个新的PRPCircleGestureRecognizer类，但需要包含UIKit/UIGestureRecognizerSubclass.h，因为这个文件声明了我们所需的额外的方法与属性。我们还需要决定让手势识别器是单次的（discrete）还是连续的（continuous）。单次的识别器仅当手势被完全识别时才触发委托动作，而连续的手势识别器对于其认为有效的每个触摸事件都会触发委托动作。
 如何选择合适的识别器类型，取决于我们想如何识别圆。每个触摸点都必须接近圆周，当然允许有一定偏差。可惜圆的圆心和半径我们都不知道，因此圆周的位置也不知道。要解决这个问题，就必须保存每个触摸点的位置，直到手势结束，这样我们才能用手势的极值点来算出直径，并确定圆心的位置和半径。所以圆手势识别器只能是单次的，因为只有当用户的手势结束之后才能对触摸点作检验。
 基类处理所有触摸并对委托动作做必要的回调，因此在我们实现的每个委托方法中，必须包含对Super方法的调用。基类所监视的用于管理识别过程的基本状态机同样非常重要。对于单次的识别器，state属性只能设置为以下状态之一[1]：
 q  UIGestureRecognizerStatePossible
 q  UIGestureRecognizerStateRecognized
 q  UIGestureRecognizerStateFailed
 UIGestureRecognizerStatePossible是初始状态，表明识别过程在执行当中。如果识别成功，那么state属性将设为UIGestureRecognizerStateRecognized，然后会调用委托动作选择器。如果过程中发现有任何一个触摸点位于算出的圆的范围之外，state属性将设为UIGestureRecognizerStateFailed，同时触发对reset方法的调用，用以对过程重新初始化并等待新的触摸序列。
 CircleGestureRecognizer/PRPCircleGestureRecognizer.m
 - (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
 [super touchesBegan:touches withEvent:event];
 if ([self numberOfTouches] != 1) {
 self.state = UIGestureRecognizerStateFailed;
 return;
 }
 self.points = [NSMutableArray array];
 CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
 lowX = touchPoint;
 lowY = lowX;
 if (self.deviation == 0) self.deviation = 0.4;
 moved = NO;
 }
 touchesBegan:withEvent:方法起到初始器的作用，并实例化保存触摸点的可变数组。然后添加第一个触摸点，并把lowX和lowY设为当前点，以后就可以用它们进行最长线段的计算。如果deviation属性还没有设定，就赋以默认值。
 CircleGestureRecognizer/PRPCircleGestureRecognizer.m
 - (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
 [super touchesMoved:touches withEvent:event];
 if ([self numberOfTouches] != 1) {
 self.state = UIGestureRecognizerStateFailed;
 }
 if (self.state == UIGestureRecognizerStateFailed) return; 
 
 CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
 
 if (touchPoint.x > highX.x) highX = touchPoint;
 else if (touchPoint.x < lowX.x) lowX = touchPoint;
 if (touchPoint.y > highY.y) highY = touchPoint;
 else if (touchPoint.y < lowY.y) lowY = touchPoint;
 [self.points addObject:[NSValue valueWithCGPoint:touchPoint]];
 moved = YES;
 }
 对于追踪到的每个点，都会调用touchesMoved:withEvent:方法。不允许多点触摸，如果检测到多点触摸，state属性就设为UIGestureRecognizerStateFailed。在这个阶段，因为圆周还不确定，无法对触摸点作检验，所以把它添加到points数组。要计算直径，需要确定x轴与y轴方向的边界点。如果触摸点超出了现有的边界点，就把边界点的值重置为触摸点。为了避免把单一点识别为圆，我们把moved的布尔值设置为YES，这表示touchesMoved:withEvent:方法至少调用了一次。
 CircleGestureRecognizer/PRPCircleGestureRecognizer.m
 - (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
 [super touchesEnded:touches withEvent:event];
 if (self.state == UIGestureRecognizerStatePossible) {
 if (moved && [self recognizeCircle]) {
 self.state = UIGestureRecognizerStateRecognized;
 } else {
 self.state = UIGestureRecognizerStateFailed;
 }
 }
 }
 touchesEnded:withEvent:方法只需要确认触摸点移动过，然后调用recognizeCircle方法执行实际的检验。
 CircleGestureRecognizer/PRPCircleGestureRecognizer.m
 - (BOOL) recognizeCircle { 
 CGFloat tempRadius;
 CGPoint tempCenter;
 CGFloat xLength = distanceBetweenPoints(highX, lowX);
 CGFloat yLength = distanceBetweenPoints(highY, lowY);
 if (xLength > yLength) {
 tempRadius = xLength/2;
 tempCenter = CGPointMake(lowX.x + (highX.x-lowX.x)/2,
 lowX.y + (highX.y-lowX.y)/2);
 } else {
 tempRadius = yLength/2;
 tempCenter = CGPointMake(lowY.x + (highY.x-lowY.x)/2,
 lowY.y + (highY.y-lowY.y)/2);
 }
 CGFloat deviant = tempRadius * self.deviation;
 
 CGFloat endDistance =
 distanceBetweenPoints([[self.points objectAtIndex:0] CGPointValue],
 [[self.points lastObject] CGPointValue]);
 if (endDistance > deviant*2) {
 return NO;
 }
 
 for (NSValue *pointValue in self.points) {
 CGPoint point = [pointValue CGPointValue];
 CGFloat pointRadius = distanceBetweenPoints(point, tempCenter);
 if (abs(pointRadius - tempRadius) > deviant) {
 return NO;
 }
 }
 self.radius = tempRadius;
 self.center = tempCenter;
 return YES;
 }
 recognizeCircle方法计算存储在边界点变量lowX、highX、lowY和highY中的触摸点之间的距离，取最长的距离为直径。确定了直径之后，就很容易算出圆心与半径，然后根据半径与deviation属性算出偏差值。为保证识别的是整圆，触摸的第一点与最后一点不应距离太远（偏差值的两倍）；如果距离太远，state属性会设置为UIGestureRecognizerStateFailed。points数组中的每个点都会被检验，方法是保证点与圆心的距离在半径加减偏差之间。如果所有的点都通过了检验，就设置radius与center属性，然后返回YES，表示成功。这之后touchesEnded: withEvent:方法把state属性设置为UIGestureRecognizerStateRecognized。
 成功的时候，基类的代码会调用在手势识别器实例化时指定的委托动作选择器，在这里就是mainViewController.m中的circleFound方法。在我们的例子中，会在与识别器关联的UIView中根据半径大小与识别的圆的位置绘制一张笑脸。
 尽管本章的代码仅限于识别圆形手势，但读者对它稍作修改，还可以识别其他类型的手势。
 
 [1]   连续的识别器实际上需要更多的状态。状态的完整清单请参考Apple.com上的“iPad开发者指南”，或者参考Gesture Recognizer相关的文章。——译者注
 ************************************************************
 ************************************************************/

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

typedef enum {
    DirectionUnknown = 0,
    DirectionLeft,
    DirectionRight
} Direction;

@interface CustomSwipeGR : UIGestureRecognizer

@property (assign) id target;

@property (assign) CGPoint curSwipeStart;
@property (assign) Direction direction;


@end
