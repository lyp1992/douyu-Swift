//
//  BaseModel.swift
//  YPTV
//
//  Created by 赖永鹏 on 2018/12/12.
//  Copyright © 2018年 LYP. All rights reserved.
//

import UIKit

class BaseModel: NSObject {
    override init() {
        
    }
    
    init(dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
