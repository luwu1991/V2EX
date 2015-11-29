//
//  UIview+FrameMethods.m
//  导航控制器
//
//  Created by 吴露 on 15/6/26.
//  Copyright (c) 2015年 吴露. All rights reserved.
//

#import "UIview+FrameMethods.h"

@implementation UIView(FrameMethods)

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setWidthAndHeight:(CGFloat)width height:(CGFloat)height;
{
    CGRect origionRect = self.frame;
    CGRect newFrame = CGRectMake(origionRect.origin.x, origionRect.origin.y, width, height);
    self.frame = newFrame;
}

-(void)setWidth:(CGFloat)width
{
    CGRect newRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
    self.frame = newRect;
}

-(void)setHeight:(CGFloat)height
{
    CGRect newRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
    self.frame = newRect;
}

-(void)setXAndY:(CGFloat)x Y:(CGFloat)y
{
    CGRect newRect = CGRectMake(x, y, self.frame.size.width, self.frame.size.height);
    self.frame = newRect;
}

-(void)setX:(CGFloat)x
{
    CGRect newRect = CGRectMake(x,  self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    self.frame = newRect;
}

-(void)setY:(CGFloat)y
{
    CGRect newRect = CGRectMake(self.frame.origin.x,y, self.frame.size.width, self.frame.size.height);
    self.frame = newRect;
}

-(void)setCenterX:(CGFloat)x;
{
    CGPoint Center = self.center;
    Center = CGPointMake(x, Center.y);
    self.center = Center;
}

-(void)setCenterY:(CGFloat)y;
{
    CGPoint Center = self.center;
    Center = CGPointMake(Center.x, y);
    self.center = Center;
}

-(CGFloat)width
{
    return self.frame.size.width;
}

-(CGFloat)height
{
    return self.frame.size.height;
}

-(CGFloat)x
{
    return self.frame.origin.x;
}

-(CGFloat)y
{
    return self.frame.origin.y;
}

-(CGFloat)centerX;
{
    return self.center.x;
}
-(CGFloat)centerY
{
    return self.center.y;
}
@end
