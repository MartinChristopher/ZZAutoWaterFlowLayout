//
//  ZZAutoVerticalWaterLayout.swift
//
//  竖直滚动 自适应高度 瀑布流

import UIKit

class ZZAutoVerticalWaterLayout: UICollectionViewFlowLayout {
    // 列数
    var columnCount: Int = 2
    
    private var contentHeight: CGFloat = 0.0
    
    private lazy var columnHeights: [CGFloat] = []
    
    private lazy var attributesSource: [[UICollectionViewLayoutAttributes]] = []
    
    override func prepare() {
        super.prepare()
        // 重置内容高度和各列高度
        contentHeight = 0.0
        columnHeights = Array(repeating: sectionInset.top, count: columnCount)
        attributesSource.removeAll()
        scrollDirection = .vertical
        
        guard let collectionView = collectionView else { return }
        for section in 0..<collectionView.numberOfSections {
            var attributesArray: [UICollectionViewLayoutAttributes] = []
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                if let attributes = layoutAttributesForItem(at: indexPath) {
                    attributesArray.append(attributes)
                }
            }
            attributesSource.append(attributesArray)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
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
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        guard let itemSize = super.layoutAttributesForItem(at: indexPath)?.size else { return nil }
        // 找出当前最短列
        let (minColumn, minHeight) = findMinColumn()
        // 计算item布局位置
        let itemX = sectionInset.left + CGFloat(minColumn) * (itemSize.width + minimumInteritemSpacing)
        let itemY = minHeight + minimumLineSpacing
        attributes.frame = CGRect(x: itemX, y: itemY, width: itemSize.width, height: itemSize.height)
        // 更新该列高度和内容高度
        let newHeight = itemY + itemSize.height
        columnHeights[minColumn] = newHeight
        contentHeight = max(contentHeight, newHeight)
        return attributes
    }
    // 找到当前所有列中高度最小的列及其高度
    private func findMinColumn() -> (index: Int, height: CGFloat) {
        guard let first = columnHeights.first else { return (0, 0) }
        var minIndex = 0
        var minHeight = first
        for (index, height) in columnHeights.enumerated() where height < minHeight {
            minIndex = index
            minHeight = height
        }
        return (minIndex, minHeight)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override var collectionViewContentSize: CGSize {
        let width = collectionView?.bounds.width ?? 0
        return CGSize(width: width, height: contentHeight + sectionInset.bottom)
    }
    
}

// 1、flowLayout 设置预估大小 estimatedItemSize = CGSize(width: 固定宽度, height: CGFloat(MAXFLOAT))

// 2、item 内容约束撑开高度

// 3、item 更新布局 contentView.layoutIfNeeded()

// 4、item 添加自适应高度代码
/*
override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
    let targetSize = CGSize(width: layoutAttributes.size.width, height: UIView.layoutFittingCompressedSize.height)
    let autoSize = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    let attributes = layoutAttributes
    attributes.size.height = autoSize.height
    return attributes
}
*/
