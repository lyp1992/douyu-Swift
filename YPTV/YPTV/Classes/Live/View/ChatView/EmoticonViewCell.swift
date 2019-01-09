//
//  EmoticonViewCell.swift
//  YPTV
//
//  Created by 赖永鹏 on 2019/1/9.
//  Copyright © 2019年 LYP. All rights reserved.
//

import UIKit

class EmoticonViewCell: UICollectionViewCell {

    @IBOutlet weak var emoticonImageV: UIImageView!
    
    var emoticon : Emoticon? {
        didSet{
            emoticonImageV.image = UIImage(named: emoticon!.emoticonName)
        }
    }
    
}
