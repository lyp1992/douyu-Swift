//
//  YPPageStyle.swift
//  YPPageView
//
//  Created by 赖永鹏 on 2018/11/22.
//  Copyright © 2018年 LYP. All rights reserved.
//

import UIKit

class YPPageStyle {

//    是否可以滚动
    var isScrollEnable : Bool = false
    
//    设置label的属性
    var titleHeight : CGFloat = 40
    var normalColor : UIColor = UIColor.white
    var selectColor : UIColor = UIColor.orange
    var fontSize : CGFloat = 15
    
    var titleMargin : CGFloat = 30
    
//    设置底部bottomLine
    var isBottomLineShow : Bool = false
    var bottomLineHeight : CGFloat = 2
    var bottomLineColor : UIColor = UIColor.orange
    
//    缩放
    var isScaleAble : Bool = true
    var scale : CGFloat = 1.2
    
//    是否需要显示coverView
    var isShowCoverView : Bool = false
    var coverBgColor : UIColor = UIColor.black
    var coverAlpha : CGFloat = 0.4
    var coverMargin : CGFloat = 8
    var coverHeight : CGFloat = 25
    var coverRadius : CGFloat = 12
    
}
