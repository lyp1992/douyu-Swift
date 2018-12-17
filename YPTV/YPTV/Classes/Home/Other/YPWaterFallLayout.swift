//
//  YPWaterFallLayout.swift
//  YPWaterFallLayout
//
//  Created by 赖永鹏 on 2018/12/3.
//  Copyright © 2018年 LYP. All rights reserved.
//

import UIKit

@objc protocol YPWaterFallLayoutDataSource : class{
    func waterFallLayout(_ layout : YPWaterFallLayout , indexPath : IndexPath) -> CGFloat
    @objc optional func waterFallLayout(_ layout : YPWaterFallLayout) -> Int
}

class YPWaterFallLayout: UICollectionViewFlowLayout {

    weak var dataSource : YPWaterFallLayoutDataSource?
    fileprivate lazy var cols : Int = Int(self.dataSource?.waterFallLayout?(self) ?? 2)
    
    fileprivate lazy var cellAttrs : [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    fileprivate lazy var colHeights : [CGFloat] = Array(repeating: self.sectionInset.top, count: self.cols)
    
}

//准备布局
extension YPWaterFallLayout {
    override func prepare() {
        super.prepare()
        
//        1. 检验collectionview是否有值
        
        guard let collectionView = collectionView else {
            return
        }
        
//        2. 获取cell的个数
        let count = collectionView.numberOfItems(inSection: 0)
        
//        3. 遍历所有的cell，计算出frame
        let itemW = (collectionView.bounds.width - sectionInset.left - sectionInset.right - (CGFloat(cols) - 1)*minimumInteritemSpacing) / CGFloat(cols)
        for i in cellAttrs.count..<count {
//            3.1 创建attribute
            let indexPath = IndexPath(item: i, section: 0)
            let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
//            3.2 计算高度
            let itemH = dataSource?.waterFallLayout(self, indexPath: indexPath) ?? 0
//            3.3 计算x值
            let minH = colHeights.min()!
            let minIndex = colHeights.index(of: minH)!
            let itemX = sectionInset.left + CGFloat(minIndex) * (itemW + minimumInteritemSpacing)
//            3.4 计算Y值
            let itemY = minH
            
//            3.5 设置frame
            attr.frame = CGRect(x: itemX, y: itemY, width: itemW, height: itemH)
            
//            3.6 给minIndex附上新值
            colHeights[minIndex] = attr.frame.maxY + minimumLineSpacing
            
//            将attr添加到attrs中
            cellAttrs.append(attr)
        }
        
    }
}

// 返回准备好的布局

extension YPWaterFallLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cellAttrs
    }
    
}

//设置可滚动区域
extension YPWaterFallLayout {
    override var collectionViewContentSize : CGSize {
        
        return CGSize(width: 0, height: colHeights.max()! + sectionInset.bottom - minimumLineSpacing)
    }
}

