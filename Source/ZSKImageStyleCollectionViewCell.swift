//
//  ZSKImageStyleCollectionViewCell.swift
//  CustomImageMannger
//
//  Created by 张少康 on 2021/2/24.
//

import UIKit

class ZSKImageStyleCollectionViewCell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView(frame: self.bounds)
        iv.contentMode = .center
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }
    
    func updateCellData(data: ZSKimageJigsawStyleModel, isSelect: Bool) {
        imageView.image = isSelect ? ZSKimageJigsawManager.getZSKImage(from: data.select) : ZSKimageJigsawManager.getZSKImage(from: data.normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
