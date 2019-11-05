import UIKit

class CarouselDataSource: NSObject, UICollectionViewDataSource {
    var selectedIndex = Int(0)

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
                                                            for: indexPath) as? CarouselCell
        else {
            return UICollectionViewCell()
        }

        cell.text = String(indexPath.row)
        cell.isSelected = selectedIndex == indexPath.row
        return cell
    }
}
