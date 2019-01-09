//
//  ViewController.swift
//  YPTV
//
//  Created by 赖永鹏 on 2018/12/10.
//  Copyright © 2018年 LYP. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addChildVC(_viewControllerName: "HomeViewController",title: "mine",imageName: "mine")
        addChildVC(_viewControllerName: "RankViewController",title: "ranking",imageName: "ranking")
        addChildVC(_viewControllerName: "DiscoverViewController",title: "found",imageName: "found")
        addChildVC(_viewControllerName: "LiveViewController",title: "live",imageName: "live")
    }

    fileprivate func addChildVC (_viewControllerName : String,title : String,imageName : String){
        // 0.动态获取命名空间
        // 默认情况下命名控件就是项目的名称(注意项目名称不要有中横线，如"Swift-weibo")
        let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        // 将字符串转换为类
        let cls:AnyClass? = NSClassFromString(namespace + "." + _viewControllerName)
        // 将AnyClass转为指定的类型
        let vcCls = cls as! UIViewController.Type
        
        // 通过class创建对象
        let vc = vcCls.init()
        
        // 1.设置子控制器对应的数据
        var imageNor = UIImage(named: imageName)
        imageNor = imageNor!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        vc.tabBarItem.image = imageNor
        
        vc.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        vc.title = title
    vc.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.black], for: UIControlState.normal);
    vc.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.orange], for: UIControlState.selected);
        
        // 2.给子控制器包装一个导航控制器
        let nav = YPNavigationController()
        nav.addChildViewController(vc)
        
        // 2.将导航控制器添加到当前控制器上
        addChildViewController(nav)
   
    }

}

