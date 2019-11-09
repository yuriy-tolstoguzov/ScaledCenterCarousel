//
//  ScaledCenterCarouselPaginator.swift
//  ScaledCenterCarousel
//
//  Created by Yuriy Tolstoguzov on 10/19/19.
//  Copyright © 2019 Yuriy Tolstoguzov. All rights reserved.
//

import UIKit

enum NearestPointDirection {
    case any
    case left
    case right
}

public protocol ScaledCenterCarouselPaginatorDelegate {
    func carousel(_ collectionView: UICollectionView, didSelectElementAt index: UInt)
    func carousel(_ collectionView: UICollectionView, didScrollTo visibleCells: [UICollectionViewCell])
}

public protocol ScaledCenterCarouselDataSource: UICollectionViewDataSource {
    var selectedIndex: UInt { get set }
}

open class ScaledCenterCarouselPaginator: NSObject, UICollectionViewDelegate {

    public let delegate: ScaledCenterCarouselPaginatorDelegate
    public var selectedIndex = UInt(0)

    private var scrollVelocity = CGFloat(0)
    private var collectionView: UICollectionView
    private var collectionViewCenter: CGFloat {
        return collectionView.bounds.width / 2
    }

    public init(collectionView: UICollectionView, delegate: ScaledCenterCarouselPaginatorDelegate) {
        self.collectionView = collectionView
        self.delegate = delegate
        super.init()
        self.collectionView.delegate = self
    }

    // MARK: - UICollectionViewDelegate

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard selectedIndex != UInt.max else { return }

        let previousSelectedIndex = selectedIndex
        if let dataSource = collectionView.dataSource as? ScaledCenterCarouselDataSource {
            dataSource.selectedIndex = selectedIndex
        }
        selectedIndex = UInt.max
        self.reloadCell(at: IndexPath(item: Int(previousSelectedIndex), section: 0),
                        withSelectedState: false)
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let dataSource = collectionView.dataSource as? ScaledCenterCarouselDataSource {
            dataSource.selectedIndex = selectedIndex
        }

        self.reloadCell(at: IndexPath(item: Int(selectedIndex), section: 0), withSelectedState: false)

        delegate.carousel(collectionView, didScrollTo: collectionView.visibleCells)
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        self.scrollViewWillBeginDragging(collectionView)

        selectedIndex = UInt(indexPath.item)
        delegate.carousel(collectionView, didSelectElementAt: selectedIndex)

        if let layout = collectionView.collectionViewLayout as? ScaledCenterCarouselLayout {
            let xPosition = CGFloat(selectedIndex) * layout.normalCell.width
            layout.isIgnoringBoundsChange = true
            collectionView.setContentOffset(CGPoint(x: xPosition, y: 0), animated: true)
            layout.isIgnoringBoundsChange = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.scrollViewDidEndDecelerating(collectionView)
            }
        }
    }

    // MARK: - Utility methods

    private func offset(forCenterX centerX: CGFloat, withDirection direction: NearestPointDirection) -> CGPoint {
        let leftNearestCenter = nearestLeftCenter(forCenterX: centerX)
        let leftCenterIndex = leftNearestCenter.index
        let leftCenter = leftNearestCenter.distance
        let rightNearestCenter = nearestRightCenter(forCenterX: centerX)
        let rightCenterIndex = rightNearestCenter.index
        let rightCenter = rightNearestCenter.distance

        var nearestItemIndex = UInt(NSNotFound)
        switch direction {
        case .any:
            if (leftCenter > rightCenter) {
                nearestItemIndex = rightCenterIndex
            }
            else {
                nearestItemIndex = leftCenterIndex
            }
        case .left:
            nearestItemIndex = leftCenterIndex
        case .right:
            nearestItemIndex = rightCenterIndex
        }

        selectedIndex = nearestItemIndex

        if selectedIndex != NSNotFound {
            delegate.carousel(collectionView, didSelectElementAt: selectedIndex)
        }

        if let layout = collectionView.collectionViewLayout as? ScaledCenterCarouselLayout {
            return CGPoint(x: CGFloat(nearestItemIndex) * layout.normalCell.width, y: 0)
        } else {
            return .zero
        }
    }

    public func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                          withVelocity velocity: CGPoint,
                                          targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        scrollVelocity = velocity.x
        var direction: NearestPointDirection
        if scrollVelocity == 0 {
            direction = .any
        } else if scrollVelocity < 0 {
            direction = .left
        } else {
            direction = .right
        }
        targetContentOffset.pointee = offset(forCenterX: targetContentOffset.pointee.x + collectionViewCenter,
                                             withDirection: direction)
    }

    func nearestLeftCenter(forCenterX centerX: CGFloat) -> (index: UInt, distance: CGFloat) {
        guard let layout = collectionView.collectionViewLayout as? ScaledCenterCarouselLayout else { return (0, 0) }

        let nearestLeftElementIndex = (centerX - collectionViewCenter - layout.centerCell.width
            + layout.normalCell.width) / layout.normalCell.width
        let minimumLeftDistance = centerX - nearestLeftElementIndex * layout.normalCell.width - collectionView.bounds.width / 2 - layout.centerCell.width + layout.normalCell.width
        return (UInt(nearestLeftElementIndex), minimumLeftDistance)
    }

    func nearestRightCenter(forCenterX centerX: CGFloat) -> (index: UInt, distance: CGFloat) {
        guard let layout = collectionView.collectionViewLayout as? ScaledCenterCarouselLayout else { return (0, 0) }

        let nearestRightElementIndex = ceil(centerX - collectionViewCenter - layout.centerCell.width
            + layout.normalCell.width) / layout.normalCell.width
        let minimumRightDistance = nearestRightElementIndex * layout.normalCell.width + collectionViewCenter
            - centerX - layout.centerCell.width + layout.normalCell.width
        return (UInt(nearestRightElementIndex), minimumRightDistance)
    }

    func reloadCell(at indexPath: IndexPath, withSelectedState isSelected: Bool) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.isSelected = isSelected
    }
}
