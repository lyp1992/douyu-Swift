//
//  YPPageCollectionView.swift
//  YPTV
//
//  Created by 赖永鹏 on 2019/1/10.
//  Copyright © 2019年 LYP. All rights reserved.
//

import UIKit

protocol YPPageCollectionViewDataSource : class {
    func pageNumberOfSections(in collectionView: YPPageCollectionView) -> Int
   func pageCollectionView(_ collectionView: YPPageCollectionView, numberOfItemsInSection section: Int) -> Int
    func pageCollectionView(_ pageCollectionView : YPPageCollectionView,_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}

protocol YPPageCollectionViewDelegate : class {
    func pageCollectionView(_ collectionView: YPPageCollectionView, didSelectItemAt indexPath: IndexPath)
}

class YPPageCollectionView: UIView {

    weak var dataSource : YPPageCollectionViewDataSource?
    weak var delegate : YPPageCollectionViewDelegate?
    fileprivate var titles : [String]
    fileprivate var isTitleTop : Bool
    fileprivate var style : YPPageStyle
    fileprivate var layout : YPPageCollectionLayout
    fileprivate var titleView : YPTitleView!
    fileprivate var pageControl : UIPageControl!
    fileprivate var collectionView : UICollectionView!
    fileprivate var sourceIndexPath : IndexPath = IndexPath(item: 0, section: 0)
    
    init(frame : CGRect, style : YPPageStyle, titles :[String], isTitleTop : Bool,layout : YPPageCollectionLayout) {
        self.titles = titles
        self.style = style
        self.isTitleTop = isTitleTop
        self.layout = layout
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension YPPageCollectionView {
    fileprivate func setupUI() {
//        1.创建titleView
        let titleY = isTitleTop ? 0 : bounds.height - style.titleHeight
        let titleFrame = CGRect(x: 0, y:titleY , width: bounds.width, height: style.titleHeight)
        let titleView = YPTitleView(frame: titleFrame, titles: titles, style: style)
        addSubview(titleView)
        titleView.delegate = self
        
//        2.创建pageController
        let pageControlHeight : CGFloat = 20
        let pageControlY = isTitleTop ? (bounds.height - pageControlHeight) : (bounds.height - pageControlHeight - style.titleHeight)
        let pageFrame = CGRect(x: 0, y: pageControlY, width: bounds.width, height: pageControlHeight)
        pageControl = UIPageControl(frame: pageFrame)
        pageControl.numberOfPages = 4
        pageControl.isEnabled = false
        addSubview(pageControl)
        
//        3.创建UICollectionView
        let collectionViewY = isTitleTop ? style.titleHeight : 0
        let collectionViewFrame = CGRect(x: 0, y: collectionViewY, width: bounds.width, height: bounds.height - style.titleHeight - pageControlHeight)
        collectionView = UICollectionView(frame: collectionViewFrame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = false
        addSubview(collectionView)
        pageControl.backgroundColor = collectionView.backgroundColor
    }
}


// MARK:- 对外暴露的方法
extension YPPageCollectionView {
    func register(cell : AnyClass?, identifier : String) {
        collectionView.register(cell, forCellWithReuseIdentifier: identifier)
    }
    
    func register(nib : UINib, identifier : String) {
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
}

extension YPPageCollectionView : YPTitleViewDelegate {
    func titleView(_ titleView: YPTitleView, selectedIndex index: Int) {
        print(index)
        let indexPath = IndexPath(item: 0, section: index)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        collectionView.contentOffset.x -= layout.sectionInset.left
        
        scrollViewEndScroll()
    }

}

extension YPPageCollectionView : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.pageNumberOfSections(in: self) ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let itemCount = dataSource?.pageCollectionView(self, numberOfItemsInSection: section) ?? 0
        if section == 0 {
            pageControl.numberOfPages = (itemCount - 1)/(layout.cols * layout.rows) + 1
        }
        
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dataSource!.pageCollectionView(self, collectionView, cellForItemAt: indexPath)
    }
    
    
}

extension YPPageCollectionView : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.pageCollectionView(self, didSelectItemAt: indexPath)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewEndScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollViewEndScroll()
        }
    }
    
    fileprivate func scrollViewEndScroll() {
        // 1.取出在屏幕中显示的Cell
        let point = CGPoint(x: layout.sectionInset.left + 1 + collectionView.contentOffset.x, y: layout.sectionInset.top + 1)
        
        guard let indexpath = collectionView.indexPathForItem(at: point) else {
            return
        }
        // 2.判断分组是否有发生改变
        if sourceIndexPath.section != indexpath.section{
//            2.1 修改pageControl的个数
            let itemCount = dataSource?.pageCollectionView(self, numberOfItemsInSection: indexpath.section) ?? 0
            pageControl.numberOfPages = (itemCount - 1) / (layout.cols * layout.rows) + 1
            
//            2.2 设置titleView的位置
            titleView.setTitleWithProgress(1.0, sourceIndex: sourceIndexPath.section, targetIndex: indexpath.section)
//            2.3 记录新的sourceindexPath
            sourceIndexPath = indexpath
        }
        
        // 3.根据indexPath设置pageControl
        pageControl.currentPage = indexpath.item / (layout.cols * layout.rows)
    }
    
}
