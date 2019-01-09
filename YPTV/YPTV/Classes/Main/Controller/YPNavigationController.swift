//
//  YPNavigationController.swift
//  YPTV
//
//  Created by 赖永鹏 on 2019/1/9.
//  Copyright © 2019年 LYP. All rights reserved.
//

import UIKit

class YPNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        1.利用运行时，打印手势的所有属性
        guard let targets = interactivePopGestureRecognizer!.value(forKey: "_targets") as? [NSObject] else{return}
//        print(targets)
        let targetObject = targets[0]
        let target = targetObject.value(forKey: "target")
        let action = Selector(("handleNavigationTransition:"))
        
        let panGes = UIPanGestureRecognizer(target: target, action: action)
        
        view.addGestureRecognizer(panGes)
    }
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.hidesBottomBarWhenPushed = true
        super.pushViewController(viewController, animated: true)
    }

}
