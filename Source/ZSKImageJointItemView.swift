//
//  ZSKImageJointItemView.swift
//  CustomImageMannger
//
//  Created by 张少康 on 2021/2/25.
//

import UIKit

class ZSKImageJointItemView: UIView {
    
    lazy var contentImageView: UIImageView = {
        let imageView = UIImageView(frame: self.bounds)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        return imageView
    }()
    
    lazy var choseBorderView: UIView = {
        let view = UIView(frame: self.bounds)
        view.backgroundColor = .clear
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor(red: 5/255.0, green: 129/255.0, blue: 206/255.0, alpha: 1).cgColor
        view.isUserInteractionEnabled = false
        view.isHidden = true
        return view
    }()
    
    func updataChoseStatus(isChose: Bool) {
        choseBorderView.isHidden = !isChose
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(contentImageView)
        self.addSubview(choseBorderView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


