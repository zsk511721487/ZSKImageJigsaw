//
//  ZSKImageJiasawItemView.swift
//  CustomImageMannger
//
//  Created by 张少康 on 2021/2/23.
//

import UIKit

typealias ZSKSelectImage = (_ model: ZSKJiasawItemModel) -> Void

extension ZSKImageJiasawItemView {
    convenience init(frame: CGRect,model: ZSKJiasawItemModel, move: @escaping ZSKSelectImage) {
        self.init(frame: frame)
        self.selectImage = move
        self.model = model
        self.updateViews()
    }
}

class ZSKImageJiasawItemView: UIView,UIGestureRecognizerDelegate {
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        iv.contentMode = .scaleAspectFill
        iv.isUserInteractionEnabled = true
        iv.isMultipleTouchEnabled = true
        return iv
    }()
    
    lazy var bgView: UIView = {
        let view = UIView(frame: self.bounds)
        view.backgroundColor = .clear
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor(red: 5/255.0, green: 129/255.0, blue: 206/255.0, alpha: 1).cgColor
        view.isUserInteractionEnabled = false
        view.isHidden = true
        return view
    }()
     
    var model: ZSKJiasawItemModel?
    
    var selectImage: ZSKSelectImage?
    
    fileprivate func updateViews() {
        self.imageView.image = self.model?.image
    }
    
    var oldPoint: CGPoint?
    
    var newFrame: CGRect?
    
    var lastScaleFactor: CGFloat = 1
                
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        self.addSubview(imageView)
        self.addSubview(bgView)
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchGesture(gesture:)))
        pinchGesture.delegate = self
        self.addGestureRecognizer(pinchGesture)
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tap(gesture: UITapGestureRecognizer) {
        print("tap\(gesture.state.rawValue)")
    }
    
    func updateImageFrame(point: CGPoint) {
        imageView.center = CGPoint(x: imageView.center.x + point.x, y: imageView.center.y + point.y)
    }
    
//    @objc func pan(gesture: UIPanGestureRecognizer) {
//        let point = gesture.translation(in: imageView.superview)
//        if gesture.state == .began {
//            self.selectImage!(model!)
//        }else if gesture.state == .changed {
//            let fatherPoint = gesture.location(in: self.superview)
//            let rect = self.frame
//            if rect.contains(fatherPoint) {
//                imageView.center = CGPoint(x: imageView.center.x + point.x, y: imageView.center.y + point.y)
//                gesture.setTranslation(CGPoint.zero, in: imageView.superview)
//            }else {
//                self.imageView.isHidden = true
//                gesture.isEnabled = false
//            }
//        }
//    }
    
    @objc func pinchGesture(gesture: UIPinchGestureRecognizer) {
        let factor = gesture.scale
        
        if factor > 1 {
            imageView.transform = CGAffineTransform(scaleX: lastScaleFactor + factor - 1, y: lastScaleFactor + factor - 1)
        }else {
            imageView.transform = CGAffineTransform(scaleX: lastScaleFactor * factor, y: lastScaleFactor * factor )
        }
        
        print("factor:\(factor),lastScaleFactor:\(lastScaleFactor)")
        
        if gesture.state == .ended {
            if factor > 1 {
                lastScaleFactor = lastScaleFactor + factor - 1
            }else {
                lastScaleFactor = lastScaleFactor * factor
            }
        }
        
        

    }
    
    func setAchorPint(anchorPoint: CGPoint, view: UIView) {
        let oldOrigin = view.frame.origin
        view.layer.anchorPoint = anchorPoint
        let newOrigin = view.frame.origin
        
        let transition = CGPoint(x: newOrigin.x - oldOrigin.x, y: newOrigin.y - oldOrigin.y)
        view.center = CGPoint(x: view.center.x - transition.x, y: view.center.y - transition.y)
    }
    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
    
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
    
}


extension ZSKImageJiasawItemView: UIScrollViewDelegate {
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        scrollView.setZoomScale(scale, animated: false)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
