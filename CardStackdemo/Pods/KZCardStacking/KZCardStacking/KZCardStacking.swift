
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

public class KZCardStackingCollectionView: UICollectionView {
    
    weak open var cardDelegate: KZCardStackingDelegate?
    
    private static var moveCell:UIView? = nil
    
    func panHandle(_ panGesture:UIPanGestureRecognizer){
        /// 当前cell总数
        let count:Int = numberOfItems(inSection: 0)
        guard count>0 else {return}
        if (KZCardStackingCollectionView.moveCell == nil) {
            let indexPath:IndexPath = IndexPath(row: 0, section: 0)
            let cell = cellForItem(at: indexPath)
            //获取手势点 判断是否在作用范围
            let xpoint = panGesture.location(in: self)
            guard (cell?.frame.contains(xpoint))! else {return}
            KZCardStackingCollectionView.moveCell = cell
            if let layout = collectionViewLayout as? KZCardStackingLayout {
                layout.moved = true
            }
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
                if let layout = collectionViewLayout as? KZCardStackingLayout {
                    layout.moved = false
                }
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

    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        let panG = UIPanGestureRecognizer.init(target:self , action: #selector(panHandle(_:)))
        addGestureRecognizer(panG)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

public class KZCardStackingLayout: UICollectionViewLayout {
    /// cell头部距离
    public var cardDrop = 0.0
    /// 各个cell之间的比例
    public  var scale = 0.8
    /// cell宽高比(默认1:1)
    public var aspectRatio = 1.0
    /// 显示的图片数目，默认比设置的多一张
    public var maxlevel = 3
    /// cell宽度和collectionView的比例
    public var widthScale = 0.5
    /// 顶端cell是否在移动
    var moved = false
    private  var attrsAry:[UICollectionViewLayoutAttributes] = []
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrsAry
    }
    
    override public func prepare() {
        super.prepare()
        self.attrsAry.removeAll()
        let count:Int = (self.collectionView?.numberOfItems(inSection: 0))!
        for index in 0 ..< count {
            let indexPath = IndexPath.init(item: index, section: 0)
            let attrs = layoutAttributesForItemAtIndexPath(indexPath: indexPath)
            attrsAry.append(attrs)
        }
    }
    
    func layoutAttributesForItemAtIndexPath(indexPath:IndexPath) -> UICollectionViewLayoutAttributes {
        let width = (self.collectionView?.frame.size.width)! * CGFloat(widthScale)
        let attrs = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
        var level = indexPath.row - (self.moved ? 1:0)
        if level > maxlevel {
            level = maxlevel
        }
        /// 设置cell层级关系
        attrs.zIndex = (self.collectionView?.numberOfItems(inSection: 0))! - indexPath.row
        let dump =  CGFloat(aspectRatio)*width*CGFloat(1 - pow(scale, Double(level))) + CGFloat(Double(level)*cardDrop)
        if  indexPath.row - (self.moved ? 1:0) > maxlevel{ //不在显示范围
            attrs.center = CGPoint.init(x: (self.collectionView?.center.x)!, y: (self.collectionView?.center.y)! - dump - (self.collectionView?.frame.size.height)!)
            attrs.bounds = .zero
        }else{
            attrs.center = CGPoint.init(x: (self.collectionView?.center.x)!, y: (self.collectionView?.center.y)! - dump)
            attrs.bounds = CGRect.init(x: 0, y: 0, width:width*CGFloat(pow(scale, Double(level))), height: CGFloat(aspectRatio)*width*CGFloat(pow(scale, Double(level))))
        }

        return attrs
    }
    
}
