//
//  YPSocket.swift
//  YPIMClient
//
//  Created by 赖永鹏 on 2019/1/8.
//  Copyright © 2019年 LYP. All rights reserved.
//

import UIKit

protocol YPSocketDelegate : class {
    
    func ypSocket(_ ypSocket : YPSocket,enterRoom userInfo : UserInfo)
    func ypSocket(_ ypSocket : YPSocket,leaveRoom userInfo : UserInfo)
    func ypSocket(_ ypSocket : YPSocket,receiveMsg chatMessage : ChatMessage)
    func ypSocket(_ ypSocket : YPSocket, receiveGift giftMsg : GiftMessage)
}

enum MessageType : Int {
    case enterRoom = 0
    case leaveRoom = 1
    case chatMessage = 2
    case giftMessage = 3
}

class YPSocket {

    weak var delegate : YPSocketDelegate?
    
    fileprivate lazy var tcpClient : TCPClient = TCPClient(addr: "192.168.121.43",port : 2828)
    fileprivate lazy var userInfo : UserInfo = {
        let userInfo = UserInfo.Builder()
        userInfo.userId = 110
        userInfo.username = "why"
        userInfo.iconUrl = "why.png"
        userInfo.level = 99
//        转成模型
        return try! userInfo.build()
    }()
    
}

//与服务器建立连接
extension YPSocket {
    
    func connect() ->Bool{
        return tcpClient.connect(timeout: 5).0
    }
    func disConnect(){
        tcpClient.close()
    }
    
    func startReadMsg() {
        DispatchQueue.global().async {
            while true {
                if let lengthByte = self.tcpClient.read(4){
                    //                1.u获取数据的长度
                    let lengthData = NSData(bytes: lengthByte, length: 4)
                    var length : Int = 0
                    lengthData.getBytes(&length, length: 4)
                    
                    //                2.获取数据的类型
                    guard let typeBytes = self.tcpClient.read(2) else{
                        self.tcpClient.read(length)
                        continue
                    }
                    let typeData = NSData(bytes: typeBytes, length: 2)
                    var type : Int = 0
                    typeData.getBytes(&type, length: 2)
                    
                    //                3.获取具体的内容
                    guard let dataBytes = self
                        .tcpClient.read(length) else{
                            return
                    }
                    let msgData = Data(bytes: dataBytes, count: length)
                    
                    //                4.处理消息
                    DispatchQueue.main.async {
                        self.handleMsg(MessageType(rawValue: type)!, msgData)
                    }
                }
            }
        }
    }
    
}

// 处理消息
extension YPSocket{
    fileprivate func handleMsg (_ type: MessageType,_ msgData: Data){
        switch type {
        case .enterRoom:
            let userInfo = try! UserInfo.parseFrom(data: msgData)
            delegate?.ypSocket(self, enterRoom: userInfo)
        case .leaveRoom:
            let userInfo = try! UserInfo.parseFrom(data: msgData)
            delegate?.ypSocket(self, leaveRoom: userInfo)
        case .chatMessage:
            
            let chatMessage = try! ChatMessage.parseFrom(data: msgData)
            delegate?.ypSocket(self, receiveMsg: chatMessage)
        case .giftMessage:
            let giftMsg = try! GiftMessage.parseFrom(data: msgData)
            delegate?.ypSocket(self, receiveGift: giftMsg)
        }
    }
}

// 发送消息
extension YPSocket{
    func enterRoom() {
        sendMessage(type: .enterRoom, msgData: userInfo.data())
    }
    
    func leaveRoom(){
        sendMessage(type: .leaveRoom, msgData: userInfo.data())
    }
    
    func sendChatMessage(_ messageStr : String){
//        获取聊天数据
        let chatMsg = ChatMessage.Builder()
        chatMsg.userInfo = userInfo
        chatMsg.message = messageStr
        let msgData = (try! chatMsg.build()).data()
        
//        发送数据
        sendMessage(type: .chatMessage, msgData: msgData)
    }
    
    func sendGiftMessage(_ giftName : String, _ giftURL : String, _ giftID : String, _ giftCount : Int){
        
//        获取聊天数据
        let giftMsg = GiftMessage.Builder()
        giftMsg.userInfo = userInfo
        giftMsg.giftName = giftName
        giftMsg.giftUrl = giftURL
        giftMsg.giftId = giftID
        giftMsg.giftCount = Int32(giftCount)
        let msgData = (try! giftMsg.build()).data()
        
//        发送数据
        sendMessage(type: .giftMessage, msgData: msgData)
    }
    
    fileprivate func sendMessage(type: MessageType,msgData:Data){
//        1.获取字符串长度
        var length = msgData.count
        let lengthData = Data(bytes: &length, count: 4)
        
//        2.获取消息类型
        var type = type.rawValue
        let typeData = Data(bytes: &type, count: 2)
        
//        3.将message 转成data类型
        tcpClient.send(data: lengthData + typeData + msgData)
        
    }
    
}
