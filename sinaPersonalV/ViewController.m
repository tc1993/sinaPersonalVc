//
//  ViewController.m
//  sinaPersonalV
//
//  Created by 唐超 on 6/7/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "ViewController.h"
#import "TCPagesView.h"
#import "TableViewController.h"

@interface ViewController ()<TcPageDelegate>

@property (nonatomic, strong) UIView * navgationView;

@property (nonatomic, strong) UIView * navBgView;

@property (nonatomic, strong) CAGradientLayer * separetorLayer;

@property (nonatomic, strong) UIImageView * avatarImageView;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    
    [self initUI];

}

- (void)initUI
{

    UIView * headView = [[UIView alloc] initWithFrame:CGRectMake(0, -100, screenWidth, screenWidth*9/16+200)];
    headView.autoresizesSubviews = YES;
    headView.backgroundColor = [UIColor redColor];
    headView.clipsToBounds = YES;
    
    
    UIImageView * bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header.png"]];
    bgImageView.frame = headView.bounds;
    bgImageView.contentMode = UIViewContentModeScaleToFill;
    [headView addSubview:bgImageView];
    [headView addSubview:self.avatarImageView];
    
    CGFloat width = 60;
    self.avatarImageView.frame = CGRectMake((screenWidth - width)/2, headView.bounds.size.height - width - 90 , width, width);
    self.avatarImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    self.avatarImageView.image = [UIImage imageNamed:@"avatar"];
    
    NSMutableArray * array = [NSMutableArray array];
    for (int i = 0; i <3; i++) {
        TableViewController * vc = [[TableViewController alloc] initWithStyle:UITableViewStylePlain];
        [array addObject:vc];
    }
    TCPagesView * view = [[TCPagesView alloc] initWithFrame:[UIScreen mainScreen].bounds titles:@[@"主页",@"微博",@"相册"] headHeight:screenWidth*9/16 segmentHeight:50 headView:headView itemsMargin:30 itemWidth:50 viewControllers:array belongController:self];
    [self.view addSubview:view];
    view.delegate = self;
    
    _navgationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 64)];
    _navgationView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_navgationView];
    
    CAGradientLayer * layer = [[CAGradientLayer alloc] init];
    layer.frame = _navgationView.bounds;
    layer.colors = @[(id)[UIColor colorWithWhite:0 alpha:0.2].CGColor,(id)[UIColor colorWithWhite:0 alpha:0.15].CGColor,(id)[UIColor colorWithWhite:0 alpha:0.1].CGColor,(id)[UIColor colorWithWhite:0 alpha:0.05].CGColor,(id)[UIColor colorWithWhite:0 alpha:0.03].CGColor,(id)[UIColor colorWithWhite:0 alpha:0.01].CGColor,(id)[UIColor colorWithWhite:0 alpha:0.0].CGColor];
    [_navgationView.layer addSublayer:layer];
    
    
    _navBgView = [[UIView alloc] initWithFrame:_navgationView.frame];
    _navBgView.backgroundColor = [UIColor whiteColor];
    _navBgView.alpha = 0;
    [_navgationView addSubview:_navBgView];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((screenWidth - 100)/2, 20, 100, 44)];
    
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"小不懂怪狩.";
    
    [_navBgView addSubview:titleLabel];
    
    _navBgView.layer.shadowOffset = CGSizeMake(1, 0);
    _navBgView.layer.shadowOpacity = 1;
    _navBgView.layer.shadowRadius = 1;
    _navBgView.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.0].CGColor;
    
}


- (void)scrollViewDidScrollOffSetY:(CGFloat )offsety
{
    CGFloat alpha = 0;
    if (offsety >-190)
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        if (offsety<-135)
        {
            alpha = (offsety + 190)/55.0;
        }
    }
    else
    {
        alpha = 0;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    if (offsety>=-135)
    {
        alpha = 1;
        
    }
    
    if (offsety>= -64-50) {
        _navBgView.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.3].CGColor;
        
    }
    else
    {
        _navBgView.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0].CGColor;
        
    }
    _navBgView.alpha = alpha;
}


- (UIImageView *)avatarImageView
{
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.cornerRadius = 30.f;
        _avatarImageView.backgroundColor = [UIColor lightGrayColor];
    }
    return _avatarImageView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
