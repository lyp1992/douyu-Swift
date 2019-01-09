//
//  EmoticonPackage.swift
//  YPTV
//
//  Created by 赖永鹏 on 2019/1/9.
//  Copyright © 2019年 LYP. All rights reserved.
//

import UIKit

class EmoticonPackage {

    lazy var emoticonArr : [Emoticon] = [Emoticon]()
    init(plistName : String) {
        
        guard let path = Bundle.main.path(forResource: plistName, ofType: nil) else {
            return
        }
        
        guard let emoticonArray = NSArray(contentsOfFile: path) as? [String] else {
            return
        }
        
        for str in emoticonArray {
            emoticonArr.append(Emoticon(emoticonName: str))
        }
        
    }
    
}
