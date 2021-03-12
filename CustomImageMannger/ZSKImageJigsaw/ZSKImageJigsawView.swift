//
//  ZSKImageJigsawView.swift
//  CustomImageMannger
//
//  Created by 张少康 on 2021/2/23.
//

import UIKit

class ZSKJiasawItemModel: NSObject {
    var widthScale: CGFloat = 0.0
    var heightScale: CGFloat = 0.0
    var index: Int = 0
    var itemFrame: CGRect
    var image: UIImage?
    var isSelect: Bool = false
    init(frame: CGRect) {
        self.itemFrame =  frame
    }
}

extension ZSKImageJigsawView {
    convenience init(frame: CGRect,images: [UIImage], styleModel: ZSKimageJigsawStyleModel) {
        self.init(frame: frame)
        self.images = images
        self.styleModel = styleModel
        self.updateViews()
    }
}

class ZSKImageJigsawView: UIView,UIGestureRecognizerDelegate {
    
    var images:[UIImage] = []
    
    var styleModel: ZSKimageJigsawStyleModel? {
        didSet {
            self.updateViews()
        }
    }
        
    fileprivate var items: [ZSKImageJiasawItemView] = []
    
    fileprivate var moveModel: ZSKImageJiasawItemView?
    
    fileprivate var moveToModel: ZSKImageJiasawItemView?
    
    var imageExchange: (( _ moveIndex: Int ,_ toIndex: Int) ->Void)?
    
    var itemCanEdit: (( _ canEdit: Bool ,_ index: Int?) ->Void)?
    
    fileprivate lazy var movePreviewView:UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.width/3))
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0.6
        imageView.isHidden = true
        return imageView
    }()
    
    func cleanItemStatue() {
        moveModel = nil
        moveToModel = nil
        for item in items {
            item.bgView.isHidden = true
        }
    }
    
    func updateImages(image: UIImage) {
        images[moveModel!.model!.index] = image
        moveModel?.imageView.image = image
    }
    
    func updateImages(images: [UIImage]) {
        self.images = images
        updateViews()
    }
        
    fileprivate func updateViews() {
        items.removeAll()
        for item in self.subviews {
            item.removeFromSuperview()
        }
 
        for index in 0..<images.count {
            let item = ZSKJiasawItemModel(frame: CGRect.zero)
            item.image = images[index]
            item.index = index
            let frameModel = styleModel!.itemsFrames[index]
            let x = ZSKimageJigsawManager.getRealScaleSize(originalSize: self.bounds.width, currentScale: frameModel.x)
            let y = ZSKimageJigsawManager.getRealScaleSize(originalSize: self.bounds.height, currentScale: frameModel.y)
            let width = ZSKimageJigsawManager.getRealScaleSize(originalSize: self.bounds.width, currentScale: frameModel.width)
            let height = ZSKimageJigsawManager.getRealScaleSize(originalSize: self.bounds.height, currentScale: frameModel.height)
            let itemView = ZSKImageJiasawItemView(frame: CGRect(x: x, y: y, width: width, height: height), model: item){ _ in
            }
            items.append(itemView)
            self.addSubview(itemView)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tap(tap:)))
        tap.delegate = self
        let pan = UIPanGestureRecognizer(target: self, action: #selector(pan(pan:)))
        pan.delegate = self
        self.addGestureRecognizer(pan)
        self.addGestureRecognizer(tap)
        
        self.addSubview(movePreviewView)
    }
    
    @objc func tap(tap:UITapGestureRecognizer) {
        let point = tap.location(in: self)
        for item in items {
            item.bgView.isHidden = true
            if item.frame.contains(point) {
                if moveModel != nil {
                    if moveModel == item {
                        moveModel?.bgView.isHidden = true
                        moveModel = nil
                        changeEditType(canEdit: false)
                        //取消编辑状态
                    }else {
                        item.bgView.isHidden = false
                        moveModel = item
                        //进入编辑状态
                        changeEditType(canEdit: true)
                    }
                }else {
                    item.bgView.isHidden = false
                    moveModel = item
                    //进入编辑状态
                    changeEditType(canEdit: true)
                }
            }
        }
    }
    
    fileprivate func changeEditType(canEdit: Bool) {
        if itemCanEdit != nil {
            itemCanEdit!(canEdit,moveModel?.model?.index ?? 0)
        }
    }
    
    @objc func pan(pan:UIPanGestureRecognizer) {
        let point = pan.location(in: self)
        print(point)
        if pan.state == .began {
            for item in items {
                if item.frame.contains(point) {
                    moveModel = item
                    movePreviewView.image = item.imageView.image
                }
            }
        }
        
        if pan.state == .changed {
            movePreviewView.center = point
            for item in items {
                item.bgView.isHidden = true
                if item.frame.contains(point) {
                    moveToModel = item
                    if item != moveModel {
                        item.bgView.isHidden = false
                        item.imageView.isHidden = false
                        moveModel?.imageView.isHidden = true
                        movePreviewView.isHidden = false
                    }else {
                        item.bgView.isHidden = true
                        item.updateImageFrame(point: pan.translation(in: self))
                    }
                    
                }
            }
            pan.setTranslation(CGPoint(x: 0, y: 0), in: self)
        }

        if pan.state == .ended {
            movePreviewView.isHidden = true
            if moveModel == moveToModel || moveToModel == nil {
                for item in items {
                    item.bgView.isHidden = true
                    item.imageView.isHidden = false
                }
                moveModel = nil
            }else {
                if imageExchange != nil {
                    imageExchange!(moveModel!.model!.index,moveToModel!.model!.index)
                }
                (images[moveModel!.model!.index], images[moveToModel!.model!.index]) = (images[moveToModel!.model!.index],images[moveModel!.model!.index])
                self.updateViews()
            }
        }
                
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if !self.isUserInteractionEnabled || self.isHidden || self.alpha <= 0 {
            return nil
        }
        
        if !self.point(inside: point, with: event) {
            return nil
        }
        
        for item in self.subviews {
            let subPoint = self.convert(point, to: item)
            let fitView = item.hitTest(subPoint, with: event)
            if fitView != nil {
                return fitView
            }
        }
        return self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
