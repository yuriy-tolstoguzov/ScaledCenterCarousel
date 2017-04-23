//
//  ScaledCenterCarouselTests.m
//  ScaledCenterCarouselTests
//
//  Created by yuriy-tolstoguzov on 04/23/2017.
//  Copyright (c) 2017 yuriy-tolstoguzov. All rights reserved.
//

// https://github.com/Specta/Specta

#import <ScaledCenterCarousel/YTScaledCenterCarouselLayout.h>
#import "YTCollectionViewTestDataSource.h"


SpecBegin(InitialSpecs)

describe(@"YTScaledCenterCarouselLayout", ^{

    __block YTScaledCenterCarouselLayout *layout;
    __block UICollectionView *containingCollectionView;
    __block YTCollectionViewTestDataSource *dataSource;
    CGRect collectionViewFrame = CGRectMake(0, 0, 100, 100);

    beforeAll(^{
        layout = [[YTScaledCenterCarouselLayout alloc] init];
        layout.centerCellHeight = 10;
        layout.centerCellWidth = 15;
        layout.normalCellHeight = 5;
        layout.normalCellWidth = 7;

        containingCollectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:layout];
        dataSource = [[YTCollectionViewTestDataSource alloc] init];
        dataSource.numberOfItems = 1;
        containingCollectionView.dataSource = dataSource;
    });

    beforeEach(^{
        layout.ignoringBoundsChange = NO;
    });
    
    it(@"can be created", ^{
        expect(layout).toNot.beNil();
    });
    
    it(@"properly initialized", ^{
        expect(layout.centerCellHeight).to.equal(10);
        expect(layout.centerCellWidth).to.equal(15);
        expect(layout.normalCellHeight).to.equal(5);
        expect(layout.normalCellWidth).to.equal(7);
    });

    it(@"creates layout", ^{
        [layout prepareLayout];
        NSIndexPath *firstIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        UICollectionViewLayoutAttributes *attributes = [layout layoutAttributesForItemAtIndexPath:firstIndexPath];
        expect(attributes).toNot.beNil();
    });

    it(@"place items in frame initially", ^{
        NSArray *attributes = [layout layoutAttributesForElementsInRect:collectionViewFrame];
        expect(attributes.count).to.equal(1);
    });

    it(@"returns content size", ^{
        CGSize contentSize = [layout collectionViewContentSize];
        expect(contentSize).to.equal(CGSizeMake(100, 5));
    });

    it(@"ignores bounds changes when flag is set", ^{
        layout.ignoringBoundsChange = YES;
        expect([layout shouldInvalidateLayoutForBoundsChange:CGRectZero]).to.beFalsy();
    });

});

SpecEnd
