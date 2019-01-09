//
//  AnchorViewController.swift
//  YPTV
//
//  Created by 赖永鹏 on 2018/12/12.
//  Copyright © 2018年 LYP. All rights reserved.
//

import UIKit
private let kEdgeMargin : CGFloat = 8
private let kAnchorCellId = "anchorCellID"

class AnchorViewController: UIViewController {

    var homeType : HomeType!
    fileprivate var homeVM : HomeViewModel = HomeViewModel()
//    创建UI
    fileprivate lazy var collectionView : UICollectionView = {
        
//        创建b瀑布流
        let flowLayout = YPWaterFallLayout()
        flowLayout.sectionInset = UIEdgeInsets(top:kEdgeMargin , left: kEdgeMargin, bottom: kEdgeMargin, right: kEdgeMargin)
        flowLayout.minimumLineSpacing = kEdgeMargin
        flowLayout.minimumInteritemSpacing = kEdgeMargin
        flowLayout.dataSource = self;
        
       let collectionView = UICollectionView (frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.register(UINib(nibName: "HomeViewCell", bundle: nil), forCellWithReuseIdentifier: kAnchorCellId)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = UIColor.white
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData(index: 0)
        
    }

}

extension AnchorViewController {
    fileprivate func setupUI(){
        view.addSubview(collectionView)
    }
}

extension AnchorViewController {
    
    fileprivate  func  loadData(index: Int){
    
        homeVM.loadHomeData(type: homeType, index: index, finishCallback: {
            self.collectionView.reloadData()
        })
    }
}

//MARK: 数据源代理
extension AnchorViewController : UICollectionViewDelegate,UICollectionViewDataSource,YPWaterFallLayoutDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeVM.anchorModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kAnchorCellId, for: indexPath) as!HomeViewCell
        cell.anchorModel = homeVM.anchorModels[indexPath.item]
        if indexPath.item == homeVM.anchorModels.count - 1 {
            loadData(index: homeVM.anchorModels.count)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        let roomVC = RoomViewController()
        navigationController?.pushViewController(roomVC, animated: true)
        
    }
    
//    设置宽度
    func waterFallLayout(_ layout: YPWaterFallLayout, indexPath: IndexPath) -> CGFloat {
        return indexPath.item%2 == 0 ? kScreenW/3 : kScreenW*0.5
    }
    
}
