//
//  YTScaledCenterCarouselPaginator.m
//  ScaledCenterCarousel
//
//  Created by yuriy-tolstoguzov on 5/29/14.
//  Copyright (c) 2014 yuriy-tolstoguzov. All rights reserved.
//


#import "YTScaledCenterCarouselPaginator.h"

#import "YTScaledCenterCarouselLayout.h"


typedef NS_ENUM(NSUInteger, YTNearestPointDirection) {
    YTNearestPointDirectionAny,
    YTNearestPointDirectionLeft,
    YTNearestPointDirectionRight
};


@interface YTScaledCenterCarouselPaginator ()

@property (assign, nonatomic) CGFloat scrollVelocity;
@property (weak, nonatomic) UICollectionView *collectionView;
@property (assign, nonatomic, readonly) CGFloat collectionViewCenter;

@end


@implementation YTScaledCenterCarouselPaginator

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView
                              delegate:(id<YTScaledCenterCarouselPaginatorDelegate>)delegate {
    self = [super init];
    if (self) {
        _collectionView = collectionView;
        _collectionView.delegate = self;
        _delegate = delegate;
        _selectedIndex = 0;
    }
    return self;
}

#pragma mark - UICollectionViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.selectedIndex == INT_MAX) {
        return;
    }

    NSUInteger previousSelectedIndex = self.selectedIndex;
    if ([self.collectionView.dataSource conformsToProtocol:@protocol(YTScaledCenterCarouselDataSource)]) {
        ((id<YTScaledCenterCarouselDataSource>)self.collectionView.dataSource).selectedIndex = self.selectedIndex;
    }
    self.selectedIndex = INT_MAX;
    [self reloadCellAtIndexPath:[NSIndexPath indexPathForItem:previousSelectedIndex inSection:0]
              withSelectedState:NO];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset {
    self.scrollVelocity = velocity.x;
    if (_scrollVelocity == 0) {
        *targetContentOffset = [self offsetForCenterX:(*targetContentOffset).x + self.collectionViewCenter
                                        withDirection:YTNearestPointDirectionAny];
    }
    if (_scrollVelocity < 0) {
        *targetContentOffset = [self offsetForCenterX:(*targetContentOffset).x + self.collectionViewCenter
                                        withDirection:YTNearestPointDirectionLeft];
    }
    else if (_scrollVelocity > 0) {
        *targetContentOffset = [self offsetForCenterX:(*targetContentOffset).x + self.collectionViewCenter
                                        withDirection:YTNearestPointDirectionRight];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self.collectionView.dataSource conformsToProtocol:@protocol(YTScaledCenterCarouselDataSource)]) {
        ((id<YTScaledCenterCarouselDataSource>)self.collectionView.dataSource).selectedIndex = self.selectedIndex;
    }

    [self reloadCellAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex inSection:0] withSelectedState:YES];
    if ([self.delegate respondsToSelector:@selector(carousel:didScrollToVisibleCells:)]) {
        [self.delegate carousel:self.collectionView didScrollToVisibleCells:self.collectionView.visibleCells];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    [self scrollViewWillBeginDragging:collectionView];

    self.selectedIndex = indexPath.item;
    [self.delegate carousel:self.collectionView didSelectElementAtIndex:self.selectedIndex];

    YTScaledCenterCarouselLayout *layout = (YTScaledCenterCarouselLayout *)self.collectionView.collectionViewLayout;
    CGFloat xPosition = self.selectedIndex * layout.normalCellWidth;
    layout.ignoringBoundsChange = YES;
    [self.collectionView setContentOffset:CGPointMake(xPosition, 0) animated:YES];
    layout.ignoringBoundsChange = NO;

    [self performSelector:@selector(scrollViewDidEndDecelerating:) withObject:collectionView afterDelay:0.3];
}


#pragma mark - Utility methods

- (CGPoint)offsetForCenterX:(CGFloat)centerX withDirection:(YTNearestPointDirection)direction {
    NSArray *leftNearestCenters = [self nearestLeftCenterForCenterX:centerX];
    NSInteger leftCenterIndex = [leftNearestCenters[0] integerValue];
    CGFloat leftCenter = [leftNearestCenters[1] floatValue];
    NSArray *rightNearestCenters = [self nearestRightCenterForCenterX:centerX];
    NSInteger rightCenterIndex = [rightNearestCenters[0] integerValue];
    CGFloat rightCenter = [rightNearestCenters[1] floatValue];
    NSUInteger nearestItemIndex = NSNotFound;

    switch (direction) {
        case YTNearestPointDirectionAny:
            if (leftCenter > rightCenter) {
                nearestItemIndex = rightCenterIndex;
            }
            else {
                nearestItemIndex = leftCenterIndex;
            }
            break;
        case YTNearestPointDirectionLeft:
            nearestItemIndex = leftCenterIndex;
            break;
        case YTNearestPointDirectionRight:
            nearestItemIndex = rightCenterIndex;
            break;
    }

    self.selectedIndex = nearestItemIndex;
    if (nearestItemIndex != NSNotFound) {
        [self.delegate carousel:self.collectionView didSelectElementAtIndex:nearestItemIndex];
    }

    YTScaledCenterCarouselLayout *layout = (YTScaledCenterCarouselLayout *)self.collectionView.collectionViewLayout;
    return CGPointMake(nearestItemIndex * layout.normalCellWidth, 0.0f);
}

- (NSArray *)nearestLeftCenterForCenterX:(CGFloat)centerX {
    YTScaledCenterCarouselLayout *layout = (YTScaledCenterCarouselLayout *)self.collectionView.collectionViewLayout;

    NSInteger nearestLeftElementIndex = (centerX - self.collectionViewCenter - layout.centerCellWidth + layout.normalCellWidth) / layout.normalCellWidth;
    CGFloat minimumLeftDistance = centerX - nearestLeftElementIndex * layout.normalCellWidth - CGRectGetWidth(self.collectionView.bounds) / 2.0f - layout.centerCellWidth + layout.normalCellWidth;

    return @[@(nearestLeftElementIndex), @(minimumLeftDistance)];
}

- (NSArray *)nearestRightCenterForCenterX:(CGFloat)centerX {
    YTScaledCenterCarouselLayout *layout = (YTScaledCenterCarouselLayout *)self.collectionView.collectionViewLayout;

    NSInteger nearestRightElementIndex = ceilf((centerX - self.collectionViewCenter - layout.centerCellWidth + layout.normalCellWidth) / layout.normalCellWidth);
    CGFloat minimumRightDistance = nearestRightElementIndex * layout.normalCellWidth + self.collectionViewCenter - centerX - layout.centerCellWidth + layout.normalCellWidth;
    
    return @[@(nearestRightElementIndex), @(minimumRightDistance)];
}

- (void)reloadCellAtIndexPath:(NSIndexPath *)indexPath withSelectedState:(BOOL)selected {
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    [cell setSelected:selected];
}

- (CGFloat)collectionViewCenter {
    return CGRectGetWidth(self.collectionView.bounds) / 2.0f;
}

@end
