//
//  EmoticonView.swift
//  YPTV
//
//  Created by 赖永鹏 on 2019/1/9.
//  Copyright © 2019年 LYP. All rights reserved.
//

import UIKit

private let kEmoticonCellID = "kEmoticonCellID"

class EmoticonView: UIView {
    
    var emoticonClickCallback : ((Emoticon) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

extension EmoticonView {
    fileprivate func setupUI(){
        // 1.创建HYPageCollectionView
        let style = YPPageStyle()
        style.isBottomLineShow = true
        let layout = YPPageCollectionLayout()
        layout.cols = 7
        layout.rows = 3
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let pageCollectionView = YPPageCollectionView(frame: bounds, style: style, titles: ["普通", "粉丝专属"], isTitleTop: false, layout: layout)
        
        // 2.将pageCollectionView添加到view中
        addSubview(pageCollectionView)
        
        // 3.设置pageCollectionView的属性
        pageCollectionView.dataSource = self
        pageCollectionView.delegate = self
        pageCollectionView.register(nib: UINib(nibName: "EmoticonViewCell", bundle: nil), identifier: kEmoticonCellID)
    }
}

extension EmoticonView : YPPageCollectionViewDelegate{
    func pageCollectionView(_ collectionView: YPPageCollectionView, didSelectItemAt indexPath: IndexPath) {
     
        let emoticon = EmoticonViewModel.shareInstance.packages[indexPath.section].emoticonArr[indexPath.item]
        if let emoticonClickCallback = emoticonClickCallback {
            emoticonClickCallback(emoticon)
        }
    }
}

extension EmoticonView : YPPageCollectionViewDataSource {
    func pageNumberOfSections(in collectionView: YPPageCollectionView) -> Int {
        return EmoticonViewModel.shareInstance.packages.count
    }
    
    func pageCollectionView(_ collectionView: YPPageCollectionView, numberOfItemsInSection section: Int) -> Int {
        return EmoticonViewModel.shareInstance.packages[section].emoticonArr.count
    }
    
    func pageCollectionView(_ pageCollectionView: YPPageCollectionView, _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kEmoticonCellID, for: indexPath) as! EmoticonViewCell
        cell.emoticon = EmoticonViewModel.shareInstance.packages[indexPath.section].emoticonArr[indexPath.item]
        return cell
        
    }
}
