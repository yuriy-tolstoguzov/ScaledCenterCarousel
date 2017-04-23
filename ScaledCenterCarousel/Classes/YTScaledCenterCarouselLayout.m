//
//  YTScaledCenterCarouselLayout.m
//  ScaledCenterCarousel
//
//  Created by yuriy-tolstoguzov on 6/2/14.
//  Copyright (c) 2014 yuriy-tolstoguzov. All rights reserved.
//

#import "YTScaledCenterCarouselLayout.h"


typedef id (^YTArrayFillingBlock)(NSUInteger index);
typedef BOOL (^YTArrayFilteringBlock)(id object);

@interface NSArray (YTCarouselExtensions)

+ (NSArray *)yt_arrayWithItemsCount:(NSUInteger)itemsCount fillUsingBlock:(YTArrayFillingBlock)block;
- (NSArray *)yt_filtredArrayUsingBlock:(YTArrayFilteringBlock)block;

@end


@interface YTScaledCenterCarouselLayout ()

@property (nonatomic, copy) NSArray *layoutInformation;
@property (nonatomic, assign) CGRect currentVisibleRect;

@end


@implementation YTScaledCenterCarouselLayout

- (CGSize)collectionViewContentSize {
    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:0];
    CGFloat sideSpace = (CGRectGetWidth(self.collectionView.bounds) - self.centerCellWidth) / 2.0;
    CGFloat width = self.normalCellWidth * (numberOfItems - 1) + self.centerCellWidth + sideSpace * 2.0;
    CGFloat height = self.normalCellHeight;
    return CGSizeMake(width, height);
}

- (void)prepareLayout {
    if (!self.layoutInformation
        || self.layoutInformation.count != [self.collectionView numberOfItemsInSection:0])  {

        NSUInteger attributesCount = [self.collectionView numberOfItemsInSection:0];
        self.layoutInformation = [NSArray yt_arrayWithItemsCount:attributesCount fillUsingBlock:^id(NSUInteger index) {
            NSIndexPath *attributesPath = [NSIndexPath indexPathForItem:index inSection:0];
            return [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:attributesPath];
        }];

        [self updateLayoutForBounds:self.collectionView.bounds];
    }
    else {
        [self updateLayoutForBounds:self.currentVisibleRect];
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.layoutInformation[indexPath.item];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    return [self.layoutInformation yt_filtredArrayUsingBlock:^BOOL(UICollectionViewLayoutAttributes *attribute) {
        return CGRectIntersectsRect(attribute.frame, rect);
    }];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    self.currentVisibleRect = newBounds;
    return !self.isIgnoringBoundsChange;
}

- (void)updateLayoutForBounds:(CGRect)newBounds {
    CGFloat deltaX = self.centerCellWidth - self.normalCellWidth;
    CGFloat deltaY = self.centerCellHeight - self.normalCellHeight;
    CGFloat leftSideInset = (CGRectGetWidth(newBounds) - self.centerCellWidth) / 2.0;

    for (UICollectionViewLayoutAttributes *attribute in self.layoutInformation) {
        CGFloat normalCellOffsetX = leftSideInset + attribute.indexPath.row * self.normalCellWidth;
        CGFloat normalCellOffsetY = (CGRectGetHeight(newBounds) - self.normalCellHeight) / 2.0;

        CGFloat distanceBetweenCellAndBoundCenters = normalCellOffsetX - CGRectGetMidX(newBounds) + self.centerCellWidth / 2.0;
        CGFloat normalizedCenterScale = distanceBetweenCellAndBoundCenters / self.normalCellWidth;
        // normalizedCenterScale has range (- 1 ... 1), 0 - cell placed at center of bounds

        BOOL isCenterCell = (fabs(normalizedCenterScale) < 1.0);
        BOOL isNormalCellOnRightOfCenter = (normalizedCenterScale > 0.0) && !isCenterCell;
        BOOL isNormalCellOnLeftOfCenter = (normalizedCenterScale < 0.0) && !isCenterCell;

        if (isCenterCell) {
            CGFloat incrementX = (1.0 - fabs(normalizedCenterScale)) * deltaX;
            CGFloat incrementY = (1.0 - fabs(normalizedCenterScale)) * deltaY;
            CGFloat offsetX = normalizedCenterScale > 0 ? deltaX - incrementX : 0;
            CGFloat offsetY = - incrementY / 2.0;

            attribute.frame = CGRectMake(normalCellOffsetX + offsetX,
                                         normalCellOffsetY + offsetY,
                                         self.normalCellWidth + incrementX,
                                         self.normalCellHeight + incrementY);
        }
        else if (isNormalCellOnRightOfCenter)  {
            attribute.frame = CGRectMake(normalCellOffsetX + deltaX,
                                         normalCellOffsetY,
                                         self.normalCellWidth,
                                         self.normalCellHeight);
        }
        else if(isNormalCellOnLeftOfCenter) {
            attribute.frame = CGRectMake(normalCellOffsetX,
                                         normalCellOffsetY,
                                         self.normalCellWidth,
                                         self.normalCellHeight);
        }
    }
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset {
    if (self.proposedContentOffset.x != NSNotFound) {
        proposedContentOffset = self.proposedContentOffset;
        CGPoint zeroPoint = CGPointZero;
        zeroPoint.x = NSNotFound;
        self.proposedContentOffset = zeroPoint;
    }
    return proposedContentOffset;
}

@end


@implementation NSArray (YTCarouselExtensions)

+ (NSArray *)yt_arrayWithItemsCount:(NSUInteger)itemsCount fillUsingBlock:(YTArrayFillingBlock)block {

    NSParameterAssert(block != nil);
    NSMutableArray *fillingArray = [NSMutableArray array];

    for (NSUInteger index = 0; index < itemsCount; index++) {
        id filledObject = block(index);
        [fillingArray addObject:filledObject];
    }

    return [fillingArray copy];
}


- (NSArray *)yt_filtredArrayUsingBlock:(YTArrayFilteringBlock)block {
    NSParameterAssert(block != nil);

    NSIndexSet *passedIndexes = [self indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return block(obj);
    }];

    return [self objectsAtIndexes:passedIndexes];
}

@end
