//
//  ZSKImageEditView.swift
//  CustomImageMannger
//
//  Created by 张少康 on 2021/2/25.
//

import UIKit

let zsk_edit_itemWidth = (zskjigsaw_screen_width - 30)/3

enum ZSKJiasawEditType: Int {
    case cancle = 0
    case change = 1
    case delete = 2
}

class ZSKImageEditView: UIView {
    
    @objc func opretionAction(sender: UIButton) {
        let type = ZSKJiasawEditType.init(rawValue: sender.tag - 10000)
        choseBtn(choseType: type!)
    }
    
    fileprivate func choseBtn(choseType from: ZSKJiasawEditType) {
        if selectOpretion != nil {
            selectOpretion!(from)
        }
    }
    
    var selectOpretion: ((_ type:ZSKJiasawEditType ) -> Void)?

    fileprivate lazy var cancleButton: UIButton = {
        let btn = UIButton()
        btn.center = CGPoint(x: 15 + zsk_edit_itemWidth/2, y: 25)
        btn.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        btn.setImage(ZSKimageJigsawManager.getZSKImage(from: "zsk_cancle_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .zsk_titleColr
        btn.showsTouchWhenHighlighted = false
        btn.tag = 10000
        btn.addTarget(self, action: #selector(opretionAction(sender:)), for: .touchUpInside)
        return btn
    }()
    
    fileprivate lazy var changeButton: UIButton = {
        let btn = UIButton()
        btn.center = CGPoint(x: self.bounds.width/2, y: 25)
        btn.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        btn.setImage(ZSKimageJigsawManager.getZSKImage(from: "zsk_change_image_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .zsk_titleColr
        btn.tag = 10001
        btn.addTarget(self, action: #selector(opretionAction(sender:)), for: .touchUpInside)
        btn.showsTouchWhenHighlighted = false
        return btn
    }()
    
    fileprivate lazy var deleteButton: UIButton = {
        let btn = UIButton()
        btn.center = CGPoint(x: self.bounds.width/2 + zsk_edit_itemWidth, y: 25)
        btn.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        btn.setImage(ZSKimageJigsawManager.getZSKImage(from: "zsk_delete_icon"), for: .normal)
        btn.tag = 10002
        btn.addTarget(self, action: #selector(opretionAction(sender:)), for: .touchUpInside)
        btn.showsTouchWhenHighlighted = false
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .zsk_groupedBackgroundColor
        self.addSubview(cancleButton)
        self.addSubview(changeButton)
        self.addSubview(deleteButton)
        
        let cancleLabel = UILabel()
        cancleLabel.bounds = CGRect(x: 0, y: 0, width: 50, height: 13)
        cancleLabel.center = CGPoint(x: cancleButton.center.x, y: cancleButton.bounds.height)
        cancleLabel.text = "取消"
        cancleLabel.textAlignment = .center
        cancleLabel.textColor = .zsk_titleColr
        cancleLabel.font = .systemFont(ofSize: 12)
        self.addSubview(cancleLabel)
        
        let changeLabel = UILabel()
        changeLabel.bounds = CGRect(x: 0, y: 0, width: 50, height: 13)
        changeLabel.center = CGPoint(x: changeButton.center.x, y: changeButton.bounds.height)
        changeLabel.text = "更换图片"
        changeLabel.textAlignment = .center
        changeLabel.textColor = .zsk_titleColr
        changeLabel.font = .systemFont(ofSize: 12)
        self.addSubview(changeLabel)
        
        
        let deleteLabel = UILabel()
        deleteLabel.bounds = CGRect(x: 0, y: 0, width: 50, height: 13)
        deleteLabel.center = CGPoint(x: deleteButton.center.x, y: deleteButton.bounds.height)
        deleteLabel.text = "删除"
        deleteLabel.textAlignment = .center
        deleteLabel.textColor = UIColor.init(red: 243/255.0, green: 56/255.0, blue: 56/255.0, alpha: 1)
        deleteLabel.font = .systemFont(ofSize: 12)
        self.addSubview(deleteLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
