//
//  RootViewController.m
//  MusicHeaven
//
//  Created by 梁 黄 on 12-12-20.
//  Copyright (c) 2012年 ABC. All rights reserved.
//

#import "RootViewController.h"

#define PagePlayButtonFrame CGRectMake(668, 924, 44, 44)

@interface RootViewController ()

@end

@implementation RootViewController

@synthesize data                            = _data,
            webView                         = _webView,
            webViewNew                      = _webViewNew,
            loadingView                     = _loadingView,
            loadingIndicator                = _loadingIndicator,
            swipeLeft                       = _swipeLeft,
            swipeRight                      = _swipeRight,
            doubleTap                       = _doubleTap,
            currentPageNumber               = _currentPageNumber,
            indexOfSpecifiedColume          = _indexOfSpecifiedColume,
            indexOfFileInSpecifiedColume    = _indexOfFileInSpecifiedColume,
            allFilesCounted                 = _allFilesCounted,
            allColumnsCounted               = _allColumnsCounted,
            swipeDirection                  = _swipeDirection,
            isPlaying                       = _isPlaying,
            isShowNavBar                    = _isShowNavBar,
            popoverContentsVC               = _popoverContentsVC,
            contentsVC                      = _contentsVC,
            pagePlayerBtn                   = _pagePlayerBtn;

- (id)init
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    self = [super init];
    if (self) 
    {
        // Custom initialization
//        self.indexOfSpecifiedColume = 0;            //指定从第一个栏目读入
//        self.currentPageNumber = 0;      //当前页码，指定从第一个栏目的第一个文件读入
//        self.indexOfFileInSpecifiedColume   = 0;
        self.allFilesCounted = 0;
        
        self.isShowNavBar = YES;
        self.isPlaying = NO;
        
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        
//        NSInteger pageNumber = [[defaults objectForKey:@"currentPageNumber"] integerValue];
//        
//        NSLog(@"==-== %d",pageNumber);
//        
//        _currentPageNumber = pageNumber;
        
        //custom window
        
        if (!_data) {
            self.data = [DataModal defaultModal];
            
            self.allColumnsCounted = [_data.allPacksArray count];
        }
        
        int numberOfColumn = [_data.allPacksArray count];
        
        for (int i = 0; i < numberOfColumn; i++) {
            NSArray *column = [_data.allPacksArray objectAtIndex:i];
            
            int numberOfFilesInThisColume = [column count];
            
            _allFilesCounted += numberOfFilesInThisColume;      //得到所有栏目总共的文章个数
        }
        
        //***************   手势   ***************************
        //***************************************************
        self.swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeToLeft)];   //向左滑动
        [_swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
        
        self.swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeToRight)];     //向右滑动
        [_swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
        
//        self.swipeLeft = [[CustomSwipeGR alloc]initWithTarget:self action:@selector(swipeToLeft)];   //向左滑动
//        [_swipeLeft setDirection:DirectionLeft];
//        [_swipeLeft setCancelsTouchesInView:YES];
//        
//        self.swipeRight = [[CustomSwipeGR alloc]initWithTarget:self action:@selector(swipeToRight)];     //向右滑动
//        [_swipeRight setDirection:DirectionRight];
//        [_swipeRight setCancelsTouchesInView:YES];
        
        self.doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showsOrHidesBar)];
        _doubleTap.delegate = self;
        _doubleTap.cancelsTouchesInView = NO;
        
        [_doubleTap setNumberOfTapsRequired:2];
        [_doubleTap setNumberOfTouchesRequired:1];
        [_doubleTap setCancelsTouchesInView:NO];
        
//        NSLog(@"initWithNibName-----%f", self.view.frame.size.width);
//        NSLog(@"initWithNibName-----%f", self.view.frame.size.height);
        
        
        //*************** 网路视图 ***************************
        //***************************************************
        self.webView = [[UIWebView alloc]initWithFrame:self.view.frame];
        _webView.delegate = self;
        
        CGRect aRect =  _webView.frame;
        
        _webView.frame = CGRectOffset(aRect, 0, -20);
        
        [(UIScrollView *)[[_webView subviews] objectAtIndex:0] setBounces:NO];
        
        //读取时指示
        self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(284, 402, 200, 200)];
        _loadingView.layer.cornerRadius = 30.0;
//        _loadingView.layer.borderWidth = 1.0f;
        _loadingView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
//        _loadingView.center = self.view.center;
        
        //loading indicator view
        self.loadingIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(85, 85, 30, 30)];
        [_loadingIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
//        _loadingIndicator.center = _webView.center;
        [_loadingIndicator setHidesWhenStopped:YES];
        
        [_loadingView addSubview:self.loadingIndicator];
        
        [_webView addSubview:self.loadingView];
        
        [self.webView addGestureRecognizer:self.swipeLeft];
        [self.webView addGestureRecognizer:self.swipeRight];
        [self.webView addGestureRecognizer:self.doubleTap];
        
        [_webView scalesPageToFit]; 
        
        self.pagePlayerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pagePlayerBtn setFrame:PagePlayButtonFrame];
        [_pagePlayerBtn setBackgroundImage:[UIImage imageNamed:@"bofang.png"] forState:UIControlStateNormal];
        [_pagePlayerBtn addTarget:self action:@selector(pagePlayBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [_webView addSubview:self.pagePlayerBtn];
    }
    return self;
}



- (void)viewDidLoad
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor greenColor]];
 
    [self.navigationItem setHidesBackButton:YES];
    
    //******************** 导航按钮 *********************
    //**************************************************

    UIImage *bbiImage = [UIImage imageNamed:@"mulu.png"];
    UIImage *bbiImageHL = [UIImage imageNamed:@"muluHighLighted.png"];
    
    UIButton *contentsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [contentsBtn setImage:bbiImage forState:UIControlStateNormal];
    [contentsBtn setImage:bbiImageHL forState:UIControlStateHighlighted];
    [contentsBtn setShowsTouchWhenHighlighted:YES];
    [contentsBtn addTarget:self action:@selector(popoverContentsMenu:) forControlEvents:UIControlEventTouchUpInside];
    [contentsBtn setFrame:CGRectMake(8.0f, 2.0f, 40, 40)];
    
    UIImageView *leftBarBtnItemImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 2, 80, 40)];
    [leftBarBtnItemImageView setUserInteractionEnabled:YES];
    [leftBarBtnItemImageView addSubview:contentsBtn];
    
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc]initWithCustomView:leftBarBtnItemImageView];
    [self.navigationItem setLeftBarButtonItem:bbi];
    
    UIButton *playBtnOnNav = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *settingBtnOnNav = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *backBtnOnNav = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [playBtnOnNav setEnabled:YES];
    [playBtnOnNav setShowsTouchWhenHighlighted:YES];
    [settingBtnOnNav setEnabled:YES];
    [settingBtnOnNav setShowsTouchWhenHighlighted:YES];
    [backBtnOnNav setEnabled:YES];
    [backBtnOnNav setShowsTouchWhenHighlighted:YES];
    
    [playBtnOnNav addTarget:self action:@selector(playButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [settingBtnOnNav addTarget:self action:@selector(settingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [backBtnOnNav addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [backBtnOnNav setFrame:CGRectMake(0, 2, 40, 40)];
    [playBtnOnNav setFrame:CGRectMake(44, 2, 40, 40)];
    [settingBtnOnNav setFrame:CGRectMake(88, 2, 40, 40)];
    
    [backBtnOnNav setBackgroundImage:[UIImage imageNamed:@"fanhuijian.png"] forState:UIControlStateNormal];
    [backBtnOnNav setBackgroundImage:[UIImage imageNamed:@"fanhuijianHighLighted.png"] forState:UIControlStateHighlighted];
    
    [playBtnOnNav setBackgroundImage:[UIImage imageNamed:@"bofangjian.png"] forState:UIControlStateNormal];
    [playBtnOnNav setBackgroundImage:[UIImage imageNamed:@"bofangjianHighLighted.png"] forState:UIControlStateHighlighted];
    
    [settingBtnOnNav setBackgroundImage:[UIImage imageNamed:@"shezhijian.png"] forState:UIControlStateNormal];
    [settingBtnOnNav setBackgroundImage:[UIImage imageNamed:@"shezhijianHighLighted.png"] forState:UIControlStateHighlighted];
    
    UIImageView *rightNavBarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 150, 44)];
    [rightNavBarImageView setUserInteractionEnabled:YES];
    
    [rightNavBarImageView addSubview:playBtnOnNav];
    [rightNavBarImageView addSubview:settingBtnOnNav];
    [rightNavBarImageView addSubview:backBtnOnNav];
    
    UIBarButtonItem *rightNavBarBtnItem = [[UIBarButtonItem alloc]initWithCustomView:rightNavBarImageView];
    
    [[self navigationItem] setRightBarButtonItem:rightNavBarBtnItem];
    //***************** end 导航按钮 *********************
    //**************************************************

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    [super viewWillAppear:animated];
    
    [_webView loadRequest:[self getRequestWithColumnIndex:self.indexOfSpecifiedColume WithDataIndex:self.indexOfFileInSpecifiedColume]]; 
    [self.view addSubview:_webView];
}


#pragma mark - Gestures Methods

- (void)swipeToLeft
{    
    NSLog(@"--- %@",NSStringFromSelector(_cmd));
    
    if (self.webViewNew == nil && _currentPageNumber < _allFilesCounted -1) {
        NSLog(@"--- --- self.webViewNew == nil");
        self.webViewNew = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _webViewNew.delegate = self;
        [(UIScrollView *)[[_webViewNew subviews] objectAtIndex:0] setBounces:NO];
        [_webViewNew addSubview:self.loadingView];
        _webViewNew.scalesPageToFit = YES;
        [_webViewNew addSubview:self.pagePlayerBtn];
    }

    
    [self.webViewNew addGestureRecognizer:self.doubleTap];
    
    if (self.loadingView) {
        [self.webViewNew addSubview:self.loadingView];
//        NSLog(@"--- --- self.loadingView is exist!%@",self.loadingView);
    }
    
    if (_currentPageNumber < _allFilesCounted -1)
    {
        NSLog(@"_currentPageNumber < _allFilesCounted");
        
        _currentPageNumber +=1;
        self.indexOfSpecifiedColume = [self getIndexOfColumn];
        [self.webViewNew loadRequest:[self getRequestWithColumnIndex:[self getIndexOfColumn] WithDataIndex:[self getIndexOfFileInSpecifiedColumn]]];
        
        CGRect aRect = self.webView.frame;
        
        self.webViewNew.frame = CGRectOffset(aRect, 768, 0);
        [self.view addSubview:self.webViewNew];
        
        [UIView beginAnimations:NULL context:nil];
        [UIView setAnimationDuration:0.32];
        [UIView setAnimationDelegate:self];
        self.webView.frame = CGRectOffset(aRect, -768, 0);
        self.webViewNew.frame = CGRectOffset(aRect, 0, 0);
        [UIView setAnimationDidStopSelector:@selector(animationDidStop)];
        
        [UIView commitAnimations];
    }
    
}

- (void)swipeToRight
{
    NSLog(@"--- %@",NSStringFromSelector(_cmd));
    
    if (self.webViewNew == nil && _currentPageNumber > 0) {
        NSLog(@"--- self.webViewNew == nil");
        self.webViewNew = [[UIWebView alloc]init];
        _webViewNew.delegate = self;
        [_webViewNew addSubview:self.loadingView];
        [(UIScrollView *)[[_webViewNew subviews] objectAtIndex:0] setBounces:NO];
        _webViewNew.scalesPageToFit = YES;
        
        [_webViewNew addSubview:self.pagePlayerBtn];
    }
    
    [self.webViewNew addGestureRecognizer:self.doubleTap];
    
    if (self.loadingView) {
        [self.webViewNew addSubview:self.loadingView];
//        NSLog(@"--- --- self.loadingView is exist!%@",self.loadingView);
    }

    
    if (_currentPageNumber > 0)
    {
        NSLog(@"--- self.dataIndex > 1");
        
        _currentPageNumber -=1;
        
        self.indexOfSpecifiedColume = [self getIndexOfColumn];
        [self.webViewNew loadRequest:[self getRequestWithColumnIndex:[self getIndexOfColumn] WithDataIndex:[self getIndexOfFileInSpecifiedColumn]]];
        
        CGRect aRect = self.webView.frame;
        
        self.webViewNew.frame = CGRectOffset(aRect, -768, 0);
        [self.view addSubview:self.webViewNew];
        
        [UIView beginAnimations:NULL context:nil];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationDelegate:self];
        self.webView.frame = CGRectOffset(aRect, 768, 0);
        self.webViewNew.frame = CGRectOffset(aRect, 0, 0);
        [UIView setAnimationDidStopSelector:@selector(animationDidStop)];
        
        [UIView commitAnimations];
        
    }else{
        NSLog(@"_currentPageNumber = %d",_currentPageNumber);
//        [self.webView removeFromSuperview];
//        self.webView = nil;
//        self.webView = self.webViewNew;
//        self.webViewNew = nil;
        
//        [self.webView addGestureRecognizer:self.swipeLeft];
//        [self.webView addGestureRecognizer:self.swipeRight];
//        [self.webView addSubview:self.pagePlayerBtn];
    }  
}

- (void)showsOrHidesBar
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    if (_isShowNavBar) {
//        NSLog(@"hides bar");
        self.navigationController.navigationBarHidden = YES;
        _isShowNavBar = !_isShowNavBar;
    }else
    {
//        NSLog(@"shows bar");
        
        self.navigationController.navigationBarHidden = NO;
        _isShowNavBar = !_isShowNavBar;
    }
}

#pragma mark - Private Methods


- (void)animationDidStop
{
    NSLog(@"--- %@",NSStringFromSelector(_cmd));
    
    [self.webView removeFromSuperview];
    self.webView = nil;
    self.webView = self.webViewNew;
    self.webViewNew = nil;
    
    [self.webView addGestureRecognizer:self.swipeLeft];
    [self.webView addGestureRecognizer:self.swipeRight];
}


- (NSURLRequest *)getRequestWithColumnIndex:(NSUInteger)columnIndex WithDataIndex:(NSInteger)index
{
//    NSLog(@"--- %@",NSStringFromSelector(_cmd));
    
    NSString *path = [[self.data.allPacksArray objectAtIndex:columnIndex] objectAtIndex:index];
    
//    NSLog(@"--==--== %@", path);
    
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    
    return request;
}

- (NSUInteger)getIndexOfColumn
{
    NSMutableArray *numbersOfPageForAllColumnArr = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < _allColumnsCounted; i++) {
        NSUInteger totlePageNumberWithSpecifiedColumn = [[_data.allPacksArray objectAtIndex:i] count];      //计算每个栏目各有多少页
        NSNumber *aNumber = [NSNumber numberWithUnsignedInteger:totlePageNumberWithSpecifiedColumn];    //将每个栏目的页数存入number对象
        
        [numbersOfPageForAllColumnArr addObject:aNumber];  //将每个专辑的文件（页）数存入数组
    }
    
    NSUInteger pages = 0;
    
    for (int i = 0; i < [numbersOfPageForAllColumnArr count]; i++) 
    {
        NSUInteger totlePagesOfTheColumn = [[numbersOfPageForAllColumnArr objectAtIndex:i] integerValue];   //取出每个对应栏目的总页数
        pages +=totlePagesOfTheColumn;
        
        if (self.currentPageNumber + 1 > pages) {
//            break;        //如果当前页的页码大于所在栏目总页数，则进入下一栏目继续循环
        }
        else {
        return i;       //如果当前页的页码等于或者小于所在栏目总页数，则返回这个栏目的序号数
        }
        
    }

    return 0;
}

- (NSUInteger)getIndexOfFileInSpecifiedColumn
{
    NSMutableArray *numbersOfPageForAllColumnArr = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < _allColumnsCounted; i++) {
        NSUInteger totlePageNumberWithSpecifiedColumn = [[_data.allPacksArray objectAtIndex:i] count];      //得到每一个栏目的总页数
        NSNumber *aNumber = [NSNumber numberWithUnsignedInteger:totlePageNumberWithSpecifiedColumn];        //将得到每一个栏目的总页数存入number对象
        
        [numbersOfPageForAllColumnArr addObject:aNumber];  //将每个专辑的文件数对应的number对象存入数组
    }
    
    NSUInteger pages = 0;
    NSUInteger pagesWithoutPlus = 0;
//    NSUInteger pageNumberInSpecialColumn = 0;
    for (int i = 0; i < [numbersOfPageForAllColumnArr count]; i++) 
    {
        NSUInteger totlePagesOfTheColumn = [[numbersOfPageForAllColumnArr objectAtIndex:i] integerValue];
        pages +=totlePagesOfTheColumn;
        
        if (self.currentPageNumber + 1 > pages) {
            pagesWithoutPlus = pages;   //如果当前页页码大于这个栏目的的总页数
            //            break;
        }
        else {
            return (_currentPageNumber - pagesWithoutPlus); //如果当前页页码小于或者等于这个栏目的的总页数，返回该栏目的第N篇文章序号数
        }
        
    }
    return 0;
}


- (void)popoverContentsMenu:(id)sender
{
    if (self.contentsVC == nil) {
        self.contentsVC = [[ContentsViewController alloc]initWithNibName:nil bundle:nil];
        self.contentsVC.dataSource = self;

        NSLog(@" $ $ %@",_contentsVC.allTrumbsArray);
        _contentsVC.allColumnsCounted = self.allColumnsCounted;
    }
    
    if (self.popoverContentsVC == nil) {
        self.popoverContentsVC = [[UIPopoverController alloc]initWithContentViewController:self.contentsVC];
    }
    
    CGRect aRect = CGRectMake(10, 0, 85, 30);
    
    [_popoverContentsVC presentPopoverFromRect:aRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}


- (void)playButtonPressed:(id)sender
{
    
}

- (void)settingButtonPressed:(id)sender
{
    
}

- (void)backButtonPressed:(id)sender
{
    
}

- (void)pagePlayBtnPressed:(id)sender
{
    _isPlaying = !_isPlaying;
    
    if (_isPlaying) {
        [self.pagePlayerBtn setBackgroundImage:[UIImage imageNamed:@"zanting.png"] forState:UIControlStateNormal];
        [self.pagePlayerBtn setBackgroundImage:[UIImage imageNamed:@"zantinganniuHighLighted.png"] forState:UIControlStateHighlighted];
    }else {
        [self.pagePlayerBtn setBackgroundImage:[UIImage imageNamed:@"bofang.png"] forState:UIControlStateNormal];
        [self.pagePlayerBtn setBackgroundImage:[UIImage imageNamed:@"bofangHighLighted.png"] forState:UIControlStateHighlighted];
    }
    
}


#pragma mark - UIGestureRecognizerDelegate Methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}


#pragma mark - UIWebViewDelegate Methods

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    [self.loadingView setHidden:NO];
    [self.loadingIndicator setHidden:NO];
//    [self.loadingView.loadingIndicator setHidden:NO];
    [self.loadingIndicator startAnimating];
    
//    NSLog(@"---- %d",[_loadingIndicator isAnimating]);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    [self.loadingIndicator stopAnimating];
    [self.loadingView setHidden:YES];
    
//    NSLog(@"---- %d",[_loadingIndicator isAnimating]);
}


#pragma mark - ContentsViewControllerDataSource 

- (NSArray *)getColumnTrumbsImageWithDataSource:(id)dataSource
{
    return [self.data allColumnTrumbsArray];
}

- (void)swipeToFirstArticleOfSpecifiedColumn:(NSUInteger)index
{
//    NSLog(@"-②-");
    
    if (self.indexOfSpecifiedColume > index)    //在目录列表中所选的栏目的序号比当前看到的栏目序号小，启动向右划动手势
    {
//        NSLog(@"-③- ，self.indexOfSpecifiedColume = %d, self.swipeDirection == MHSwipeToRight",self.indexOfSpecifiedColume);
        self.swipeDirection = MHSwipeToRight;
        self.indexOfSpecifiedColume = index;
        self.indexOfFileInSpecifiedColume = 0;
    }else if (self.indexOfSpecifiedColume < index)  //在目录列表中所选的栏目的序号比当前看到的栏目序号大，启动向左划动手势
    {
//        NSLog(@"-④- ，self.indexOfSpecifiedColume = %d, self.swipeDirection == MHSwipeToRight",self.indexOfSpecifiedColume);
//        NSLog(@"-④- self.swipeDirection == MHSwipeToLeft");
        self.swipeDirection = MHSwipeToLeft;
        self.indexOfSpecifiedColume = index;
        self.indexOfFileInSpecifiedColume = 0;
    }else {
        if (self.indexOfFileInSpecifiedColume != 0) //在目录列表中所选的栏目的序号与当前看到的栏目序号相等，但不是该栏目第一篇，启动向右划动手势
        {
//            NSLog(@"-⑤- self.swipeDirection == MHSwipeToRight");
            self.swipeDirection = MHSwipeToRight;
            self.indexOfSpecifiedColume = index;
            self.indexOfFileInSpecifiedColume = 0;
        }else 
        {
            self.swipeDirection = MHSwipeToNone;
        }
    }
    
    
    if (self.swipeDirection == MHSwipeToLeft) 
    {
       
        if (self.webViewNew == nil) {
            self.webViewNew = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            _webViewNew.delegate = self;
            [(UIScrollView *)[[_webViewNew subviews] objectAtIndex:0] setBounces:NO];
            [_webViewNew addSubview:self.loadingView];
            _webViewNew.scalesPageToFit = YES;
        }
        
        [self.webViewNew addGestureRecognizer:self.doubleTap];
        [_webViewNew addSubview:self.pagePlayerBtn];
        
        if (self.loadingView) {
            [self.webViewNew addSubview:self.loadingView];
        }
        
        
        [self.webViewNew loadRequest:[self getRequestWithColumnIndex:index WithDataIndex:0]];
            
        CGRect aRect = self.webView.frame;
            
        self.webViewNew.frame = CGRectOffset(aRect, 768, 0);
        [self.view addSubview:self.webViewNew];
            
        [UIView beginAnimations:NULL context:nil];
        [UIView setAnimationDuration:0.26];
        [UIView setAnimationDelegate:self];
        self.webView.frame = CGRectOffset(aRect, -768, 0);
        self.webViewNew.frame = CGRectOffset(aRect, 0, 0);
        [UIView setAnimationDidStopSelector:@selector(animationDidStop)];
            
        [UIView commitAnimations];

    }else if (self.swipeDirection == MHSwipeToRight) {
        NSLog(@"self.swipeDirection == MHSwipeToRight");
        
        if (self.webViewNew == nil) {
            self.webViewNew = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            _webViewNew.delegate = self;
            [(UIScrollView *)[[_webViewNew subviews] objectAtIndex:0] setBounces:NO];
            [_webViewNew addSubview:self.loadingView];
            _webViewNew.scalesPageToFit = YES;
        }
        
        [self.webViewNew addGestureRecognizer:self.doubleTap];
        [_webViewNew addSubview:self.pagePlayerBtn];
        
        if (self.loadingView) {
            [self.webViewNew addSubview:self.loadingView];
            //        NSLog(@"--- --- self.loadingView is exist!%@",self.loadingView);
        }
        
        
        [self.webViewNew loadRequest:[self getRequestWithColumnIndex:index WithDataIndex:0]];
        
        CGRect aRect = self.webView.frame;
        
        self.webViewNew.frame = CGRectOffset(aRect, -768, 0);
        [self.view addSubview:self.webViewNew];
        
        [UIView beginAnimations:NULL context:nil];
        [UIView setAnimationDuration:0.32];
        [UIView setAnimationDelegate:self];
        self.webView.frame = CGRectOffset(aRect, 768, 0);
        self.webViewNew.frame = CGRectOffset(aRect, 0, 0);
        [UIView setAnimationDidStopSelector:@selector(animationDidStop)];
        
        [UIView commitAnimations];

    }

    NSUInteger aNumber = 0;
    
    if (index > 0) {
        for (int i = index - 1; i >= 0; i--) {
            aNumber += [[self.data.allPacksArray objectAtIndex:i] count];
        }
        self.currentPageNumber = aNumber;
    }else {
        self.currentPageNumber = 0;
    }
    
}

- (void)dismissContentsViewController
{
    [self.popoverContentsVC dismissPopoverAnimated:YES];
}

@end
