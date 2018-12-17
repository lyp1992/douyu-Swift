//
//  YPTitlesView.swift
//  YPPageView
//
//  Created by 赖永鹏 on 2018/11/22.
//  Copyright © 2018年 LYP. All rights reserved.
//

import UIKit

protocol YPTitleViewDelegate : class {
    func titleView(_ titleView : YPTitlesView, currentIndex : Int)
}

class YPTitlesView: UIView {

//    weak 只能用来修饰对象
    weak var delegate : YPTitleViewDelegate?
    
    typealias ColorRGB = (red : CGFloat, green : CGFloat, blue : CGFloat)
    fileprivate  var style : YPPageStyle
    fileprivate var titles : [String]
    fileprivate var currentIndex : Int = 0
    fileprivate lazy var selectRGB : ColorRGB = self.style.selectColor.getRGB()
    fileprivate lazy var normalRGB : ColorRGB = self.style.normalColor.getRGB()
    fileprivate lazy var deltaRGB : ColorRGB = {
        let deltaR = self.selectRGB.red - self.normalRGB.red
        let detlaG = self.selectRGB.green - self.normalRGB.green
        let deltaB = self.selectRGB.blue - self.normalRGB.blue
        return (deltaR,detlaG,deltaB)
    }()
    
    fileprivate lazy var titleLabels : [UILabel] = [UILabel]()
    fileprivate lazy var scrollView : UIScrollView = {
       
        let scrollView = UIScrollView()
        scrollView.frame = self.bounds;
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        return scrollView
    }()
    
    fileprivate lazy var bottomLine : UIView = {
       let bottomView = UIView()
        bottomView.frame.size.height = style.bottomLineHeight
        bottomView.frame.origin.y = self.bounds.height - style.bottomLineHeight
        bottomView.backgroundColor = style.bottomLineColor
        return bottomView
    }()
    
    fileprivate lazy var coverView : UIView = {
        let coverView = UIView()
        coverView.backgroundColor = style.coverBgColor
        coverView.alpha = style.coverAlpha
        return coverView
    }()
    
    init(frame : CGRect,style : YPPageStyle, titles : [String]) {
        self.style = style
        self.titles = titles
        super.init(frame: frame)
        setUPUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(code) has not been immplement")
    }
}

extension YPTitlesView{
    
   fileprivate func setUPUI() {
        addSubview(scrollView)
    
     setupTitleLabels()
     setupTitleFrame()
     setupBottomLine()
     setupCover()
    }
    
    private func setupCover() {
    
        guard self.style.isShowCoverView else {
            return
        }
        
//        添加scrollerView上
        scrollView.insertSubview(coverView, at: 0)
        
//        设置coverview的frame
        let firstLabel = titleLabels.first!
        let coverW = self.bounds.width
        let coverH = self.style.coverHeight
        let coverX = firstLabel.frame.origin.x
        let coverY = (firstLabel.frame.height - coverH) * 0.5
        
        coverView.frame = CGRect(x: coverX, y: coverY, width: coverW, height: coverH)
        
        // 4.设置圆角
        coverView.layer.cornerRadius = style.coverRadius
        coverView.layer.masksToBounds = true
        
    }
    
    private func setupBottomLine(){
        
        guard self.style.isBottomLineShow else {
            return
        }
        
        scrollView.addSubview(bottomLine)
        bottomLine.frame.origin.x = titleLabels.first!.frame.origin.x
        bottomLine.frame.size.width = titleLabels.first!.frame.width
    }
    
    private func setupTitleFrame() {
        //        定义常量
        let labelH = style.titleHeight
        let labelY : CGFloat = 0
        var labelW : CGFloat = 0
        var labelX : CGFloat = 0
        
        let count = titleLabels.count
        for (i,titleLabel) in titleLabels.enumerated() {
            if style.isScrollEnable {//可以滚动
                labelW = (titles[i] as NSString).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 0), options: .usesLineFragmentOrigin, attributes: [kCTFontAttributeName as NSAttributedStringKey : titleLabel.font], context: nil).width
                labelX = i == 0 ? style.titleMargin * 0.5 : (titleLabels[i-1].frame.maxX + style.titleMargin)
            } else {//不可以滚动
                labelW = bounds.width / CGFloat(count)
                labelX = labelW * CGFloat(i)
            }
            titleLabel.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
        }
        
        if style.isScaleAble {
            // ?. 在等号的左边, 那么系统会自动判断可选类型是否有值
            // ?. 在等号的右边, 那么如果可选类型没有值, 该语句返回nil
            titleLabels.first?.transform = CGAffineTransform.init(scaleX: style.scale, y: style.scale)
        }
        
        if style.isScrollEnable {
            scrollView.contentSize.width = titleLabels.last!.frame.maxX + style.titleMargin * 0.5
        }
        
    }
    
    private func setupTitleLabels() {

        for (i,title) in titles.enumerated() {
            let label = UILabel()
            
//            设置label的属性
            label.tag = i
            label.text = title
            label.textColor = i == 0 ?style.selectColor :style.normalColor
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: style.fontSize)
            
            scrollView.addSubview(label)
            
            titleLabels.append(label)
            
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(_:)))
            label.addGestureRecognizer(tapGes)
            label.isUserInteractionEnabled = true
            
        }
    }
    
}

extension YPTitlesView{

    @objc fileprivate func titleLabelClick(_ tapGes : UITapGestureRecognizer) {
        
//        检验label
        guard let targetLabel = tapGes.view as? UILabel  else {
            return
        }
        guard  targetLabel.tag != currentIndex else {
            return
        }
        
//        取出之前的label
        let sourceLabel = titleLabels[currentIndex]
//        改变颜色
        sourceLabel.textColor = style.normalColor
        targetLabel.textColor = style.selectColor
//        记录当前点击的label
        currentIndex = targetLabel.tag
//        让点击的label居中
        addJustPosition(targetLabel)
       delegate?.titleView(self, currentIndex: currentIndex)
        
        if style.isShowCoverView {
            coverView.frame.origin.x = targetLabel.frame.origin.x
            coverView.frame.size.width = targetLabel.frame.size.width;
        }
        
        if style.isScaleAble {
        
            targetLabel.transform = CGAffineTransform.init(scaleX: style.scale, y: style.scale)
            sourceLabel.transform = CGAffineTransform.identity
        }
        
        if style.isBottomLineShow {
            UIView .animate(withDuration: 0.25) {
                self.bottomLine.frame.origin.x = targetLabel.frame.origin.x
                self.bottomLine.frame.size.width = targetLabel.frame.size.width
            }
        }
    }
    
    private func addJustPosition(_ targetLabel : UILabel){
// 1.计算距离中心的offset
       var offSetX = targetLabel.center.x - self.bounds.size.width * 0.5
        if offSetX <= 0 {
            offSetX = 0
        }
        if offSetX > scrollView.contentSize.width - scrollView.bounds.width {
            offSetX = scrollView.contentSize.width - scrollView.bounds.width
        }
        
        scrollView.setContentOffset(CGPoint(x: offSetX, y: 0), animated: true)
        
    }
}

extension YPTitlesView : YPContentViewDelegate{
    func contentView(_ contentView: YPContentView, inIndex: Int) {
        currentIndex = inIndex
        addJustPosition(titleLabels[currentIndex])
    }
    
    func contentView(_ contentView: YPContentView, sourceIndex: Int, targetIndex: Int, progress: CGFloat) {
//        获取label
        let targetLabel = titleLabels[targetIndex]
        let sourceLabel = titleLabels[sourceIndex]
        
//        颜色渐变
        sourceLabel.textColor = UIColor(r: selectRGB.red - progress * deltaRGB.red, g: selectRGB.green - progress * deltaRGB.green, b: selectRGB.blue - progress * deltaRGB.blue)
        
        targetLabel.textColor = UIColor(r: normalRGB.red + progress * deltaRGB.red, g: normalRGB.green + progress * deltaRGB.green, b: normalRGB.blue + progress * deltaRGB.blue)
        
        
        
        if style.isShowCoverView {
            coverView.frame.origin.x = targetLabel.frame.origin.x
            coverView.frame.origin.y = (targetLabel.frame.height - coverView.frame.height) * 0.5
        }
        
        
        if style.isScaleAble {
            let deltaScale = style.scale - 1.0
            sourceLabel.transform = CGAffineTransform(scaleX: style.scale - progress * deltaScale, y: style.scale - progress * deltaScale)
            targetLabel.transform = CGAffineTransform(scaleX: 1.0 + progress * deltaScale, y: 1.0 + progress * deltaScale)
        }
        
    
        if style.isBottomLineShow {
            
            let deltaX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
            let deltaW = targetLabel.frame.width - sourceLabel.frame.width
            bottomLine.frame.origin.x = sourceLabel.frame.origin.x + progress * deltaX
            bottomLine.frame.size.width = sourceLabel.frame.width + progress * deltaW
            
        }
        
        if style.isShowCoverView {
            
            let deltaX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
            let deltaW = targetLabel.frame.width - sourceLabel.frame.width
            
            coverView.frame.origin.x = sourceLabel.frame.origin.x + progress * deltaX
            coverView.frame.size.width = sourceLabel.frame.width + progress * deltaW
        }
    }
}
