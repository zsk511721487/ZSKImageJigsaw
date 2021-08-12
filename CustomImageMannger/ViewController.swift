//
//  ViewController.swift
//  CustomImageMannger
//
//  Created by 张少康 on 2021/2/22.
//

import UIKit
//import ZSKImageJigsaw

class ViewController: UIViewController {

    @IBOutlet weak var imageVIew: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func btnAction(_ sender: Any) {
        let showVC = ZSKImageJigsawVC()
        showVC.modalPresentationStyle = .fullScreen
        showVC.images = [UIImage(named: "gougou1")!,UIImage(named: "maomao1")!]
        showVC.delegate  = self
        self.present(showVC, animated: true, completion: nil)
    }
    
    
    
}



extension ViewController:ZSKImageJigsawDelegate {
    func imageJiasawCanDelete(imageJigsaw: UIViewController, index: Int) -> Bool {
        return true
    }
    
    func imagejiasawNotAllowDelete(imageJigsaw: UIViewController) {
        print("不能删除了")
    }
    
    func imageJigsaw(imageJigsaw: UIViewController, image: UIImage) {
        self.imageVIew.image = image
    }
}
