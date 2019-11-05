//
//  ScaledCenterCarouselLayout.swift
//  ScaledCenterCarousel
//
//  Created by Yuriy Tolstoguzov on 10/19/19.
//  Copyright © 2019 Yuriy Tolstoguzov. All rights reserved.
//

import UIKit

open class ScaledCenterCarouselLayout: UICollectionViewLayout {
    @IBInspectable open var centerCell = CGSize.zero
    @IBInspectable open var normalCell = CGSize.zero

    @IBInspectable open var proposedContentOffset: CGPoint = CGPoint(x: NSNotFound, y: 0)
    public let defaultProposedContentOffset = CGPoint(x: NSNotFound, y: 0)

    @IBInspectable open var isIgnoringBoundsChange = false

    private var layoutInformation: [UICollectionViewLayoutAttributes]?
    private var currentVisibleRect = CGRect.zero

    public init(centerCellSize: CGSize, normalCellSize: CGSize) {
        self.centerCell = centerCellSize
        self.normalCell = normalCellSize
        super.init()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    open override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else { return .zero }
        let numberOfItems = CGFloat(collectionView.numberOfItems(inSection: 0))
        let sideSpace = (collectionView.bounds.size.width - centerCell.width) / 2
        let width = normalCell.width * (numberOfItems - 1) + centerCell.width + sideSpace * 2
        return CGSize(width: width, height: normalCell.height)
    }

    open override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else { return }
        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        currentVisibleRect = collectionView.bounds
        self.layoutInformation = (0..<numberOfItems).map {
            UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: $0, section: 0))
        }
        updateLayout(for: currentVisibleRect)
    }

    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutInformation?[indexPath.item]
    }

    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return layoutInformation?.filter { $0.frame.intersects(rect) }
    }

    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        currentVisibleRect = newBounds
        return !self.isIgnoringBoundsChange
    }

    func updateLayout(for bounds: CGRect) {
        let deltaX = centerCell.width - normalCell.width
        let deltaY = centerCell.height - normalCell.height
        let leftSideInset = (bounds.width - centerCell.width) / 2

        for attribute in layoutInformation ?? [] {
            let normalCellOffsetX = leftSideInset + CGFloat(attribute.indexPath.item) * normalCell.width
            let normalCellOffsetY = (bounds.height - normalCell.height) / 2

            let distanceBetweenCellAndBoundCenters = normalCellOffsetX - bounds.midX + centerCell.width / 2
            // normalizedCenterScale has range (- 1 ... 1), 0 - cell placed at center of bounds
            let normalizedCenterScale = distanceBetweenCellAndBoundCenters / normalCell.width

            let isCenterCell = abs(normalizedCenterScale) < 1
            let isNormalCellOnRightOfCenter = normalizedCenterScale > 0 && !isCenterCell
            let isNormalCellOnLeftOfCenter = normalizedCenterScale < 0 && !isCenterCell

            if isCenterCell {
                let incrementX = (1 - abs(normalizedCenterScale)) * deltaX
                let incrementY = (1 - abs(normalizedCenterScale)) * deltaY
                let offsetX = normalizedCenterScale > 0 ? deltaX - incrementX : 0
                let offsetY = -incrementY / 2

                attribute.frame = CGRect(x: normalCellOffsetX + offsetX,
                                         y: normalCellOffsetY + offsetY,
                                         width: normalCell.width + incrementX,
                                         height: normalCell.height + incrementY)
            } else if isNormalCellOnRightOfCenter {
                attribute.frame = CGRect(x: normalCellOffsetX + deltaX,
                                         y: normalCellOffsetY,
                                         width: normalCell.width,
                                         height: normalCell.height)
            } else if isNormalCellOnLeftOfCenter {
                attribute.frame = CGRect(x: normalCellOffsetX,
                                         y: normalCellOffsetY,
                                         width: normalCell.width,
                                         height: normalCell.height)
            }

        }
    }

    open override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        if self.proposedContentOffset.x != CGFloat(NSNotFound) {
            let proposedContentOffset = self.proposedContentOffset
            self.proposedContentOffset = defaultProposedContentOffset
            return proposedContentOffset
        } else {
            return proposedContentOffset
        }
    }
}
