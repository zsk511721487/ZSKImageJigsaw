//
//  ZSKShowViewController.swift
//  CustomImageMannger
//
//  Created by 张少康 on 2021/2/22.
//

import UIKit
import Photos
import MobileCoreServices

let zskjigsaw_screen_width: CGFloat = UIScreen.main.bounds.width

let zskjigsaw_screen_height: CGFloat = UIScreen.main.bounds.height

let zskjigsaw_top_afe_height: CGFloat = UIApplication.shared.statusBarFrame.height > 20 ? 44 : 20

let zskjigsaw_bottom_safe_height: CGFloat = UIApplication.shared.statusBarFrame.height > 20 ? 34 : 0

let zskjigsaw_bottom_nav_top_height: CGFloat = UIApplication.shared.statusBarFrame.height > 20 ? 88 : 64

public protocol ZSKImageJigsawDelegate: NSObjectProtocol {
    
    
    /// 生成图片
    /// - Parameters:
    ///   - imageJigsaw: self
    ///   - image: 返回生成的图片
    func imageJigsaw(imageJigsaw: UIViewController,image: UIImage)
    
    
    /// 是否允许删除当前图片
    /// - Parameters:
    ///   - imageJigsaw: self
    ///   - index: 当前图片index
    func imageJiasawCanDelete(imageJigsaw: UIViewController, index: Int) ->Bool
    
    
    /// 图片剩下两张的时候不允许删除，可以在里面添加tost
    /// - Parameter imageJigsaw: self
    func imagejiasawNotAllowDelete(imageJigsaw: UIViewController)
    
}

public class ZSKImageJigsawVC: UIViewController {

    //传入的图片集合
    public var images: [UIImage] = [] {
        didSet{
            if images.count == 1 {
                images.append(images[0])
            }
        }
    }
    
    public weak var delegate: ZSKImageJigsawDelegate?
    
    fileprivate var jiasawView: ZSKImageJigsawView!
    
    fileprivate var styleView: ZSKImageStyleView!
    
    fileprivate var jointView: ZSKImageJointView!
    
    fileprivate var editView: ZSKImageEditView!
    
    fileprivate var styleArray: [ZSKimageJigsawStyleModel]?
    
    fileprivate var imagePickerVC: UIImagePickerController?
    
    fileprivate var choseIndex: Int = 0
        
    fileprivate var isCanEdit: Bool = false {
        didSet {
            if oldValue != isCanEdit {
                self.updateLayout()
            }
        }
    }
    
    fileprivate var isJonit: Bool = false {
        didSet {
            self.jointView.isHidden = !isJonit
            if isJonit {
                self.view.bringSubviewToFront(self.jointView)
            }
        }
    }
    
    fileprivate func updateLayout() {
        UIView.animate(withDuration: 0.3) {
            let editViewY = self.isCanEdit ? (zskjigsaw_screen_height - 60 - zskjigsaw_bottom_safe_height) : zskjigsaw_screen_height
            self.editView.frame = CGRect(x: 0, y: editViewY , width: zskjigsaw_screen_width, height: 60 + zskjigsaw_bottom_safe_height)
            
            let styleViewY = self.isCanEdit ?  zskjigsaw_screen_height : zskjigsaw_screen_height - 121.0 - zskjigsaw_bottom_safe_height
            self.styleView.frame = CGRect(x: 0, y: styleViewY, width: zskjigsaw_screen_width, height: 121.0 + zskjigsaw_bottom_safe_height)
            
            let difference: CGFloat = self.isCanEdit ?  40 : -40
            self.jiasawView.center = CGPoint(x: self.jiasawView.center.x , y: self.jiasawView.center.y + difference)
            self.jointView.center = CGPoint(x: self.jointView.center.x , y: self.jointView.center.y + difference)
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1)
        
        if let nav = self.navigationController {
            nav.navigationBar.isHidden = true
        }
        
        let nav = ZSKImageJiasawNavView(frame: CGRect(x: 0, y: 0, width: zskjigsaw_screen_width, height: zskjigsaw_bottom_nav_top_height))
        
        nav.close = {
            self.dismiss(animated: true, completion: nil)
        }
        
        nav.finish = {
            DispatchQueue.main.async {
                if self.delegate != nil {
                    self.delegate?.imageJigsaw(imageJigsaw: self, image: self.getCurrenStyleImage())
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        
        view.addSubview(nav)
        
        getStyleArray()
        self.createEditView()
    }
    
    fileprivate func getCurrenStyleImage() ->UIImage{
        
        if isJonit {
            return self.jointView.scrollview.scrollViewShot()!
        }else {
            return self.jiasawView.screenShot()!
        }
    }
    
    fileprivate func getStyleArray() {
        styleArray = ZSKimageJigsawManager.getZSKImageJisawData(key: "\(images.count)")
        createStyleView()
        createJointView()
    }
    
    fileprivate func createEditView() {
        editView = ZSKImageEditView(frame: CGRect(x: 0, y: zskjigsaw_screen_height  , width: zskjigsaw_screen_width, height: 60 + zskjigsaw_bottom_safe_height))
        editView.selectOpretion = {[weak self] type in
            guard let `self` = self else {return}
            switch type {
            case .cancle:
                self.isCanEdit = false
                self.jiasawView.cleanItemStatue()
                self.jointView.cleanAllStatus()
            case .change:
                self.choseImage()
            case .delete:
                self.deleteItem()
            }
        }
        view.addSubview(editView)
    }
    
    fileprivate func createJointView() {
        if jointView != nil {
            jointView.removeFromSuperview()
        }
        jointView = ZSKImageJointView(frame: CGRect(x: 15, y: zskjigsaw_bottom_nav_top_height  , width: zskjigsaw_screen_width - 30, height: zskjigsaw_screen_height - zskjigsaw_bottom_nav_top_height - (121.0 + zskjigsaw_bottom_safe_height)),images: images)
        jointView.selctImage = {[weak self] isEdit,index in
            guard let `self` = self else {return}
            self.choseIndex = index
            self.isCanEdit = isEdit
        }
        view.addSubview(jointView)
        jointView.isHidden = !isJonit
    }
    
    fileprivate func createStyleView() {
        
        if styleView != nil {
            styleView.removeFromSuperview()
        }
        
        styleView = ZSKImageStyleView(frame: CGRect(x: 0, y: zskjigsaw_screen_height - 121.0 - zskjigsaw_bottom_safe_height, width: zskjigsaw_screen_width, height: 121.0 + zskjigsaw_bottom_safe_height))
        styleView.backgroundColor = .white
        styleView.selectIndex = { [weak self] index in
            guard let `self` = self else {return}
            self.jiasawView.styleModel = self.styleArray![index]
            self.updataJiasawViewFrame(currentIndex: index)
        }
        
        styleView.selectIsJoint = {[weak self] isJoint in
            guard let `self` = self else {return}
            self.isJonit = isJoint
        }
        
        view.addSubview(styleView)
        
        styleView.updateSubViews(items: styleArray!, currentIndex: 0, jointImage: images[0],isJoint:self.isJonit)
        
        self.updataJiasawViewFrame(currentIndex: 0)
    }
    
    fileprivate func updataJiasawViewFrame(currentIndex: Int) {
        if jiasawView != nil {
            jiasawView.removeFromSuperview()
        }
        let selectModel = self.styleArray![currentIndex]
        let weight = selectModel.weight == 0 ? zskjigsaw_screen_width - 30 : zskjigsaw_screen_height - zskjigsaw_bottom_nav_top_height - (151.0 + zskjigsaw_bottom_safe_height)
        let originalHeight = zskjigsaw_screen_height - zskjigsaw_bottom_nav_top_height - (151.0 + zskjigsaw_bottom_safe_height)
        let originalWidth = zskjigsaw_screen_width - 30
        var width: CGFloat = 0.0
        var height: CGFloat = 0.0
        if selectModel.weight == 1 {
            width = zskjigsaw_screen_width - 30
            height = (zskjigsaw_screen_width - 30) / selectModel.viewWidth
        }else {
            width = ZSKimageJigsawManager.getRealScaleSize(originalSize: weight, currentScale: selectModel.viewWidth)
            height = ZSKimageJigsawManager.getRealScaleSize(originalSize: weight, currentScale: selectModel.viewHeight)
        }
        
        let y = (originalHeight - height)/2 + zskjigsaw_bottom_nav_top_height + 15
        let x = (originalWidth - width)/2 + 15
        jiasawView = ZSKImageJigsawView(frame: CGRect(x: x, y: y, width: width, height: height), images: images,styleModel: selectModel)
        jiasawView.itemCanEdit = {[weak self] canEdit, index in
            guard let `self` = self else {return}
            self.choseIndex = index!
            self.isCanEdit = canEdit
        }
        
        jiasawView.imageExchange = {[weak self] from,to in
            guard let `self` = self else {return}
            (self.images[from], self.images[to]) = (self.images[to],self.images[from])
        }
        view.addSubview(jiasawView)
    }
    
    fileprivate func deleteItem() {
        if images.count  == 2 {
            if delegate != nil {
                delegate?.imagejiasawNotAllowDelete(imageJigsaw: self)
            }
        }else {
            if delegate != nil {
                if delegate?.imageJiasawCanDelete(imageJigsaw: self, index: self.choseIndex) == false {
                    return
                }
            }
        }
        
        images.remove(at: self.choseIndex)
        isCanEdit = false
        getStyleArray()
    }
    
    fileprivate func choseImage() {
                
        if imagePickerVC == nil {
            imagePickerVC = UIImagePickerController()
            imagePickerVC!.delegate = self
        }
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            PHPhotoLibrary.requestAuthorization {[weak self] (status) in
                guard let `self` = self else {return}
                switch status {
                case .notDetermined: break
                case .restricted:
                    print("没有授权")
                    break
                case .denied:
                    print("没有授权")
                    break
                case .authorized:
                    DispatchQueue.main.async {
//                        self.imagePickerVC!.allowsEditing = true
                        self.imagePickerVC!.sourceType = UIImagePickerController.SourceType.photoLibrary
                        self.imagePickerVC!.mediaTypes = [kUTTypeImage as String]
                        self.present(self.imagePickerVC!, animated: true, completion: nil)
                    }
                    break
                default:
                    break
                }
            }
        }
        
        
    }
            
}


extension ZSKImageJigsawVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {

        }
        
        var image: UIImage?
        
        print(info)
        let type: String = info[UIImagePickerController.InfoKey.mediaType] as! String
        if type == "public.image" {
            if picker.allowsEditing {
                image = (info[UIImagePickerController.InfoKey.editedImage] as! UIImage)
            }else {
                image = (info[UIImagePickerController.InfoKey.originalImage] as! UIImage)
            }
        }
        
        if image != nil {
            self.images[choseIndex] = image!
            self.isCanEdit = false
            self.getStyleArray()
        }
        
//        let newSie = CGSize(width: 100, height: 100)
//        UIGraphicsBeginImageContext(newSie)
//        image!.draw(in: CGRect(x: 0, y: 0, width: newSie.width, height: newSie.height))
//        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
        
        
    }
}


extension UIView {

    func screenShot() -> UIImage? {
        
        guard frame.size.height > 0 && frame.size.width > 0 else {
        
            return nil
        }
        
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}

extension UIScrollView {

    func scrollViewShot() -> UIImage? {
        
        guard frame.size.height > 0 && frame.size.width > 0 else {
        
            return nil
        }
        let savedContentOffset = contentOffset
        let savedFrame = frame
        
        contentOffset = CGPoint.zero
        frame = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        contentOffset = savedContentOffset
        frame = savedFrame
        UIGraphicsEndImageContext()
        return image
    }
}
