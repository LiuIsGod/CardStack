//
//  ViewController.swift
//  CardStacking
//
//  Created by Mr.Huang on 2017/7/4.
//  Copyright © 2017年 Mr.Huang. All rights reserved.
//

import UIKit
import pop


class ViewController: BaseViewController,UICollectionViewDataSource,UICollectionViewDelegate,KZCardStackingDelegate{
    
    func cardStackingDeleteCard(at:IndexPath){
        self.dataAry.remove(at: at.row)
        self.collectionView.deleteItems(at: [at])
        if (dataAry.count > 1) {
            fuzzyImgView.image = UIImage.init(named: dataAry.first!)
        }
    }
    
    lazy var  dataAry:[String] = { () -> [String] in
        var a:[String] = []
        for i in 1 ..< 11{
            a.append("\(i)")
        }
        return a
    }()
    
    
    let collectionView:KZCardStackingCollectionView = { () -> KZCardStackingCollectionView in
        let layout = KZCardStackingLayout()
        layout.aspectRatio = 0.58
        layout.widthScale = 0.8
        let collectionView = KZCardStackingCollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UINib.init(nibName: "CardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "#cell")
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "#cell", for: indexPath) as! CardCollectionViewCell
        cell.cardImg.image = UIImage.init(named: dataAry[indexPath.row])
        cell.titleLabel.text = dataAry[indexPath.row]
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return dataAry.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dataAry.remove(at: indexPath.row)
        collectionView.deleteItems(at: [indexPath])
        if (dataAry.count > 1) {
            fuzzyImgView.image = UIImage.init(named: dataAry.first!)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collectionView.frame = view.bounds
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.cardDelegate = self
        view.addSubview(collectionView)
        fuzzyImgView.image = UIImage.init(named: dataAry.first!)
    }
    
    func panGestureRecognizerChanged(collectionView:UICollectionView,moveCell:UICollectionViewCell){
            let angle = ((moveCell.center.x) - collectionView.center.x)/collectionView.center.x
            rotationAnimation(moveCell, offset: Float(angle))
    }
    
    
    func rotationAnimation(_ view:UIView,offset:Float){
        let animation = POPBasicAnimation.init(propertyNamed: kPOPLayerRotation)
        animation?.toValue = offset
        animation?.duration = 0.00001
        view.layer.pop_add(animation, forKey: "rotation")
    }
    

}

