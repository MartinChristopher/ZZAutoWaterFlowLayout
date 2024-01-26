//
//  ZZAutoWaterFlowLayout.swift
//

import UIKit

public class ZZAutoWaterFlowLayout: UICollectionViewFlowLayout {
    // 列数
    public var columnCount: Int = 2
    
    private var contentHeight: CGFloat = 0.0
    
    private lazy var columnHeights: [CGFloat] = []
    
    private lazy var attributesSource: [[UICollectionViewLayoutAttributes]] = []
    
    public override func prepare() {
        super.prepare()
        contentHeight = 0.0
        columnHeights.removeAll()
        attributesSource.removeAll()
        
        for _ in 0..<columnCount {
            columnHeights.append(0.0)
        }
        guard let sections = collectionView?.numberOfSections else { return }
        for i in 0..<sections {
            guard let items = collectionView?.numberOfItems(inSection: i) else { return }
            var attributesArray: [UICollectionViewLayoutAttributes] = []
            for j in 0..<items {
                let indexPath = IndexPath(item: j, section: i)
                guard let attributes = layoutAttributesForItem(at: indexPath) else { return }
                attributesArray.append(attributes)
            }
            self.attributesSource.append(attributesArray)
        }
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributesArray: [UICollectionViewLayoutAttributes] = []
        for i in 0..<attributesSource.count {
            for j in 0..<attributesSource[i].count {
                let attributes = attributesSource[i][j]
                if attributes.frame.intersects(rect) {
                    attributesArray.append(attributes)
                }
            }
        }
        return attributesArray
    }
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        let superAttributes = super.layoutAttributesForItem(at: indexPath)
        guard let itemSize = superAttributes?.size else {
            return superAttributes
        }
        var minColumnHeight = columnHeights[0]
        var minColumn: Int = 0
        for i in 1..<columnCount {
            let columnHeight = columnHeights[i]
            if columnHeight < minColumnHeight {
                minColumnHeight = columnHeight
                minColumn = i
            }
        }
        let itemX: CGFloat = sectionInset.left + CGFloat(minColumn) * (itemSize.width + minimumInteritemSpacing)
        let itemY: CGFloat = minColumnHeight + minimumLineSpacing
        attributes.frame = CGRect(x: itemX, y: itemY, width: itemSize.width, height: itemSize.height)
        let maxY = itemY + itemSize.height
        columnHeights[minColumn] = maxY
        let maxContentHeight = columnHeights[minColumn]
        if contentHeight < maxContentHeight {
            contentHeight = maxContentHeight
        }
        return attributes
    }
    
    public override var collectionViewContentSize: CGSize {
        get {
            let collectionSize = super.collectionViewContentSize
            return CGSize(width: collectionSize.width, height: contentHeight + sectionInset.bottom)
        }
        set {
            self.collectionViewContentSize = newValue
        }
    }
    
}
