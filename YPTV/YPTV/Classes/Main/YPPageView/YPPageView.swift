//
//  YPPageView.swift
//  YPPageView
//
//  Created by 赖永鹏 on 2018/11/22.
//  Copyright © 2018年 LYP. All rights reserved.
//

import UIKit

class YPPageView: UIView {

//    MARK 属性
    var style : YPPageStyle
    var titles : [String]
    var chileVCs : [UIViewController]
    var parentVC : UIViewController
    init(frame : CGRect, style : YPPageStyle,titles : [String],childVCs : [UIViewController],parentVC : UIViewController) {
//       在init之前 保证数据已经被初始化
        self.style = style
        self.titles = titles
        self.chileVCs = childVCs
        self.parentVC = parentVC
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) has not been immplement")
    }

}
extension YPPageView {
    fileprivate func setUpUI() {
        
//        创建titleView
        let titleFrame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: style.titleHeight)
        let titleView = YPTitlesView(frame: titleFrame, style: style, titles: titles)
        titleView.backgroundColor = UIColor.gray
        addSubview(titleView)
//        创建contentView
        let contentFrame = CGRect(x: 0, y:style.titleHeight, width: bounds.width, height: bounds.height - style.titleHeight)
        let contentView = YPContentView(frame: contentFrame, childVCs: chileVCs, parentVC: parentVC)
        contentView.backgroundColor = UIColor.randomColor
        addSubview(contentView)
        
//        两个相互交互
        titleView.delegate = contentView
        contentView.delegate = titleView
    }
}
