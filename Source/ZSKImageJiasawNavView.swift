//
//  ZSKImageJiasawNavView.swift
//  CustomImageMannger
//
//  Created by 张少康 on 2021/2/25.
//

import UIKit

class ZSKImageJiasawNavView: UIView {

    lazy var closeBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: zskjigsaw_top_afe_height, width: 60, height: 44))
        btn.setImage(ZSKimageJigsawManager.getZSKImage(from: "message_icon_delete"), for: .normal)
        btn.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        btn.showsTouchWhenHighlighted = false
        return btn
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.bounds = CGRect(x: 0, y: 0, width: 100, height: 44)
        label.center = CGPoint(x: self.bounds.width/2, y: zskjigsaw_top_afe_height + 22)
        label.text = "拼图"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    lazy var finishBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("完成", for: .normal)
        btn.bounds = CGRect(x: 0, y: 0, width: 60, height: 44)
        btn.center = CGPoint(x: self.bounds.width - 30, y: zskjigsaw_top_afe_height + 22)
        btn.titleLabel?.font = .systemFont(ofSize: 16)
        btn.showsTouchWhenHighlighted = false
        btn.setTitleColor(UIColor(red: 5/255.0, green: 129/255.0, blue: 206/255.0, alpha: 1), for: .normal)
        btn.addTarget(self, action: #selector(finishButtonAction), for: .touchUpInside)
        return btn
    }()
    
    var close: (()->Void)?
    
    var finish: (()->Void)?
    
    @objc func closeButtonAction() {
        if close != nil {
            close!()
        }
    }
    
    @objc func finishButtonAction() {
        if finish != nil {
            finish!()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.addSubview(closeBtn)
        self.addSubview(titleLabel)
        self.addSubview(finishBtn)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
