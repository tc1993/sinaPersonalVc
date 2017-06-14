//
//  TcPrgressView.m
//  test
//
//  Created by 唐超 on 5/23/17.
//  Copyright © 2017 唐超. All rights reserved.
//

#import "TcPrgressView.h"
@interface TcPrgressView()
@property (nonatomic, assign) CGFloat margin;

@end

@implementation TcPrgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}


- (void)initUI
{
    self.color = [UIColor redColor].CGColor;
    
}



- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat height = self.frame.size.height;
    int index = (int)self.progress;
    index = (index <= self.itemFrames.count - 1) ? index : (int)self.itemFrames.count - 1;
    CGFloat rate = self.progress - index;
    CGRect currentFrame = [self.itemFrames[index] CGRectValue];
    CGFloat currentWidth = currentFrame.size.width;
    int nextIndex = index + 1 < self.itemFrames.count ? index + 1 : index;
    CGFloat nextWidth = [self.itemFrames[nextIndex] CGRectValue].size.width;
    
    CGFloat currentX = currentFrame.origin.x;
    CGFloat nextX = [self.itemFrames[nextIndex] CGRectValue].origin.x;
    CGFloat startX = currentX + (nextX - currentX) * rate;
    CGFloat width = currentWidth + (nextWidth - currentWidth)*rate;
    CGFloat endX = startX + width;
    
    CGFloat nextMaxX   = nextX + nextWidth;
    
    if (_isNaugty)
    {
        if (rate <= 0.5) {
            startX = currentX ;
            CGFloat currentMaxX = currentX + currentWidth;
            endX = currentMaxX + (nextMaxX - currentMaxX) * rate * 2.0;
        } else {
            startX = currentX + (nextX - currentX) * (rate - 0.5) * 2.0;
            CGFloat nextMaxX = nextX + nextWidth;
            endX = nextMaxX ;
        }
    }
   
    width = endX - startX;
    
    CGFloat lineWidth =  1.0;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(startX, lineWidth / 2.0, width, height - lineWidth) cornerRadius:1.0];
    CGContextAddPath(ctx, path.CGPath);
    
    CGContextSetFillColorWithColor(ctx, self.color);
    CGContextFillPath(ctx);
    
}


@end
