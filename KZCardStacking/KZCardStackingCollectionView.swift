
//
//  KZCardStackingCollectionView.swift
//  CardStacking
//
//  Created by Mr.Huang on 2017/7/4.
//  Copyright © 2017年 Mr.Huang. All rights reserved.
//

import UIKit

@objc public protocol KZCardStackingDelegate:NSObjectProtocol{
    /// 卡片需要从视图中删除，外界需要删除data中的数据并删掉对应cell
    ///
    /// - Parameter at: IndexPath
    func cardStackingDeleteCard(at:IndexPath)
    
    /// 卡片移动过中可以添加动画什么的
    ///
    /// - Parameters:
    ///   - collectionView: collectionView
    ///   - moveCell: 移动中的cell
    @objc optional func panGestureRecognizerChanged(collectionView:UICollectionView,moveCell:UICollectionViewCell)
}

class KZCardStackingCollectionView: UICollectionView {
    
    weak open var cardDelegate: KZCardStackingDelegate?
    
    private static var moveCell:UIView? = nil
    
    func panHandle(_ panGesture:UIPanGestureRecognizer){
        /// 当前cell总数
        let count:Int = (numberOfItems(inSection: 0))
        if (!(count > 0)) {return}
        if (KZCardStackingCollectionView.moveCell == nil) {
            let indexPath:IndexPath = IndexPath(row: 0, section: 0)
            let cell = cellForItem(at: indexPath)
            //获取手势点 判断是否在作用范围
            let xpoint = panGesture.location(in: self)
            if !((cell?.frame.contains(xpoint))!) {return}
            KZCardStackingCollectionView.moveCell = cell
            let layout = collectionViewLayout as! KZCardStackingLayout
            layout.moved = true
            if count > 1 {
                reloadItems(at: [IndexPath.init(row: 1, section: 0)])
            }
        }
        let point = panGesture.translation(in: self)
        panGesture.setTranslation(.zero, in: self)
        KZCardStackingCollectionView.moveCell?.center = CGPoint.init(x: KZCardStackingCollectionView.moveCell!.center.x + point.x, y: KZCardStackingCollectionView.moveCell!.center.y + point.y)
        switch panGesture.state {
        case .changed:
            cardDelegate?.panGestureRecognizerChanged?(collectionView: self, moveCell: KZCardStackingCollectionView.moveCell as! UICollectionViewCell)
            break
        default:
            let indexPath = IndexPath.init(row: 0, section: 0)
            if count > 1 {
                let cell = cellForItem(at: IndexPath.init(row: 1, section: 0))
                let layout = collectionViewLayout as! KZCardStackingLayout
                layout.moved = false
                if  Double((KZCardStackingCollectionView.moveCell?.center.x)!) > Double((cell?.frame.minX)!) && Double((KZCardStackingCollectionView.moveCell?.center.x)!) < Double((cell?.frame.maxX)!){
                    reloadItems(at: [indexPath])
                }else{
                    //删除视图
                    cardDelegate?.cardStackingDeleteCard(at:indexPath)
                }
            }else{ //只有一张的时候直接删除
                //删除视图
                cardDelegate?.cardStackingDeleteCard(at:indexPath)
            }
            KZCardStackingCollectionView.moveCell = nil
            break
        }
    }

    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        let panG = UIPanGestureRecognizer.init(target:self , action: #selector(panHandle(_:)))
        addGestureRecognizer(panG)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    
    
    
    

}
