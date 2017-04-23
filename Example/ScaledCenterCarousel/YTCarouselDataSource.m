//
//  AELCarouselDataSource.m
//  ScaledCenterCarousel
//
//  Created by yuriy-tolstoguzov on 6/2/14.
//  Copyright (c) 2014 yuriy-tolstoguzov. All rights reserved.
//

#import "YTCarouselDataSource.h"

#import "YTCarouselCell.h"


@implementation YTCarouselDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YTCarouselCell *collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    collectionViewCell.text = @(indexPath.row).stringValue;
    collectionViewCell.selected = self.selectedIndex == indexPath.row;
    return collectionViewCell;
}

@end
