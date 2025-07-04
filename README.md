# ZZAutoVerticalWaterLayout

1、flowLayout 设置预估大小 estimatedItemSize = CGSize(width: 固定宽度, height: 预估高度)

2、item 内容约束撑开高度

3、item 添加自适应高度代码

override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
    contentView.layoutIfNeeded()
    let targetSize = CGSize(width: layoutAttributes.size.width, height: UIView.layoutFittingCompressedSize.height)
    let autoSize = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    let attributes = layoutAttributes
    attributes.size.height = autoSize.height
    return attributes
}
