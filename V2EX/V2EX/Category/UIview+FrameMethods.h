//
//  UIview+FrameMethods.h
//  导航控制器
//
//  Created by 吴露 on 15/6/26.
//  Copyright (c) 2015年 吴露. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView(FrameMethods)

////移动的方法
//-(void)moveHorizontal:(CGFloat)horizontal vertical:(CGFloat)vertical;
//
//-(void)moveHorizontal:(CGFloat)horizontal vertical:(CGFloat)vertical addWidth:(CGFloat)wigthAdded addHeight:(CGFloat)heihtAdded;
//
//-(void)moveToHorizontal:(CGFloat)horizontal toVertical:(CGFloat)vertical;
//
//-(void)moveToHorizontal:(CGFloat)horizontal toVertical:(CGFloat)vertical setWidth:(CGFloat)width setHeight:(CGFloat)height;

//设置的方法

-(void)setWidthAndHeight:(CGFloat)width height:(CGFloat)height;

-(void)setWidth:(CGFloat)width;

-(void)setHeight:(CGFloat)height;

-(void)setXAndY:(CGFloat)x Y:(CGFloat)y;

-(void)setX:(CGFloat)x;

-(void)setY:(CGFloat)y;

-(void)setCenterX:(CGFloat)x;

-(void)setCenterY:(CGFloat)y;

//获取的方法

-(CGFloat)width;

-(CGFloat)height;

-(CGFloat)x;

-(CGFloat)y;

-(CGFloat)centerX;

-(CGFloat)centerY;
@end
