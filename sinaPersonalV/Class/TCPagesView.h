//
//  TCPagesView.h
//  test
//
//  Created by 唐超 on 5/19/17.
//  Copyright © 2017 唐超. All rights reserved.
//


#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height

#import <UIKit/UIKit.h>


@class TCPagesView;
@protocol TcPageDelegate <NSObject>
@required

- (void)scrollViewDidScrollOffSetY:(CGFloat )offsety;

@optional


@end

@interface TCPagesView : UIView

@property (nonatomic, weak) id<TcPageDelegate>delegate;

@property (nonatomic, strong) UIColor * titleColor;

@property (nonatomic, strong) UIColor * titleSelectedColor;

@property (nonatomic, strong) UIFont * titleFont;

@property (nonatomic, assign) CGFloat segmentViewHeight;

@property (nonatomic, strong) UIColor * segmentViewBackGroundColor;

@property (nonatomic, strong) UIColor * bottomBarColor;

@property (nonatomic, assign) CGFloat bottomBarHeight;

@property (nonatomic, assign) CGFloat bottomBarWidth;

@property (nonatomic, assign) CGFloat itemsMargin;

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *>*)titlesArray headHeight:(CGFloat )headHeight segmentHeight:(CGFloat)segmentHeight headView:(UIView *)headView itemsMargin:(CGFloat )itemsMargin itemWidth:(CGFloat)itemWidth viewControllers:(NSArray *)vcs belongController:(UIViewController *)viewController;
@end
