//
//  ZZAutoHorizontalWaterLayout.swift
//
//  水平滚动 自适应宽度 瀑布流

import UIKit

class ZZAutoHorizontalWaterLayout: UICollectionViewFlowLayout {
    // 行数
    var rowCount: Int = 2
    
    private var contentWidth: CGFloat = 0.0
    
    private lazy var columnWidths: [CGFloat] = []
    
    private lazy var attributesSource: [[UICollectionViewLayoutAttributes]] = []
    
    override func prepare() {
        super.prepare()
        // 重置内容宽度和各行宽度
        contentWidth = 0.0
        columnWidths = Array(repeating: sectionInset.left, count: rowCount)
        attributesSource.removeAll()
        scrollDirection = .horizontal
        
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
        // 找出当前最短行
        let (minRow, minWidth) = findMinRow()
        // 计算item布局位置
        let itemX = minWidth + minimumLineSpacing
        let itemY = sectionInset.top + CGFloat(minRow) * (itemSize.height + minimumInteritemSpacing)
        attributes.frame = CGRect(x: itemX, y: itemY, width: itemSize.width, height: itemSize.height)
        // 更新该行宽度和内容宽度
        let newWidth = itemX + itemSize.width
        columnWidths[minRow] = newWidth
        contentWidth = max(contentWidth, newWidth)
        return attributes
    }
    // 找到当前所有行中宽度最小的行及其宽度
    private func findMinRow() -> (index: Int, width: CGFloat) {
        guard let first = columnWidths.first else { return (0, 0) }
        var minIndex = 0
        var minWidth = first
        for (index, width) in columnWidths.enumerated() where width < minWidth {
            minIndex = index
            minWidth = width
        }
        return (minIndex, minWidth)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override var collectionViewContentSize: CGSize {
        let height = collectionView?.bounds.height ?? 0
        return CGSize(width: contentWidth + sectionInset.right, height: height)
    }
    
}
