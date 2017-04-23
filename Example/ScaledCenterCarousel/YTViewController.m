//
//  YTViewController.m
//  ScaledCenterCarousel
//
//  Created by yuriy-tolstoguzov on 04/23/2017.
//  Copyright (c) 2017 yuriy-tolstoguzov. All rights reserved.
//

#import "YTViewController.h"

#import "YTCarouselCell.h"
#import "YTCarouselDataSource.h"
#import <ScaledCenterCarousel/YTScaledCenterCarouselLayout.h>
#import <ScaledCenterCarousel/YTScaledCenterCarouselPaginator.h>


@interface YTViewController () <YTScaledCenterCarouselPaginatorDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) YTCarouselDataSource *collectionViewDataSource;
@property (strong, nonatomic) YTScaledCenterCarouselPaginator* paginator;

@end


@implementation YTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionViewDataSource = [[YTCarouselDataSource alloc] init];
    self.collectionView.dataSource = self.collectionViewDataSource;

    self.paginator = [[YTScaledCenterCarouselPaginator alloc] initWithCollectionView:self.collectionView delegate:self];

    [self.collectionView reloadData];
}


#pragma mark - YTCarouselCenterPagerDelegate

- (void)carousel:(UICollectionView *)collectionView didSelectElementAtIndex:(NSUInteger)selectedIndex {
    
}

@end
