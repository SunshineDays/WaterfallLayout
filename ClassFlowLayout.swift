//
//  ClassFlowLayout.swift
//  ZiYe-iOS
//
//  Created by SunshineDays on 2024/1/30.
//

import Foundation

/// 让内容左对齐
class ClassFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        
        for (i, attribute) in attributes.enumerated() {
            if attribute.representedElementKind == nil {
                if let lastAttribute = attributes[safe: i - 1] {
                    if attribute.frame.minX - lastAttribute.frame.maxX > minimumInteritemSpacing {
                        attribute.frame.origin.x = lastAttribute.frame.maxX + minimumInteritemSpacing
                    }
                }
            }
        }
        return attributes
    }
}
