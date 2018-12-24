//
//  KingfisherExtension.swift
//  YPTV
//
//  Created by 赖永鹏 on 2018/12/19.
//  Copyright © 2018年 LYP. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func setImage(_ urlStirng : String? ,_ placeHolderName : String?) {
        guard let urlString = urlStirng else {
            return
        }
        guard let placeHolderName = placeHolderName else {
            return
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        kf.setImage(with: url, placeholder:UIImage(named: placeHolderName))
    }
    
}
