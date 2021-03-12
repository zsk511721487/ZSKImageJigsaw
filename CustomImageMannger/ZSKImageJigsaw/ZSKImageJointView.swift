//
//  ZSKImageJointView.swift
//  CustomImageMannger
//
//  Created by 张少康 on 2021/2/25.
//

import UIKit

 
class ZSKImageJointView: UIView {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let cv = UICollectionView( frame: CGRect(x: 0, y: 0, width: itemWidth, height: self.bounds.height),collectionViewLayout: layout)
        cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cv.backgroundColor = .zsk_backgroundColor
        cv.showsVerticalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    var collectionWidthScals: CGFloat = 1 {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var itemWidth: CGFloat {
        return self.bounds.width * collectionWidthScals
    }
    
    fileprivate var collectionViewIdentifers: [String] = [
        "ZSKJointCollectionViewCell",
        "ZSKJointCollectionViewCell1",
        "ZSKJointCollectionViewCell2",
        "ZSKJointCollectionViewCell3",
        "ZSKJointCollectionViewCell4",
        "ZSKJointCollectionViewCell5",
        "ZSKJointCollectionViewCell6",
        "ZSKJointCollectionViewCell7",
        "ZSKJointCollectionViewCell7"
    ]
    
    fileprivate var images: [UIImage] = []
    
    fileprivate var currentIndex: Int = -1
    
    var imageExchange: (( _ moveIndex: Int ,_ toIndex: Int) ->Void)?
        
    var selctImage: ((_ isEdit: Bool ,_ index: Int) -> Void)?
    
    func cleanAllStatus() {
        currentIndex = -1
        collectionView.reloadData()
    }

    @objc fileprivate func long(long: UILongPressGestureRecognizer) {
        switch long.state {
        case .began:
            let selectCellIndex = collectionView.indexPathForItem(at: long.location(in: collectionView))
            collectionView.beginInteractiveMovementForItem(at: selectCellIndex!)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(long.location(in: collectionView))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    @objc fileprivate func tap(tap:UITapGestureRecognizer) {
        let point = tap.location(in: collectionView)
        let indexPath = collectionView.indexPathForItem(at: point)
        if self.currentIndex == indexPath?.row {
            self.currentIndex = -1
            changeSelectStatus(isEdit: false)
        }else {
            self.currentIndex = indexPath?.row ?? -1
            changeSelectStatus(isEdit: true)
        }
        changeSelectStatus(isEdit: self.currentIndex != -1)
        collectionView.reloadItems(at: [indexPath!])
    }
    
    fileprivate func changeSelectStatus(isEdit: Bool) {
        if selctImage != nil {
            selctImage!(isEdit,self.currentIndex)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .zsk_backgroundColor
        let long = UILongPressGestureRecognizer(target: self, action: #selector(long(long:)))
        self.addSubview(collectionView)
        collectionView.addGestureRecognizer(long)
        for item in collectionViewIdentifers {
            collectionView.register(ZSKJointCollectionViewCell.self, forCellWithReuseIdentifier: item)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ZSKImageJointView {
    convenience init(frame: CGRect,images: [UIImage]) {
        self.init(frame:frame)
        self.images = images
        self.collectionView.reloadData()
    }
}

extension ZSKImageJointView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.currentIndex == indexPath.row {
            self.currentIndex = -1
            changeSelectStatus(isEdit: false)
        }else {
            self.currentIndex = indexPath.row
            changeSelectStatus(isEdit: true)
        }
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewIdentifers[indexPath.row], for: indexPath) as! ZSKJointCollectionViewCell
        cell.updateSubviews(isSelect: self.currentIndex == indexPath.row, image: images[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let currentImage = images[sourceIndexPath.row]
        images.remove(at: sourceIndexPath.row)
        images.insert(currentImage, at: destinationIndexPath.row)
        
        let style = collectionViewIdentifers[sourceIndexPath.row]
        collectionViewIdentifers.remove(at: sourceIndexPath.row)
        collectionViewIdentifers.insert(style, at: destinationIndexPath.row)

        self.currentIndex = -1
        changeSelectStatus(isEdit: false)
        if imageExchange != nil {
            imageExchange!(sourceIndexPath.row,destinationIndexPath.row)
        }
        self.collectionView.reloadData()
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let image = images[indexPath.row]
        let heightScale = image.size.height/image.size.width
        return CGSize(width: itemWidth, height: itemWidth * heightScale)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
