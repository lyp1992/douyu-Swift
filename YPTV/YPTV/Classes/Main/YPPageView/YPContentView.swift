//
//  YPContentView.swift
//  YPPageView
//
//  Created by 赖永鹏 on 2018/11/22.
//  Copyright © 2018年 LYP. All rights reserved.
//

import UIKit

protocol YPContentViewDelegate : class {
    func contentView(_ contentView : YPContentView,inIndex : Int)
    func contentView(_ contentView : YPContentView,sourceIndex : Int,targetIndex : Int,progress : CGFloat)
}

private let collectionID = "YPcellID"

class YPContentView: UIView {

    weak var delegate : YPContentViewDelegate?
   fileprivate var childVCs : [UIViewController]
   fileprivate var parentVC : UIViewController
   fileprivate var startOffsetX : CGFloat = 0
    fileprivate var isForbidDelegate : Bool = false
    
    fileprivate lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = self.bounds.size
        
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: collectionID)
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.scrollsToTop = false
        collectionView.bounces = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
        
    }()

    init(frame : CGRect,childVCs : [UIViewController], parentVC : UIViewController) {
        self.childVCs = childVCs
        self.parentVC = parentVC
        super.init(frame: frame)
        setupUI()
    
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) has not been immplement")
    }
    
}

extension YPContentView {
    fileprivate func setupUI(){
        addSubview(collectionView)
        
        for childVC in childVCs {
            childVC.view.backgroundColor = UIColor.randomColor
            parentVC.addChildViewController(childVC)
        }
    }
}

extension YPContentView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVCs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionID, for: indexPath)
        
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        let childVC  = childVCs[indexPath.row]
        childVC.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVC.view)
        
        return cell
        
    }
}

extension YPContentView : UICollectionViewDelegate {
    
//    开始滚动
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidDelegate = false
        startOffsetX = scrollView.contentOffset.x
    }
    
//    已经在滚动
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
//        判断是否需要执行后面的代码
        if scrollView.contentOffset.x == startOffsetX || isForbidDelegate == true{
            return
        }
        
//        定义参数
        var progress : CGFloat = 0
        var targetIndex = 0
        let sourceIndex = Int(startOffsetX / collectionView.bounds.width)
        
//        判断用户左移还是右移
        if collectionView.contentOffset.x > startOffsetX{
            //左移
            targetIndex = sourceIndex + 1
            progress = (collectionView.contentOffset.x - startOffsetX)/collectionView.bounds.width
            
        }else{
            //右移
            targetIndex = sourceIndex - 1
            progress = (startOffsetX - collectionView.contentOffset.x)/collectionView.bounds.width
        }
        
        delegate?.contentView(self, sourceIndex: sourceIndex, targetIndex: targetIndex, progress: progress)
        
    }
    
//    滚动完成
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        collectionViewDidEndDraging()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            collectionViewDidEndDraging()
        }
    }
    
    func collectionViewDidEndDraging() {
    
//        获取位置
        let index = collectionView.contentOffset.x/collectionView.bounds.width
        delegate?.contentView(self, inIndex: Int(index))
        
    }
    
}

extension YPContentView : YPTitleViewDelegate {
    func titleView(_ titleView: YPTitlesView, currentIndex: Int) {
        isForbidDelegate = true
//        取出当前item的indexopath
        let indexPath = IndexPath(item: currentIndex, section: 0)
        
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
}
