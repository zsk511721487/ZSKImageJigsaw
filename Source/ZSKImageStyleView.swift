//
//  ZSKImageStyleView.swift
//  CustomImageMannger
//
//  Created by 张少康 on 2021/2/24.
//

import UIKit

class ZSKImageStyleView: UIView {

    lazy var borderButton: UIButton = {
        let btn = UIButton(frame: CGRect(x: 15, y: 0, width: 40, height: 45))
        btn.setImage(ZSKimageJigsawManager.getZSKImage(from: "zsk_no_border_icon"), for: .normal)
        btn.showsTouchWhenHighlighted = false
        return btn
    }()
    
    lazy var layoutButton: UIButton = {
        let btn = UIButton(frame: CGRect(x: zskjigsaw_screen_width/3/2 , y: 15, width: zskjigsaw_screen_width/3, height: 20))
        btn.setTitle("布局", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 15)
        btn.setTitleColor(.black, for: .normal)
        btn.showsTouchWhenHighlighted = false
        btn.addTarget(self, action: #selector(layoutButtonAction(sender:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var jointButton: UIButton = {
        let btn = UIButton(frame: CGRect(x: zskjigsaw_screen_width/3 + zskjigsaw_screen_width/3/2, y: 15, width: zskjigsaw_screen_width/3, height: 20))
        btn.setTitle("拼接", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 15)
        btn.setTitleColor(.black, for: .normal)
        btn.showsTouchWhenHighlighted = false
        btn.addTarget(self, action: #selector(jointButtonAction(sender:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 55, height: 45)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect(x: 15, y: self.bounds.height - 55 - zskjigsaw_bottom_safe_height, width: zskjigsaw_screen_width - 59 - 15, height: 45), collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.showsHorizontalScrollIndicator = false
        cv.register(ZSKImageStyleCollectionViewCell.self, forCellWithReuseIdentifier: "ZSKImageStyleCollectionViewCell")
        
        return cv
    }()
    
    lazy var lineView: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(red: 5/255.0, green: 129/255.0, blue: 206/255.0, alpha: 1)
        return line
    }()
    
    lazy var jointView: UIView = {
        let view = UIView(frame: CGRect(x: 15, y: self.bounds.height - 55 - zskjigsaw_bottom_safe_height, width: zskjigsaw_screen_width - 59 - 15, height: 45))
        view.backgroundColor = .white
        view.isHidden = true
        view.addSubview(self.jointImageView)
        return view
    }()
    
    lazy var jointImageView:UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 15, y: 0, width: 40, height: 55))
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        return imageView
    }()
    
    fileprivate var items: [ZSKimageJigsawStyleModel] = []
    
    fileprivate var currentIndex: Int = 0
    
    fileprivate var isJoint: Bool = false
    
    var selectIndex: ((_ selectIndex: Int) -> Void)?
    
    var selectIsJoint: ((_ isJoint: Bool) -> Void)?
    
    func updateSubViews(items: [ZSKimageJigsawStyleModel], currentIndex: Int,jointImage: UIImage,isJoint: Bool) {
        self.items = items
        self.currentIndex = currentIndex
        self.collectionView.reloadData()
        self.jointImageView.image = jointImage
        self.isJoint = isJoint
        self.updateLineViewCenter()
    }
    
    fileprivate func updateLineViewCenter() {
        var center = lineView.center
        center.x = isJoint ? jointButton.center.x : layoutButton.center.x
        self.lineView.center = center
        self.jointView.isHidden = !isJoint
    }
    
    @objc func layoutButtonAction(sender:UIButton) {
        debugPrint("布局")
        isJoint = false
        self.updateLineCenter(sender: sender)
        updateContentShowView()
    }
    
    @objc func jointButtonAction(sender:UIButton) {
        debugPrint("拼接")
        isJoint = true
        self.updateLineCenter(sender: sender)
        updateContentShowView()
    }
    
    fileprivate func updateLineCenter(sender:UIButton) {
        var center = lineView.center
        center.x = sender.center.x
        UIView.animate(withDuration: 0.25) {
            self.lineView.center = center
        }
    }
    
    fileprivate func updateContentShowView() {
        self.jointView.isHidden = !isJoint
        if self.selectIsJoint != nil {
            self.selectIsJoint!(isJoint)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(jointButton)
        self.addSubview(layoutButton)
        self.addSubview(collectionView)
        
        lineView.center = CGPoint(x: layoutButton.center.x, y: layoutButton.center.y + 25)
        lineView.bounds = CGRect(x: 0, y: 0, width: 33, height: 1.5)
        self.addSubview(lineView)
        self.addSubview(jointView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension ZSKImageStyleView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ZSKImageStyleCollectionViewCell", for: indexPath) as! ZSKImageStyleCollectionViewCell
        cell.updateCellData(data: items[indexPath.row], isSelect: indexPath.row == self.currentIndex)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if currentIndex == indexPath.row {
            return
        }
        currentIndex = indexPath.row
        collectionView.reloadData()
        if selectIndex != nil {
            selectIndex!(indexPath.row)
        }
    }
}
