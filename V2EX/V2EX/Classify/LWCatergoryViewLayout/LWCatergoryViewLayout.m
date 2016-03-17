//
//  UICollectionViewLayout+LWCatergoryViewLayout.m
//  V2EX
//
//  Created by wulu on 16/3/16.
//  Copyright © 2016年 吴露. All rights reserved.
//

#import "LWCatergoryViewLayout.h"




@interface LWCatergoryViewLayout ()

@property (strong, nonatomic) NSMutableArray  *attrs;

@property(assign,nonatomic)CGFloat contentWidth;

@property(assign,nonatomic)CGFloat totleCenterX;

@property(assign,nonatomic)CGFloat ItemSpaceing;
@end

@implementation LWCatergoryViewLayout

-(void)prepareLayout{
    [super prepareLayout];
    self.ItemSpaceing = 10;
    
    NSString *allTitles = [self.titles componentsJoinedByString:@""];
    CGFloat totleTitleWidth = [allTitles boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.width;
    
    self.contentWidth = totleTitleWidth + self.ItemSpaceing*(self.titles.count );
    self.totleCenterX = - self.ItemSpaceing;
    self.attrs = [NSMutableArray array];
    for (int i = 0 ;i < self.titles.count ; i++) {
        [self.attrs addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]] ];
    }
}
- (CGSize)collectionViewContentSize{
    return CGSizeMake(_contentWidth, self.collectionView.bounds.size.height);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return [self LW_itemLayoutAttributesPathInRect:rect];
}
-(UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGSize size = [self.titles[indexPath.item] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    attr.size = CGSizeMake(size.width + self.ItemSpaceing, 44);
    
    CGFloat centerX = _totleCenterX + self.ItemSpaceing + size.width / 2.0f;
    self.totleCenterX = centerX + size.width / 2.0f;
    CGPoint center = CGPointMake(centerX, self.collectionView.height/ 2.0f);
    attr.center = center;
    return attr;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)LW_itemLayoutAttributesPathInRect:(CGRect)rect{
    NSMutableArray *temp = @[].mutableCopy;
    for (int i = 0; i < _attrs.count; i ++) {
        UICollectionViewLayoutAttributes *attr = _attrs[i];
        //判断该item是否和屏幕相交或者包含，满足相交和包含才需要返回，不应该一次返回所有的attrs，虽然可行但是性能不好
        if (CGRectContainsRect(rect, attr.frame) || CGRectIntersectsRect(rect, attr.frame)) {
            [temp addObject:attr];
        }
      
    }
    return temp.copy;
}
@end
