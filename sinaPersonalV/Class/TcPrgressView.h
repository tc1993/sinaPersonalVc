//
//  TcPrgressView.h
//  test
//
//  Created by 唐超 on 5/23/17.
//  Copyright © 2017 唐超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TcPrgressView : UIView

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) NSMutableArray * itemFrames;
@property (nonatomic, assign) CGColorRef color;
@property (nonatomic, assign) BOOL isNaugty;
@end
