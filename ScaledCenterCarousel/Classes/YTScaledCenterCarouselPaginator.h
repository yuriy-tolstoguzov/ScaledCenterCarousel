//
//  YTScaledCenterCarouselPaginator.h
//  ScaledCenterCarousel
//
//  Created by yuriy-tolstoguzov on 5/29/14.
//  Copyright (c) 2014 yuriy-tolstoguzov. All rights reserved.
//


#import <UIKit/UIKit.h>


@protocol YTScaledCenterCarouselPaginatorDelegate <NSObject>

- (void)carousel:(UICollectionView *)collectionView didSelectElementAtIndex:(NSUInteger)selectedIndex;

@optional
- (void)carousel:(UICollectionView *)collectionView didScrollToVisibleCells:(NSArray *)indexPathes;

@end


@protocol YTScaledCenterCarouselDataSource <UICollectionViewDataSource>

@property (assign, nonatomic) NSUInteger selectedIndex;

@end


@interface YTScaledCenterCarouselPaginator : NSObject <UICollectionViewDelegate>

@property (weak, nonatomic) id<YTScaledCenterCarouselPaginatorDelegate> delegate;
@property (assign, nonatomic) NSUInteger selectedIndex;

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView delegate:(id<YTScaledCenterCarouselPaginatorDelegate>)delegate;

@end
