//
//  CarouselCell.swift
//  ScaledCenterCarouselSwiftExample
//
//  Created by Yuriy Tolstoguzov on 10/20/19.
//  Copyright © 2019 Yuriy Tolstoguzov. All rights reserved.
//

import UIKit

class CarouselCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel?

    var text: String? {
        didSet {
            label?.text = text
        }
    }

    override var isSelected: Bool {
        get {
            super.isSelected
        }
        set {
            super.isSelected = newValue
            label?.textColor = isSelected ? .purple : .darkGray
        }
    }
}
