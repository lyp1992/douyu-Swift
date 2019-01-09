//
//  AttributeStrGenerator.swift
//  YPTV
//
//  Created by 赖永鹏 on 2019/1/9.
//  Copyright © 2019年 LYP. All rights reserved.
//

import UIKit

class AttributeStrGenerator {

}

extension AttributeStrGenerator {
    
    class func GenerateEnterOrLeaveRoom (_ isEnter : Bool,userName : String) -> NSAttributedString {
//        1.拼接完整的路径
        let  message = userName + (isEnter ? "进入房间":"离开房间")
        
//        2.根据string创建NSAttriButedString
        let attributeStr = NSMutableAttributedString(string: message)
        
//        3.修改名字的颜色
//        3.1 获取名字的范围
        let nameRange = NSRange(location: 0, length: userName.lengthOfBytes(using: .utf8))
        
//        3.2 修改颜色
        attributeStr.setAttributes([NSAttributedStringKey.foregroundColor : UIColor.orange], range: nameRange)
        return attributeStr
    }
    
    class func generateChatMessage(_ message : String, _ userName : String, _ font : UIFont) -> NSAttributedString{
//      1.  拼接完整的信息
        let chatMessage = userName + ":" + message
        
//       2. 将string 转成NSAttributeString
        let chatAttributeStr = NSMutableAttributedString(string: chatMessage)
        
//        3.将名字修改颜色
        let nameRange = NSRange(location: 0, length: userName.lengthOfBytes(using: .utf8))
    chatAttributeStr.setAttributes([NSAttributedStringKey.foregroundColor : UIColor.orange], range: nameRange)
        
//        4.匹配图片
//        4.1 使用正则表达式 取出所有的图片名
        let pattern = "\\[.*?\\]"
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return chatAttributeStr
        }
//        4.2 匹配结果
        let range = NSRange(location: 0, length: chatMessage.characters.count)
        let results = regex.matches(in: chatMessage, options: [], range: range)
        
//        4.3遍历所有的结果
        for i in (0..<results.count).reversed() {
//            4.3.1 获取result 相应的结果
            let result = results[i]
            let imageName = (chatMessage as NSString).substring(with: result.range)
            
//            4.3.2 根据imageName创建image
            guard let image = UIImage(named: imageName) else { continue }
            
//            4.3.3 根据图片创建NSTextAttachment
            let attachment = NSTextAttachment()
            attachment.image = image
            attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
            
//            4.3.4 根据nstextattachment 创建 nsattributrstring
            let imageAttStr = NSAttributedString(attachment: attachment)
//            4.3.5 替换之前的图片文字
            chatAttributeStr.replaceCharacters(in: result.range, with: imageAttStr)
            
        }
        return chatAttributeStr

    }
    
    
    
}
