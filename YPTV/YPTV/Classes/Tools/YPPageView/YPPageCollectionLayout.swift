//
//  YPPageCollectionLayout.swift
//  YPTV
//
//  Created by 赖永鹏 on 2019/1/10.
//  Copyright © 2019年 LYP. All rights reserved.
//

import UIKit

class YPPageCollectionLayout: UICollectionViewFlowLayout {

    var cols : Int = 4
    var rows : Int = 2
    
    fileprivate lazy var cellAttrs : [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    fileprivate lazy var maxWidth : CGFloat = 0
    
}

extension YPPageCollectionLayout {
    
    override func prepare() {
        super.prepare()
//        0.计算item的宽度和高度
        let itemW = (collectionView!.bounds.width - sectionInset.left - sectionInset.right - minimumInteritemSpacing * CGFloat(cols - 1))/CGFloat(cols)
        let itemH = (collectionView!.bounds.height - sectionInset.top - sectionInset.bottom - minimumLineSpacing * CGFloat(rows - 1))/CGFloat(rows)
        
//        1.获取一共多少组
        let sectionCount = collectionView!.numberOfSections
        
//        2.获取每组有多少item
        var  prePageCount : Int = 0
        for i in 0..<sectionCount {
            let itemCount = collectionView!.numberOfItems(inSection: i)
            for j in 0..<itemCount {
//                2.1 获取item对应的indexpath
                let indexPath = IndexPath(item: j, section: i)
//                2.2 根据indexpath创建UICollectionViewLayoutAttributes
                let  attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
//                2.3 计算j在该组中的第几页
                let page = j / (rows * cols)
                let index = j % (rows * cols)
                
//                2.4 设置frame
                let itemY = sectionInset.top + (itemH + minimumLineSpacing) * CGFloat(index/cols)
                let itemX = CGFloat(prePageCount + page) * collectionView!.bounds.width + sectionInset.left + (itemW + minimumInteritemSpacing) * CGFloat (index%cols)
                attr.frame = CGRect(x: itemX, y: itemY, width: itemW, height: itemH)
                
//                2.5 保存attr到数组中
                cellAttrs.append(attr)
            }
            prePageCount += (itemCount - 1) / (cols * rows) + 1
        }
        
//        3.计算最大的Y值
        
        maxWidth = CGFloat(prePageCount) * collectionView!.bounds.width
    }
    
}

extension YPPageCollectionLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cellAttrs
    }
}

extension YPPageCollectionLayout {
    
    override var collectionViewContentSize: CGSize{
        return CGSize(width: maxWidth, height: 0)
    }
}
