//
//  ZSKJointCollectionViewCell.swift
//  CustomImageMannger
//
//  Created by 张少康 on 2021/3/10.
//

import UIKit

class ZSKJointCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ZSKJointCollectionViewCell"
    
    lazy var showImageView: ZSKImageJointItemView = {
        let view = ZSKImageJointItemView(frame: self.bounds)
        view.contentImageView.contentMode = .scaleAspectFit
        return view
    }()
    
    func updateSubviews(isSelect: Bool,image: UIImage?) {
        if let img = image {
            showImageView.contentImageView.image = img
            showImageView.updataChoseStatus(isChose: isSelect)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(showImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
