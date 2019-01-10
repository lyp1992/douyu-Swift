//
//  ChatToolView.swift
//  YPTV
//
//  Created by 赖永鹏 on 2019/1/9.
//  Copyright © 2019年 LYP. All rights reserved.
//

import UIKit

protocol ChatToolViewDelegate : class {
    
    func chatToolsView(toolView : ChatToolView ,message : String)
}

class ChatToolView: UIView ,NibLoadable{

    @IBOutlet weak var msgTF: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    
    weak var delegate : ChatToolViewDelegate?
    fileprivate lazy var emoticonView : EmoticonView = EmoticonView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 250))
    fileprivate lazy var emoticonBtn : UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
    
    override func awakeFromNib() {
        setupUI()
    }
    
    
    @IBAction func msgTFDidEdit(_ sender: UITextField) {
        sendButton.isEnabled = sender.text?.characters.count != 0
    }
    @IBAction func sengMsg(_ sender: UIButton) {
//        1.获取内容
        let text = msgTF.text!
//        2.清空内容
        msgTF.text = ""
        sender.isEnabled = false
//        3.将内容回调回去
        delegate?.chatToolsView(toolView: self, message: text)
        
    }
    
}

extension ChatToolView {
    
    fileprivate func setupUI() {
        
        // 0.测试: 让textFiled显示`富文本`
        /*
         let attrString = NSAttributedString(string: "I am fine", attributes: [NSForegroundColorAttributeName : UIColor.green])
         let attachment = NSTextAttachment()
         attachment.image = UIImage(named: "[大哭]")
         let attrStr = NSAttributedString(attachment: attachment)
         inputTextField.attributedText = attrStr
         */
        
        emoticonBtn.setImage(UIImage(named: "chat_btn_emoji"), for: .normal)
        emoticonBtn.setImage(UIImage(named: "chat_btn_keyboard"), for: .selected)
        emoticonBtn.addTarget(self, action: #selector(emoticonBtnClick(_:)), for: .touchUpInside)
        
        msgTF.rightView = emoticonBtn
        msgTF.rightViewMode = .always
        msgTF.allowsEditingTextAttributes = true
        
//        2. 设置emoticon的闭包
        emoticonView.emoticonClickCallback = { [weak self] emoticon in
 
//            2.1 点击了删除
            if emoticon.emoticonName == "delete-n" {
                self?.msgTF.deleteBackward()
                return
            }
//            2.2 获取光标位置
            guard let range = self?.msgTF.selectedTextRange else {return}
            self?.msgTF.replace(range, withText: emoticon.emoticonName)
        }
        
    }
    
    @objc fileprivate func emoticonBtnClick(_ sender:UIButton){
       
        sender.isSelected = !sender.isSelected
        
//        切换键盘
        let range = msgTF.selectedTextRange
        msgTF.resignFirstResponder()
        msgTF.inputView = msgTF.inputView == nil ? emoticonView : nil
        msgTF.becomeFirstResponder()
        msgTF.selectedTextRange = range
        
    }
    
}
