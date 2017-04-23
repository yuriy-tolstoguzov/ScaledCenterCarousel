//
//  AELCarouselDataSource.h
//  ScaledCenterCarousel
//
//  Created by yuriy-tolstoguzov on 6/2/14.
//  Copyright (c) 2014 yuriy-tolstoguzov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ScaledCenterCarousel/YTScaledCenterCarouselPaginator.h>


@interface YTCarouselDataSource : NSObject <UICollectionViewDataSource, YTScaledCenterCarouselDataSource>

@property (assign, nonatomic) NSUInteger selectedIndex;

@end
