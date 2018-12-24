//
//  HomeViewController.swift
//  YPTV
//
//  Created by 赖永鹏 on 2018/12/10.
//  Copyright © 2018年 LYP. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

}

extension HomeViewController {
    
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.white
        setupNavgationBar()
        setupContentView()
    }
    
    fileprivate func setupNavgationBar() {
//        左
        let imageLeft = UIImage(named: "home-logo")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: imageLeft, style: .plain, target: nil, action: nil)
        
//        右
        let imageRight = UIImage(named: "search_btn_follow")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: imageRight, style: .plain, target: self, action: #selector(collectItemClick))
        
//        中间
        let searchFrame = CGRect(x: 0, y: 0, width: 200, height: 44)
        let searchBar = UISearchBar(frame: searchFrame)
        searchBar.placeholder = "主播昵称/房间号/链接"
        navigationItem.titleView = searchBar
        searchBar.searchBarStyle = .minimal
        
        let searchTextF = searchBar.value(forKey: "_searchField") as? UITextField
        searchTextF?.textColor = UIColor.white
        
//        navigationController?.navigationBar.barTintColor = UIColor.black
    }
    
    fileprivate func setupContentView() {
     
        let homeTypes = loadStyleData()
        
        let style = YPPageStyle()
        style.isScrollEnable = true
        let frame = CGRect(x: 0, y: kNavigationBarH + kStatusBarH, width: kScreenW, height: kScreenH - kNavigationBarH - kStatusBarH - 44)
        let titles = homeTypes.map({ $0.title })
        var childVCs = [AnchorViewController]()
        
        for dict in homeTypes {
            let anchorVC = AnchorViewController()
            anchorVC.homeType = dict
            childVCs.append(anchorVC)
        }
        
//        创建主题内容
        let pageView = YPPageView(frame: frame, style: style, titles: titles, childVCs: childVCs, parentVC: self)
        
        view.addSubview(pageView)
        
    }
    
    fileprivate func loadStyleData() -> [HomeType] {
//        读取plist文件
//        获取路径
        let path = Bundle.main.path(forResource: "types", ofType: "plist")
        let types = NSArray(contentsOfFile: path!) as![[String : Any]] // 返回数组，数组中是字典
        var tempArray = [HomeType]()
        
        for dic in types {
            tempArray.append(HomeType(dict: dic))
        }
        return tempArray
    }
    
}

extension HomeViewController {
    @objc fileprivate func collectItemClick(){
        NSLog("弹出控制器")
    }
}
