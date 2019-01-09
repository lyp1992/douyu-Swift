//
//  RoomViewController.swift
//  YPTV
//
//  Created by 赖永鹏 on 2018/12/20.
//  Copyright © 2018年 LYP. All rights reserved.
//

import UIKit

private let kChatToolViewHeight : CGFloat = 44

class RoomViewController: UIViewController ,Emitterable{

    fileprivate lazy var chatToolView : ChatToolView = ChatToolView.loadFromNib()
    
    fileprivate lazy var ypSocket : YPSocket = YPSocket()
    
    @IBOutlet weak var msgLabel: UILabel!
    @IBOutlet weak var bgImageV: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUPUI()
        
//        监听键盘弹出
        NotificationCenter.default.addObserver(self, selector: #selector(keybordWillChangeFrame(_ :)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        if ypSocket.connect() {
            print("connect success")
            ypSocket.delegate = self
            ypSocket.enterRoom()
            ypSocket.startReadMsg()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
       
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        ypSocket.leaveRoom()
    
    }
    

    @IBAction func exitBtnClick(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func FocusOn(_ sender: UIButton) {
        print("点击了关注")
    }
    
    @IBAction func stackViewClick(_ sender: UIButton) {
        switch sender.tag {
        case 0:
           chatToolView.msgTF.becomeFirstResponder()
        case 1:
            print("点击了分享")
        case 2:
            print("点击了礼物")
        case 3:
            print("点击了更多")
        case 4:
           sender.isSelected = !sender.isSelected
           let point = CGPoint(x: sender.center.x, y: view.bounds.height - sender.bounds.height * 0.5)
           sender.isSelected ? startEmittering(point):stopEmittering()
            
        default:
            fatalError("未处理按钮")
        }
    }
}

//设置UI界面
extension RoomViewController{

    fileprivate func setUPUI() {
        setupBlurView()
        setupBottomView()
    }
    fileprivate func setupBlurView(){
        let blur = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        blurView.frame = bgImageV.bounds
        bgImageV.addSubview(blurView)
        
    }
    
    fileprivate func setupBottomView() {
        chatToolView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: kChatToolViewHeight)
        
        chatToolView.autoresizingMask = [.flexibleTopMargin,.flexibleWidth]
        chatToolView.delegate = self
        view.addSubview(chatToolView)
        
        
    }
}

extension RoomViewController {
    
   @objc fileprivate func keybordWillChangeFrame(_ note:NSNotification){

    let douration = note.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
    let endFrame = (note.userInfo![UIKeyboardFrameEndUserInfoKey] as!NSValue).cgRectValue
    let msgTFY = endFrame.origin.y - kChatToolViewHeight
    UIView.animate(withDuration: douration, animations: {
        UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: 7)!)
        let endY = msgTFY == (kScreenH - kChatToolViewHeight) ? kScreenH : msgTFY
        self.chatToolView.frame.origin.y = endY
        
    })
    
    }
    
}

extension RoomViewController : ChatToolViewDelegate{
    
    func chatToolsView(toolView: ChatToolView, message: String) {
        
        ypSocket.sendChatMessage(message)
    }
}

extension RoomViewController : YPSocketDelegate{
    func ypSocket(_ ypSocket: YPSocket, enterRoom userInfo: UserInfo) {
     msgLabel.attributedText = AttributeStrGenerator.GenerateEnterOrLeaveRoom(true, userName: userInfo.username)
    }
    
    func ypSocket(_ ypSocket: YPSocket, leaveRoom userInfo: UserInfo) {
      msgLabel.attributedText = AttributeStrGenerator.GenerateEnterOrLeaveRoom(false, userName: userInfo.username)
    }
    
    func ypSocket(_ ypSocket: YPSocket, receiveMsg chatMessage: ChatMessage) {
        msgLabel.attributedText = AttributeStrGenerator.generateChatMessage(chatMessage.message, chatMessage.userInfo.username, msgLabel.font)
    }
    
    func ypSocket(_ ypSocket: YPSocket, receiveGift giftMsg: GiftMessage) {
        
    }
    
}
