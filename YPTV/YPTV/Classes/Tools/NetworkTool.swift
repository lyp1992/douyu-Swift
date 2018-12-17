//
//  NetworkTool.swift
//  YPTV
//
//  Created by 赖永鹏 on 2018/12/10.
//  Copyright © 2018年 LYP. All rights reserved.
//

import UIKit
import Alamofire
enum MethodType {
    case get
    case post
}

class NetworkTool: NSObject {

    class func requestData(_ type : MethodType, urlString : String, parameters : [String : Any]? = nil,finishCallBack : @escaping (_ result :Any)->()) {
        
//        1.获取类型
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        
//        2.发送类型
        Alamofire.request(urlString, method: method, parameters: parameters).validate(contentType: ["text/plain"]).responseJSON { (response) in
            
            //        3.获取结果
            
            guard let result = response.result.value else {
                print(response.result.error!)
                return
            }
            
            //        4.回调结果
            finishCallBack(result)
        }
        
    }
    
}
