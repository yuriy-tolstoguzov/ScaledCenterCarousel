//
//  ViewController.swift
//  ScaledCenterCarouselSwiftExample
//
//  Created by Yuriy Tolstoguzov on 10/20/19.
//  Copyright © 2019 Yuriy Tolstoguzov. All rights reserved.
//

import UIKit
import ScaledCenterCarousel

class ViewController: UIViewController, ScaledCenterCarouselPaginatorDelegate {
    @IBOutlet weak var collectionView: UICollectionView?
    let collectionViewDataSource = CarouselDataSource()
    lazy var paginator = ScaledCenterCarouselPaginator(collectionView: collectionView!, delegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let collectionView = collectionView else { return }
        collectionView.dataSource = collectionViewDataSource
        paginator = ScaledCenterCarouselPaginator(collectionView: collectionView,
                                                  delegate: self)
    }

    // MARK: - CarouselCenterPagerDelegate

    func carousel(_ collectionView: UICollectionView, didSelectElementAt index: UInt) {
    }

    func carousel(_ collectionView: UICollectionView, didScrollTo visibleCells: [UICollectionViewCell]) {
    }
}

