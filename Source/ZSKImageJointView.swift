//
//  ZSKImageJointView.swift
//  CustomImageMannger
//
//  Created by 张少康 on 2021/2/25.
//

import UIKit

 
class ZSKImageJointView: UIView {

    lazy var scrollview: UIScrollView = {
        let sv = UIScrollView( frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        sv.backgroundColor = .white
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    fileprivate var images: [UIImage] = []
    
    fileprivate var currentIndex: Int = -1
    
    fileprivate var items: [ZSKImageJointItemView] = []
    
    var selctImage: ((_ isEdit: Bool ,_ index: Int) -> Void)?
    
    func cleanAllStatus() {
        self.currentIndex = -1
        for item in items {
            item.updataChoseStatus(isChose: false)
        }
    }
    
    func updateTabeViewData() {
        for item in self.scrollview.subviews {
            item.removeFromSuperview()
        }
        var scrollViewHeight: CGFloat = 0
        
        for index in 0..<images.count {
            let image = images[index]
            let heightScale = image.size.height/image.size.width
            let itemView = ZSKImageJointItemView(frame: CGRect(x: 0, y: scrollViewHeight, width: self.bounds.width, height: self.bounds.width * heightScale))
            itemView.tag = 10086 + index
            itemView.contentImageView.image = image
            self.scrollview.addSubview(itemView)
            scrollViewHeight += self.bounds.width * heightScale
            items.append(itemView)
        }
        
        self.scrollview.contentSize = CGSize(width: self.bounds.width, height: scrollViewHeight)
    }
    
    @objc fileprivate func tap(tap:UITapGestureRecognizer) {
        let point = tap.location(in: self)
        for item in items {
            let rect = item.convert(item.bounds, to: self)
            print(rect)
            if rect.contains(point) {
                if self.currentIndex == (item.tag - 10086) {
                    item.updataChoseStatus(isChose: false)
                    self.currentIndex = -1
                    changeSelectStatus(isEdit: false)
                }else {
                    item.updataChoseStatus(isChose: true)
                    self.currentIndex = item.tag - 10086
                    changeSelectStatus(isEdit: true)
                }
            }else {
                item.updataChoseStatus(isChose: false)
            }
        }
    }
    
    fileprivate func changeSelectStatus(isEdit: Bool) {
        if selctImage != nil {
            selctImage!(isEdit,self.currentIndex)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        let tap = UITapGestureRecognizer(target: self, action: #selector(tap(tap:)))
        self.addSubview(scrollview)
        self.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ZSKImageJointView {
    convenience init(frame: CGRect,images: [UIImage]) {
        self.init(frame:frame)
        self.images = images
        self.updateTabeViewData()
    }
}


