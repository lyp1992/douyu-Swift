//
//  HomeViewModel.swift
//  YPTV
//
//  Created by 赖永鹏 on 2018/12/12.
//  Copyright © 2018年 LYP. All rights reserved.
//

//请求数据
import UIKit

class HomeViewModel {

    lazy var anchorModels = [AnchorModel]()
}

extension HomeViewModel {
    func loadHomeData(type : HomeType,index : Int,finishCallback : @escaping ()->()) {
        
        NetworkTool.requestData(.get, urlString: "http://qf.56.com/home/v4/moreAnchor.ios", parameters: ["type":type.type,"index":index,"size":48], finishCallBack: {(result) -> Void in

            guard let resultDict = result as? [String:Any] else {
                return
            }
            guard let messageDict = resultDict["message"] as? [String:Any] else {return}
            guard let dataArray = messageDict["anchors"] as? [[String : Any]] else { return }
            
            for (index,dict) in dataArray.enumerated() {
               
                let anchor = AnchorModel(dict: dict)
                anchor.isEvenIndex = index%2 == 0
                self.anchorModels.append(anchor)
                
            }
            finishCallback()
        })
     
    }
}
