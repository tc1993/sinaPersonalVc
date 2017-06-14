//
//  TCPagesView.m
//  test
//
//  Created by 唐超 on 5/19/17.
//  Copyright © 2017 唐超. All rights reserved.
//

#import "TCPagesView.h"
#import "TcPrgressView.h"
static void *TcPagingViewScrollContext = &TcPagingViewScrollContext;

@interface TCPagesView ()<UIScrollViewDelegate>

/**
 指示条高度
 */
@property (nonatomic, assign) CGFloat pregressHeight;

@property (nonatomic, strong) UIScrollView * scollView;
/**
 切换view
 */
@property (nonatomic, strong) UIView * segmentView;

@property (nonatomic, strong) TcPrgressView * pregressView;
/**
 头部视图
 */
@property (nonatomic, strong) UIView * headerView;

/**
 子控制器
 */
@property (nonatomic, strong) NSMutableArray * controllersArray;

@property (nonatomic, strong) NSMutableArray * contentViewsArray;

@property (nonatomic, strong) NSMutableArray * buttonsArray;

@property (nonatomic, assign) CGFloat headHeight;

@property (nonatomic, strong) NSArray * titlesArray;

@property (nonatomic, assign) NSInteger pageCount;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, weak) UIViewController * viewController;

@property (nonatomic, assign) CGFloat itemWidth;

@property (nonatomic, strong) UIButton * currentTouchButton;

@property (nonatomic, strong) UIView * currentTouchView;

@property (nonatomic, strong) UIScrollView * currentScrollView;

@property (nonatomic, assign) BOOL isSwitching;


/**
 切换按钮的frames (暂时没用)
 */
@property (nonatomic, strong) NSMutableArray * itemFrames;

/**
 指示条的frames
 */
@property (nonatomic, strong) NSMutableArray * pregressFrames;

@end

@implementation TCPagesView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *>*)titlesArray headHeight:(CGFloat )headHeight segmentHeight:(CGFloat)segmentHeight headView:(UIView *)headView itemsMargin:(CGFloat )itemsMargin itemWidth:(CGFloat)itemWidth viewControllers:(NSArray *)vcs belongController:(UIViewController *)viewController
{
    if (self = [super initWithFrame:frame])
    {
        _itemsMargin = itemsMargin;
        _headerView = headView;
        _itemWidth = itemWidth;
        _pregressHeight = 3.0;
        _segmentViewHeight = segmentHeight ? segmentHeight :45;
        _headHeight = headHeight;
        
        _titlesArray = titlesArray;
        _pageCount = 1;
        _currentIndex = 0;
        _titleColor = [UIColor blackColor];
        _titleSelectedColor = [UIColor redColor];
        if (titlesArray && [titlesArray isKindOfClass:[NSArray class]]) {
            _pageCount = titlesArray.count;
        }
        _viewController = viewController;
        
        for (UIViewController * vc in vcs)
        {
            
            [self.controllersArray addObject:vc];
            [_viewController addChildViewController:vc];
            
            if ([vc.view isKindOfClass:[UIScrollView class]])
            {
                [self.contentViewsArray addObject:vc.view];
            }
            else
            {
                for (UIView * view in vc.view.subviews)
                {
                    if ([view isKindOfClass:[UIScrollView class]])
                    {
                        [self.contentViewsArray addObject:view];
                        break;
                    }
                }
            }
        }
        
        for (UIScrollView * contentView in self.contentViewsArray)
        {
            [contentView  setContentInset:UIEdgeInsetsMake(_headHeight + _segmentViewHeight, 0, 0, 0)];
            
            [contentView addObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:&TcPagingViewScrollContext];
        }
        
        _currentScrollView = [_contentViewsArray firstObject];
        
        [self setUpView];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];

}

- (void)setUpView
{
    
    _scollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scollView.contentSize = CGSizeMake(screenWidth * _pageCount, 0);
    _scollView.showsVerticalScrollIndicator = NO;
    _scollView.showsHorizontalScrollIndicator = NO;
    _scollView.pagingEnabled = YES;
    _scollView.delegate = self;
    _scollView.bounces = NO;
    _scollView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_scollView];
    
    for (int i =0 ; i<_contentViewsArray.count; i++) {
        UIScrollView * view = _contentViewsArray[i];
        view.backgroundColor = [UIColor whiteColor];
        view.frame = CGRectMake(i*screenWidth, 0, screenWidth, screenHeight);
        [_scollView addSubview:view];
    }

    CGRect frame = _headerView.frame;
    frame.size.height = _headHeight + 50+100;
    frame.origin.y = -100;
    _headerView.frame = frame;
    [self addSubview:_headerView];
    
    _segmentView  = [[UIView alloc] initWithFrame:CGRectMake(0, _headHeight, screenWidth, _segmentViewHeight)];
    _segmentView.backgroundColor = [UIColor whiteColor];
    _segmentView.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.3].CGColor;
    _segmentView.layer.shadowOpacity = 0.3;
    _segmentView.layer.shadowOffset = CGSizeMake(0, 1);
    _segmentView.layer.shadowRadius = 0.8;
    [self addSubview:_segmentView];
    
    
    
    for (int i =0; i<_titlesArray.count; i++)
    {
        NSString * title = _titlesArray[i];
        CGFloat width = _itemWidth;
        CGFloat height = _segmentViewHeight;
        CGFloat leadingSapce = (screenWidth - _itemWidth * _pageCount - _itemsMargin * (_pageCount-1))/2;
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:_titleColor forState:UIControlStateNormal];
        [button setTitleColor:_titleSelectedColor forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.tag = i;
        [self.buttonsArray addObject:button];
        [button addTarget:self action:@selector(segmentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat x = leadingSapce + i * (_itemWidth + _itemsMargin);
        button.frame = CGRectMake(x, 0, width, height);
        CGFloat pace = 15;//进度条比button短多少
        CGFloat framex = x + pace;
        CGFloat frameWidth = _itemWidth - 2 * pace;
        CGFloat frameY = height - _pregressHeight;
        CGRect frame = CGRectMake(framex,frameY, frameWidth, _pregressHeight);
        [self.pregressFrames addObject:[NSValue valueWithCGRect:frame]];
        [_segmentView addSubview:button];
    
    }
    _pregressView = [[TcPrgressView alloc] initWithFrame:CGRectMake(0, _segmentViewHeight - _pregressHeight-3, screenWidth, _pregressHeight)];
    _pregressView.itemFrames = self.pregressFrames;
    _pregressView.backgroundColor = [UIColor clearColor];
    [_segmentView addSubview:_pregressView];
    
    
    UIButton * firstButton = [_buttonsArray firstObject];
    firstButton.selected = YES;
    

}

#pragma mark - actions
- (void)segmentButtonClick:(UIButton *)button
{
    _pregressView.isNaugty = NO;
    [self changeBottomBarPositionAtindex:button.tag];
    [_scollView setContentOffset:CGPointMake(screenWidth*button.tag, 0) animated:YES];
}

- (void)changeBottomBarPositionAtindex:(NSInteger)index
{
    UIButton * button = self.buttonsArray[index];
    for (UIButton * temp in self.buttonsArray) {
        temp.selected = NO;
    }
    button.selected = YES;
    _pregressView.isNaugty = NO;
    [self adjustContentViewOffsetAtIndex:index];
}


#pragma mark - privateMethods
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    if ([view isDescendantOfView:self.headerView] || [view isDescendantOfView:self.segmentView])
    {
        _scollView.scrollEnabled = NO;
        //如果手势在头部视图上
        //截取点击事件  如果是button则响应
        if([view isKindOfClass:[UIButton class]])
        {
            return view;
        }
        return self.currentScrollView;
    }
    _scollView.scrollEnabled = YES;
    return view;
}

- (void)adjustContentViewOffsetAtIndex:(NSInteger)index
{
    self.currentScrollView = self.contentViewsArray[index];
    self.isSwitching = YES;
    if (_segmentView.frame.origin.y == 64)
    {
        //segment在最上面
        if (self.currentScrollView.contentOffset.y<-_segmentViewHeight-64)
        {
            [self.currentScrollView setContentOffset:CGPointMake(0, -_segmentViewHeight-64)];
        }
    }
    else
    {
        [self.currentScrollView setContentOffset:CGPointMake(0, -_segmentViewHeight - _segmentView.frame.origin.y)];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5)), dispatch_get_main_queue(), ^{
        self.isSwitching = NO;
    });
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"scrollViewDidScroll:scrollView:%@",scrollView);
    if (scrollView == _scollView)
    {
        CGFloat x = scrollView.contentOffset.x;
        self.currentIndex = (x+screenWidth*0.5)/screenWidth;
        [self bottomBarNaughtyWithOffset:x];
        
    }
}



- (void)bottomBarNaughtyWithOffset:(CGFloat)offsetx
{
    if (offsetx<0)
    {
        offsetx = 0;
    }
    _pregressView.progress = offsetx/screenWidth;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _pregressView.isNaugty = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _scollView) {
        CGFloat x = scrollView.contentOffset.x;
        NSInteger index = x/screenWidth;
        [self changeBottomBarPositionAtindex:index];
    }
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    if (currentIndex != _currentIndex) {
        _currentIndex = currentIndex;
    }
}

#pragma mark - Observer
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(__unused id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    
    if (context == &TcPagingViewScrollContext)
    {
        
        if (self.isSwitching) {
            return;
        }
        
        CGFloat newOffsetY = [change[NSKeyValueChangeNewKey] CGPointValue].y;
        CGFloat oldOffsety = [change[NSKeyValueChangeOldKey] CGPointValue].y;
        
        
        if (oldOffsety == newOffsetY) {
            //解决导航push是出现的问题  push时会调用这个回调 不知道为什么
            return;
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewDidScrollOffSetY:)]) {
            [self.delegate scrollViewDidScrollOffSetY:newOffsetY];
        }

        NSLog(@"\n newOffsetY:%f \n object：%p \n keyPath：%@  \n change:%@ \n context:%p",newOffsetY,object,keyPath,change,context);
        

        CGFloat headerViewHeight    = self.headHeight;
        
        if (-newOffsetY < headerViewHeight  && -newOffsetY < _segmentViewHeight+64)
        {
            //上面的划出屏幕 上面的固定
            CGRect frame = self.headerView.frame;
            frame.origin.y = - _headHeight+64-100;
            self.headerView.frame = frame;
            
            CGRect sementFrame = _segmentView.frame;
            sementFrame.origin.y = 64;
            _segmentView.frame = sementFrame;
        }
        else if(newOffsetY<- _headHeight - _segmentViewHeight)
        {
            //往下拉
            CGFloat offset = -(newOffsetY + _headHeight + _segmentViewHeight);
            CGRect frame = self.headerView.frame;
            frame.origin.y = -100.f + offset * 0.6;
            CGFloat height = _headHeight + 100.f + 50.f + offset *0.4;
            frame.size.height = height;
            
            self.headerView.frame = frame;

            CGRect sementFrame = _segmentView.frame;
            sementFrame.origin.y = -newOffsetY-_segmentViewHeight;
            _segmentView.frame = sementFrame;
        }
        else
        {
            CGRect frame = self.headerView.frame;
            frame.origin.y = -newOffsetY -_segmentViewHeight-_headHeight - 100;
            self.headerView.frame = frame;
            
            CGRect sementFrame = _segmentView.frame;
            sementFrame.origin.y = -newOffsetY-_segmentViewHeight;
            _segmentView.frame = sementFrame;
        }
    }
}


#pragma mark - getters && setters
- (NSMutableArray *)controllersArray
{
    if (!_controllersArray) {
        _controllersArray = [NSMutableArray array];
    }
    return _controllersArray;
}

- (NSMutableArray *)contentViewsArray
{
    if (!_contentViewsArray) {
        _contentViewsArray = [NSMutableArray array];
    }
    return _contentViewsArray;
}

- (NSMutableArray *)buttonsArray
{
    if (!_buttonsArray) {
        _buttonsArray = [NSMutableArray array];
    }
    return _buttonsArray;
}

- (NSMutableArray *)itemFrames
{
    if (!_itemFrames) {
        _itemFrames = [NSMutableArray array];
    }
    return _itemFrames;
}

- (NSMutableArray *)pregressFrames
{
    if (!_pregressFrames) {
        _pregressFrames = [NSMutableArray array];
    }
    return _pregressFrames;
}

- (void)dealloc {
    for(UIScrollView *v in self.contentViewsArray) {
        [v removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) context:&TcPagingViewScrollContext];
    }
}

@end
