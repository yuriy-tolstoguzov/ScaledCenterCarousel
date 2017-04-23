//
//  YTCollectionViewTestDataSource.m
//  ScaledCenterCarousel
//
//  Created by yuriy-tolstoguzov on 4/23/17.
//  Copyright © 2017 yuriy-tolstoguzov. All rights reserved.
//

#import "YTCollectionViewTestDataSource.h"


@implementation YTCollectionViewTestDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.numberOfItems;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [[UICollectionViewCell alloc] init];
}

@end
