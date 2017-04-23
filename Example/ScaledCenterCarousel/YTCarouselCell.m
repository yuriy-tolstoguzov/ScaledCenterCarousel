//
//  AELCollectionViewCell.m
//  ScaledCenterCarousel
//
//  Created by yuriy-tolstoguzov on 6/2/14.
//  Copyright (c) 2014 yuriy-tolstoguzov. All rights reserved.
//

#import "YTCarouselCell.h"


@interface YTCarouselCell ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end


@implementation YTCarouselCell

- (void)setText:(NSString *)text {
    self.label.text = text;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];

    self.label.textColor = selected ? [UIColor purpleColor] : [UIColor darkGrayColor];
}

@end
