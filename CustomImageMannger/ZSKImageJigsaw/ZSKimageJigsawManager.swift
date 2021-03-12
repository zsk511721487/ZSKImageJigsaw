//
//  ZSKimageJigsawManager.swift
//  CustomImageMannger
//
//  Created by 张少康 on 2021/2/24.
//

import Foundation
import UIKit

class ZSKimageJigsawStyleModel: Codable {
    var normal: String
    var select: String
    var viewHeight: CGFloat
    var viewWidth: CGFloat
    var weight: Int
    var itemsFrames: [ZSKimageJigsawStyleItemsModel]
}

class ZSKimageJigsawStyleItemsModel: Codable {
    var x: CGFloat
    var y: CGFloat
    var width: CGFloat
    var height: CGFloat
}

class ZSKimageJigsawManager {
    public static func getZSKImageJisawData(key: String) -> [ZSKimageJigsawStyleModel] {
        let current = Bundle(for: ZSKImageJigsawVC.self)
        let nowUrl = current.url(forResource: "ZSKImageJiasaw", withExtension: "bundle")
        let bundle = Bundle(url: nowUrl!)
        if let currentBundle = bundle {
            let jsonPath = "\(currentBundle.resourcePath!)/zskImageJigsawStyle.json"
            do{
                let  data = try Data(contentsOf: URL(fileURLWithPath: jsonPath))
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
                let jiasawData = try JSONSerialization.data(withJSONObject: json[key] as Any, options: .fragmentsAllowed)
                let dataArray = try JSONDecoder().decode([ZSKimageJigsawStyleModel].self, from: jiasawData)
                return dataArray
            }catch {
                print("get zskImageJigsawStyle json error")
                return []
            }
        }else {
            return []
        }
    }
    
    public static func getZSKImage(from key: String) -> UIImage?{
        var imageName: String = ""
        if key.contains(".png") || key.contains(".jpg"){
            imageName = key
        }else {
            imageName = key + ".png"
        }
        
        let current = Bundle(for: ZSKImageJigsawVC.self)
        let nowUrl = current.url(forResource: "ZSKImageJiasaw", withExtension: "bundle")
        let bundle = Bundle(url: nowUrl!)
        if let currentBundle = bundle {
            let imagePath = "\(currentBundle.resourcePath!)/\(imageName)"
            return UIImage.init(contentsOfFile: imagePath)
        }else {
            return nil
        }
    }
    
    public static func getRealScaleSize(originalSize: CGFloat,currentScale: CGFloat) -> CGFloat {
        
        let multiplyScale =  Int(currentScale * 10)
        
        let threeReal = multiplyScale % 3
        
        if threeReal == 0 {
            let multiple = multiplyScale/3
            return originalSize / 3 * CGFloat(multiple)
        }
        
        return originalSize * currentScale
    }
    
}



extension UIColor {
    static func zsk_currentColor(_ light: UIColor, _ dark: UIColor) ->UIColor {
        if #available(iOS 13.0, *) {
            if UIUserInterfaceStyle.unspecified == .dark {
                return dark
            }else {
                return light
            }
        }else {
            return light
        }
    }
    
    static var zsk_groupedBackgroundColor: UIColor {
        if #available(iOS 13.0, *) {
            return .tertiarySystemBackground
        }else {
            return .white
        }
    }
    
    static var zsk_backgroundColor: UIColor {
        if #available(iOS 13.0, *) {
            return .secondarySystemBackground
        }else {
            return .white
        }
    }
    
    static var zsk_titleColr: UIColor {
        if #available(iOS 13.0, *) {
            return .label
        }else {
            return .black
        }
    }
    
    static var zsk_secondaryTitleColr: UIColor {
        if #available(iOS 13.0, *) {
            return .secondaryLabel
        }else {
            return UIColor(red: 102/255.0, green: 102/255.0, blue: 102/255.0, alpha: 1.0)
        }
    }
    
    static var zsk_tertiaryTitleColr: UIColor {
        if #available(iOS 13.0, *) {
            return .tertiaryLabel
        }else {
            return UIColor(red: 102/255.0, green: 102/255.0, blue: 102/255.0, alpha: 1.0)
        }
    }
}
