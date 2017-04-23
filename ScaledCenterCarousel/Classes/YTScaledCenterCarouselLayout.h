//
//  YTScaledCenterCarouselLayout.h
//  ScaledCenterCarousel
//
//  Created by yuriy-tolstoguzov on 6/2/14.
//  Copyright (c) 2014 yuriy-tolstoguzov. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YTScaledCenterCarouselLayout : UICollectionViewLayout

@property (assign, nonatomic) IBInspectable CGFloat centerCellHeight;
@property (assign, nonatomic) IBInspectable CGFloat centerCellWidth;

@property (assign, nonatomic) IBInspectable CGFloat normalCellHeight;
@property (assign, nonatomic) IBInspectable CGFloat normalCellWidth;

@property (assign, nonatomic) IBInspectable CGPoint proposedContentOffset;

@property (assign, nonatomic, getter=isIgnoringBoundsChange) BOOL ignoringBoundsChange;

@end
