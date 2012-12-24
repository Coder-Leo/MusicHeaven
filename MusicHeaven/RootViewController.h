//
//  RootViewController.h
//  MusicHeaven
//
//  Created by 梁 黄 on 12-12-20.
//  Copyright (c) 2012年 ABC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModal.h"
#import <QuartzCore/QuartzCore.h>
#import "ContentsViewController.h"


@interface RootViewController : UIViewController<UIGestureRecognizerDelegate, UIWebViewDelegate, ContentsViewControllerDataSource>

@property (nonatomic, strong) DataModal *data;

//@property (nonatomic, strong) LoadingBackgroundView *loadingView;

@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicator;

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIWebView *webViewNew;

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeLeft;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeRight;
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;

@property (nonatomic, assign) NSUInteger currentPageNumber;         //当前页码
@property (nonatomic, assign) NSUInteger indexOfSpecifiedColume;    //当前专辑序号
@property (nonatomic, assign) NSUInteger indexOfFileInSpecifiedColume;    //当前专辑中的文件序号
@property (nonatomic, assign) NSUInteger allFilesCounted;           //总页数
@property (nonatomic, assign) NSUInteger allColumnsCounted;         //总栏目数

@property (nonatomic, assign) BOOL isShowNavBar;

@property (nonatomic, strong) ContentsViewController *contentsVC;
@property (nonatomic, strong) UIPopoverController *popoverContentsVC;


- (void)swipeToLeft;
- (void)swipeToRight;
- (void)showsOrHidesBar;

- (NSURLRequest *)getRequestWithColumnIndex:(NSUInteger)columnIndex WithDataIndex:(NSInteger)index;

- (void) animationDidStop;

- (NSUInteger)getIndexOfColumn;
- (NSUInteger)getIndexOfFileInSpecifiedColumn;

- (void)popoverContentsMenu:(id)sender;
- (void)playButtonPressed:(id)sender;
- (void)settingButtonPressed:(id)sender;
- (void)backButtonPressed:(id)sender;

@end
