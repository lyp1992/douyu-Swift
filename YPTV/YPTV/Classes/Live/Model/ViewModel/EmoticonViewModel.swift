//
//  EmoticonViewModel.swift
//  YPTV
//
//  Created by 赖永鹏 on 2019/1/9.
//  Copyright © 2019年 LYP. All rights reserved.
//

import UIKit

class EmoticonViewModel {

    static let shareInstance : EmoticonViewModel = EmoticonViewModel()
    lazy var packages : [EmoticonPackage] = [EmoticonPackage]()
    
    init() {
        packages.append(EmoticonPackage(plistName: "QHNormalEmotionSort.plist"))
        packages.append(EmoticonPackage(plistName: "QHSohuGifSort.plist"))
    }
    
}
