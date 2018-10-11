//
//  ZJHUD.swift
//  zhsiOS
//
//  Created by 小黎 on 2018/3/24.
//  Copyright © 2018年 LD. All rights reserved.
//
/** 归期•寒 */
import UIKit
public enum ZJHudMesAlignment{
    case top      //页眉
    case center   //中间
    case botton   //页脚
}
class ZJHUD: NSObject {
    private typealias Task = (_ cancel : Bool) -> Void
    /** 添加加载等待*/
    class func showloading(_ mes:String) {
        self.hiddenFromSuperView();
        let hud = ZJHUDView(true, mes, mes, nil);
        hud.tag = 303;
        let window = UIApplication.shared.keyWindow;
        window?.addSubview(hud);
        self.hidden(20.0);
    }
    /** 添加提示语*/
    class func showMessage(_ mes:String) {
        self.showMessage(mes, .top);
    }
    /** 添加提示语*/
    class func showMessage(_ mes:String ,_ alignment:ZJHudMesAlignment) {
        self.hiddenFromSuperView();
        let hud = ZJHUDView(false, "", mes, alignment);
        hud.tag = 202;
        let window = UIApplication.shared.keyWindow;
        window?.addSubview(hud);
        self.afterExecutive(1.0, task: {
            let window = UIApplication.shared.keyWindow;
            for  hud in (window?.subviews)! {
                if hud.isKind(of: ZJHUDView.self) && hud.tag == 202 {
                    UIView.animate(withDuration: 0.5, animations: {
                        hud.alpha = 0;
                    }, completion: { (isfinsh) in
                        hud.removeFromSuperview();
                    })
                }
            }
        })
    }
    /** 隐藏HUD*/
    class func hidden(_ time:TimeInterval){
        self.afterExecutive(time, task: {
            let window = UIApplication.shared.keyWindow;
            for  hud in (window?.subviews)! {
                if hud.isKind(of: ZJHUDView.self)==true && hud.tag == 303{
                    UIView.animate(withDuration: 0.5, animations: {
                        hud.alpha = 0;
                    }, completion: { (isfinsh) in
                        hud.removeFromSuperview();
                    })
                }
            }
        })
    }
    private class func hiddenFromSuperView(){
        let window = UIApplication.shared.keyWindow;
        for subView in (window?.subviews)! {
            if subView.isKind(of: ZJHUDView.self){
                subView.removeFromSuperview();
            }
        }
    }
    /** 延时执行*/
    private class func afterExecutive(_ time: TimeInterval, task: @escaping ()->()) {
        
        func dispatch_later(block: @escaping ()->()) {
            let t = DispatchTime.now() + time
            DispatchQueue.main.asyncAfter(deadline: t, execute: block)
        }
        var closure: (()->Void)? = task
        var result: Task?
        
        let delayedClosure: Task = {
            cancel in
            if let internalClosure = closure {
                if (cancel == false) {
                    DispatchQueue.main.async(execute: internalClosure)
                }
            }
            closure = nil
            result = nil
        }
        
        result = delayedClosure
        
        dispatch_later {
            if let delayedClosure = result {
                delayedClosure(false)
            }
        }
        //return result
    }
}
private class ZJHUDView: UIView {
    private var KHud_Width  = UIScreen.main.bounds.size.width
    private var KHud_Height = UIScreen.main.bounds.size.height
    //重写初始化方法
    init(_ Isloading:Bool,_ loadMes:String, _ mes:String,_ alignment:ZJHudMesAlignment?) {
        super.init(frame: CGRect(x: 0, y: 0, width: KHud_Width, height: KHud_Height))
        // self.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
        if(Isloading == true){
            self.showloading(mes)
        }else{
            self.showMessage(mes, alignment)
        }
    }
    /** 添加加载等待*/
    private func showloading(_ mes:String) {
        let hud_view = UIView()
        hud_view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        hud_view.layer.cornerRadius = 5
        hud_view.layer.masksToBounds = true
        self.addSubview(hud_view)
        
        let hud_imgview = UIImageView()
        hud_view.addSubview(hud_imgview)
        hud_imgview.image = UIImage(named: "waiting")
        // 创建动画
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        // 设置动画属性
        anim.toValue = 10 * Double.pi // 旋转速度
        anim.repeatCount = MAXFLOAT
        anim.duration = 10
        anim.isRemovedOnCompletion = false
        // 将动画添加到图层上
        hud_imgview.layer.add(anim, forKey: nil)
        
        let mes_font = UIFont.systemFont(ofSize: 15)
        let hud_meslabel = UILabel()
        hud_view.addSubview(hud_meslabel)
        hud_meslabel.text = mes
        hud_meslabel.textColor = UIColor.white
        hud_meslabel.textAlignment = .center
        hud_meslabel.font = mes_font
        var mes_width = self.getTextWidth(textStr: mes, font: mes_font, height: 40)
        mes_width = mes_width>KHud_Width*0.6 ? CGFloat(KHud_Width*0.6) : mes_width
        mes_width = mes_width<KHud_Width*0.3 ? CGFloat(KHud_Width*0.3) : mes_width
        hud_view.frame.size = CGSize(width: mes_width+10, height: mes_width)
        hud_view.center = CGPoint(x: KHud_Width*0.5, y: KHud_Height*0.4)
        if mes != "" {
            hud_imgview.frame = CGRect(x: 20, y: 0, width: mes_width-30, height: mes_width-30)
            hud_meslabel.frame = CGRect(x: 10, y: hud_imgview.frame.maxY, width: mes_width-10, height: 30)
        }else {
            hud_imgview.frame = CGRect(x: 20, y: 15, width: mes_width-30, height: mes_width-30)
        }
    }
    /** 添加提示语*/
    private func showMessage(_ mes:String ,_ alignment:ZJHudMesAlignment?) {
        let mes_font = UIFont.systemFont(ofSize: 15)
        let mes_label = UILabel()
        mes_label.tag = 9999999
        self.addSubview(mes_label)
        mes_label.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        //mes_label.backgroundColor = UIColor.black
        mes_label.textColor = UIColor.white
        //mes_label.textColor = UIColor.black
        mes_label.text = mes
        mes_label.textAlignment = .center
        mes_label.font = mes_font
        mes_label.layer.cornerRadius = 5
        mes_label.layer.masksToBounds = true
        
        var mes_width = self.getTextWidth(textStr: mes, font: mes_font, height: 30)
        mes_width = mes_width>KHud_Width*0.6 ? CGFloat(KHud_Width*0.6) : mes_width
        mes_width = mes_width<KHud_Width*0.3 ? CGFloat(KHud_Width*0.3) : mes_width
        mes_label.frame.size = CGSize(width: mes_width+10, height: 45)
        
        if alignment == nil || alignment == ZJHudMesAlignment.center {
            mes_label.center = CGPoint(x: KHud_Width*0.5, y: KHud_Height*0.5)
            return
        }else if alignment == ZJHudMesAlignment.top {
            mes_label.center = CGPoint(x: KHud_Width*0.5, y: KHud_Height*0.2)
        }else if alignment == ZJHudMesAlignment.botton {
            mes_label.center = CGPoint(x: KHud_Width*0.5, y: KHud_Height*0.7)
        }
    }
    
    /**  计算文字宽带*/
    private func getTextWidth(textStr:String,font:UIFont,height:CGFloat) -> CGFloat {
        let normalText: NSString = textStr as NSString
        let size = CGSize(width: 10000, height: height)
        let dic = NSDictionary(object: font, forKey: NSAttributedStringKey.font as NSCopying)
        
        let stringSize = normalText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedStringKey : AnyObject], context:nil).size
        return stringSize.width
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
