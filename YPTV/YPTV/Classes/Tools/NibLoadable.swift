//
//  NibLoadable.swift
//  YPTV
//
//  Created by 赖永鹏 on 2019/1/9.
//  Copyright © 2019年 LYP. All rights reserved.
//

import UIKit

protocol NibLoadable {
    
}

extension NibLoadable where Self : UIView {
    
    static func loadFromNib (_ nibName : String? = nil) -> Self{
        
//        let loadName = nibName == nil ? "\(self)" : nibName!
        let loadName = nibName ?? "\(self)"
        return Bundle.main.loadNibNamed(loadName, owner: nil, options: nil)?.first as! Self
    }
}
