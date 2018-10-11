//
//  ZJAlert.swift
//  Swift_Project
//
//  Created by 小黎 on 2018/7/26.
//  Copyright © 2018年 ZJ. All rights reserved.
//

import UIKit

class ZJAlert: NSObject {
    class func show(_ title:Any?,_ message:Any?,_ leftBtnTitle:Any?,_ rightBtnTitle:Any?,leftBtn:(()->())? ,rightBtn:(()->())?){
        let keyWindow = UIApplication.shared.keyWindow;
        for subView in (keyWindow?.subviews)! {
            if subView.isKind(of: ZJAlertView.self){
                subView.removeFromSuperview();
            }
        }
        let alertView = ZJAlertView(title, message, leftBtnTitle, rightBtnTitle, leftBtn: leftBtn, rightBtn: rightBtn);
        UIApplication.shared.keyWindow?.addSubview(alertView);
    }
    class func hidden(){
        let keyWindow = UIApplication.shared.keyWindow;
        for subView in (keyWindow?.subviews)! {
            if subView.isKind(of: ZJAlertView.self){
                UIView.animate(withDuration: 0.3, animations: {
                    subView.alpha = 0;
                }, completion: { (isfinsh) in
                    subView.removeFromSuperview();
                })
            }
        }
    }
}
private class ZJAlertView: UIView {
    private var leftBtnClickBlock:(()->())?;
    private var rightBtnClickBlock:(()->())?;
    init(_ title:Any?,_ message:Any?,_ leftBtnTitle:Any?,_ rightBtnTitle:Any?,leftBtn:(()->())? ,rightBtn:(()->())?){
        let alert_width  = UIScreen.main.bounds.size.width;
        let alert_height = UIScreen.main.bounds.size.height;
        super.init(frame: CGRect(x: 0, y: 0, width: alert_width, height: alert_height));
        //
        self.backgroundColor = UIColor.gray.withAlphaComponent(0.5);
        //
        self.leftBtnClickBlock  = leftBtn;
        self.rightBtnClickBlock = rightBtn;
        //背景
        var frame1 = CGRect(x: 0, y: 0, width: alert_width*0.65, height: alert_width*0.65*0.6);
        let alert_bgview = UIView(frame:frame1 );
        alert_bgview.center = CGPoint(x: alert_width*0.5, y: alert_height*0.5);
        alert_bgview.backgroundColor = UIColor.white;
        alert_bgview.layer.cornerRadius = 5;
        alert_bgview.layer.masksToBounds = true;
        self.addSubview(alert_bgview);
        //
        let subHeight = alert_bgview.frame.size.height/3.0;
        let subWidth  = alert_bgview.frame.size.width;
        // 标题
        frame1 = CGRect(x: 0, y: 0, width: subWidth, height: subHeight)
        let alert_titlabel = UILabel(frame:frame1 )
        alert_bgview.addSubview(alert_titlabel)
        alert_titlabel.font = UIFont.systemFont(ofSize: 17)
        alert_titlabel.textAlignment = .center
        alert_titlabel.textColor = UIColor.black
        alert_titlabel.backgroundColor = UIColor.clear
        // 内容
        frame1 = CGRect(x: 0, y: subHeight, width: subWidth, height: subHeight)
        let alert_meslable = UILabel(frame:frame1 )
        alert_bgview.addSubview(alert_meslable)
        alert_meslable.numberOfLines = 0
        alert_meslable.font = UIFont.systemFont(ofSize: 14)
        alert_meslable.textAlignment = .center
        alert_meslable.textColor = UIColor.black
        alert_meslable.backgroundColor = UIColor.clear
        //
        frame1 = CGRect(x: 0, y: subHeight*2, width: subWidth, height: 0.5)
        let line1 = UIView(frame: frame1)
        alert_bgview.addSubview(line1)
        line1.backgroundColor = UIColor.orange//17387647401
        //
        frame1 = CGRect(x: subWidth*0.5-0.25, y: subHeight*2, width: 0.5, height: subHeight)
        let line2 = UIView(frame: frame1)
        alert_bgview.addSubview(line2)
        line2.backgroundColor = UIColor.orange
        // 左按钮
        frame1 = CGRect(x: 0, y: subHeight*2+0.5, width: subWidth*0.5-0.25, height: subHeight-0.5)
        let alert_leftBtn = UIButton(frame: frame1);
        alert_bgview.addSubview(alert_leftBtn)
        alert_leftBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        alert_leftBtn.setTitleColor(UIColor.orange, for: .normal)
        alert_leftBtn.backgroundColor = UIColor.white
        alert_leftBtn.tag = 111;
        alert_leftBtn.addTarget(self, action: #selector(alertButtonClickAction(_ : )), for: .touchUpInside);
        // 右按钮
        frame1 = CGRect(x: subWidth*0.5+0.25, y: subHeight*2+0.5, width: subWidth*0.5-0.25, height: subHeight-0.5)
        let alert_rightBtn = UIButton(frame: frame1);
        alert_bgview.addSubview(alert_rightBtn)
        alert_rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        alert_rightBtn.setTitleColor(UIColor.orange, for: .normal)
        alert_rightBtn.backgroundColor = UIColor.white
        alert_rightBtn.tag = 222;
        alert_rightBtn.addTarget(self, action: #selector(alertButtonClickAction(_ : )), for: .touchUpInside);
        // 动画
        let popAnimation = CAKeyframeAnimation(keyPath: "transform")
        popAnimation.duration = 0.4
        let CATrans1 = NSValue.init(caTransform3D: CATransform3DMakeScale(0.01, 0.01, 1.0))
        let CATrans2 = NSValue.init(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0))
        // let CATrans3 = NSValue.init(caTransform3D: CATransform3DMakeScale(0.95, 0.95, 1.0))
        popAnimation.values = [CATrans1,CATrans2 ]
        popAnimation.keyTimes = [0.0, 0.5, 0.75, 1.0]
        let kCAMediaTiming1 = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        let kCAMediaTiming2 = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        let kCAMediaTiming3 = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        popAnimation.timingFunctions = [kCAMediaTiming1,kCAMediaTiming2,kCAMediaTiming3]
        alert_bgview.layer.add(popAnimation, forKey: nil)
        // 赋值
        if (title as? String) != nil {
            alert_titlabel.text = title as? String;
        }else if (title as? NSAttributedString) != nil {
            alert_titlabel.attributedText = title as? NSAttributedString;
        }
        if (message as? String) != nil {
            alert_meslable.text = message as? String;
        }else if (message as? NSAttributedString) != nil {
            alert_meslable.attributedText = message as? NSAttributedString;
        }
        if (leftBtnTitle as? String) != nil {
            alert_leftBtn.setTitle(leftBtnTitle as? String, for: .normal);
        }else if (message as? NSAttributedString) != nil {
            alert_leftBtn.setAttributedTitle(leftBtnTitle as? NSAttributedString, for: .normal);
        }
        if (rightBtnTitle as? String) != nil {
            alert_rightBtn.setTitle(rightBtnTitle as? String, for: .normal);
        }else if (message as? NSAttributedString) != nil {
            alert_rightBtn.setAttributedTitle(rightBtnTitle as? NSAttributedString, for: .normal);
        }
        // 只有标题没有内容 标题居中
        if title != nil && message == nil{
            alert_titlabel.frame = CGRect(x: 10, y: 0, width: subWidth-20, height: subHeight*2)
            alert_meslable.frame.size = CGSize(width: 0, height: 0)
        }
            // 没有标题只有内容 内容居中
        else if title == nil && message != nil{
            alert_titlabel.frame.size = CGSize(width: 0, height: 0)
            alert_meslable.frame = CGRect(x: 10, y: 0, width: subWidth-20, height: subHeight*2)
        }
            // 既有标题 也有内容
        else if title != nil && message != nil{
            alert_titlabel.frame = CGRect(x: 10, y: 5, width: subWidth-20, height: subHeight-5)
            alert_meslable.frame = CGRect(x: 10, y: subHeight-0.5, width: subWidth-20, height: subHeight-5)
        }
        // 只有左按钮没有右按钮 左按钮居中
        if leftBtnTitle != nil && rightBtnTitle == nil{
            alert_leftBtn.frame = CGRect(x: 0, y: subHeight*2+1, width: subWidth, height: subHeight-0.5)
            alert_rightBtn.frame.size = CGSize(width: 0, height: 0)
        }
            // 只有右按钮 没有左按钮 右按钮居中
        else if leftBtnTitle == nil && rightBtnTitle != nil{
            alert_leftBtn.frame.size = CGSize(width: 0, height: 0)
            alert_rightBtn.frame = CGRect(x: 0, y: subHeight*2+0.5, width: subWidth, height: subHeight-0.5)
        }
            // 既有左按钮 也有右按钮
        else if leftBtnTitle != nil && rightBtnTitle != nil{
            alert_leftBtn.frame = CGRect(x: 0, y: subHeight*2+0.5, width: subWidth*0.5-0.25, height: subHeight-0.5)
            alert_rightBtn.frame = CGRect(x: subWidth*0.5+0.25, y: subHeight*2+0.5, width: subWidth*0.5-0.25, height: subHeight-0.5)
        }
        // 添加手势看需求而定多数情况下是不需要的
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapClick));
        self.isUserInteractionEnabled = true;
        self.addGestureRecognizer(tap);
    }
    @objc private func tapClick(){
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0;
        }, completion: { (isfinsh) in
            self.removeFromSuperview();
        });
    }
    @objc private func alertButtonClickAction(_ button:UIButton){
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0;
        }, completion: { (isfinsh) in
            self.removeFromSuperview();
        })
        if(button.tag == 111 && self.leftBtnClickBlock != nil){
            self.leftBtnClickBlock!();
        }
        else if(button.tag == 222 && self.rightBtnClickBlock != nil){
            self.rightBtnClickBlock!();
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /**  计算文字宽带*/
    private func getStringSizeWidth(string:String,font:UIFont,height:CGFloat) -> CGSize {
        let normalText: NSString = string as NSString;
        let size = CGSize(width: 10000, height: height);
        let dic  = NSDictionary(object: font, forKey: NSAttributedStringKey.font as NSCopying);
        let stringSize = normalText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedStringKey : AnyObject], context:nil).size;
        return stringSize;
    }
    /** 计算富文本size*/
    private func getAttStringSizeWith(attString:NSAttributedString,height:CGFloat)->CGSize{
        let size  = CGSize(width: 10000, height: height);
        var range = NSRange(location: 0, length: attString.length);
        let dic   = attString.attributes(at: 0, effectiveRange: &range);// 富文本属性
        let normalText: NSString = attString.string as NSString;
        let stringSize = normalText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic, context:nil).size;
        return stringSize;
    }
}

