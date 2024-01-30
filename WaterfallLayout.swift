//
//  WaterfallLayout.swift
//  ZiYe-iOS
//
//  Created by SunshineDays on 2024/1/26.
//

import Foundation


protocol WaterfallLayoutDelegate: NSObjectProtocol {
    /// 获取流水布局item尺寸
    func waterFlowLayout(_ layout: UICollectionViewFlowLayout, itemSize indexPath: IndexPath) -> CGSize
    /// 获取流水布局每个section一行几个
    func waterFlowLayout(_ layout: UICollectionViewFlowLayout, numberOfColumns section: Int) -> Int
    /// 获取流水布局每个section的边距UIEdgeInsets
    func waterFlowLayout(_ layout: UICollectionViewFlowLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    /// 获取行间距
    func waterFlowLayout(_ layout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    /// 获取item间距
    func waterFlowLayout(_ layout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
}

/// 瀑布流的UICollectionViewFlowLayout
class WaterfallLayout: UICollectionViewFlowLayout {
    // 保存每列的高度
    private var itemHeights = [[CGFloat]]()
        
    private var itemAttributes: [UICollectionViewLayoutAttributes] = []
        
    weak var delegate: WaterfallLayoutDelegate?

    override func prepare() {
        super.prepare()
        
        itemAttributes.removeAll()
        itemHeights.removeAll()

        // 获取 section 的数量
        let sections = collectionView?.numberOfSections ?? 0

        for section in 0 ..< sections {
            let columns = delegate?.waterFlowLayout(self, numberOfColumns: section) ?? 0
            let sectionInsets = delegate?.waterFlowLayout(self, insetForSectionAt: section) ?? .zero
            
            let height = itemHeights.last?.max() ?? 0
            let lastSpacing = delegate?.waterFlowLayout(self, minimumLineSpacingForSectionAt: section - 1) ?? 0
            // 预设高度数组
            itemHeights.append(Array(repeating: height - (section == 0 ? 0 : lastSpacing) + sectionInsets.top, count: columns))
                        
            // 获取 section 中 item 的数量
            let items = collectionView?.numberOfItems(inSection: section) ?? 0

            for item in 0 ..< items {
                // 获取 indexPath 对应的 UICollectionViewLayoutAttributes
                if let attributes = layoutAttributesForItem(at: IndexPath(item: item, section: section)) {
                    itemAttributes.append(attributes)
                }
            }
        }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let _ = collectionView else { return nil }
        
        let section = indexPath.section
        
        let sectionInsets = delegate?.waterFlowLayout(self, insetForSectionAt: section) ?? .zero
                        
        let itemSize = delegate?.waterFlowLayout(self, itemSize: indexPath) ?? .zero
        let width = itemSize.width
        let height = itemSize.height
        
        let itemSpacing = delegate?.waterFlowLayout(self, minimumInteritemSpacingForSectionAt: section) ?? 0
        let lineSpacing = delegate?.waterFlowLayout(self, minimumLineSpacingForSectionAt: section) ?? 0
        
        /// 取出高度最小的
        let minIndex = itemHeights[section].firstIndex(of: itemHeights[section].min() ?? 0) ?? 0
        let x = sectionInsets.left + CGFloat(minIndex) * (width + itemSpacing)
        let y = itemHeights[section][minIndex]

        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = CGRect(x: x, y: y, width: width, height: height)

        // 更新列高度
        itemHeights[section][minIndex] += height + lineSpacing

        return attributes
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return itemAttributes.filter { rect.intersects($0.frame) }
    }

    override var collectionViewContentSize: CGSize {
        let lineSpacing = delegate?.waterFlowLayout(self, minimumLineSpacingForSectionAt: itemHeights.count - 1) ?? 0
        let sectionInsets = delegate?.waterFlowLayout(self, insetForSectionAt: itemHeights.count - 1) ?? .zero

        let maxHeight = itemHeights.last?.max() ?? 0
        return CGSize(width: 0, height: maxHeight - lineSpacing + sectionInsets.bottom)
    }
}
