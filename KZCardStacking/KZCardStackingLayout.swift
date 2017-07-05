//
//  KZCardStackingLayout.swift
//  CardStacking
//
//  Created by Mr.Huang on 2017/7/4.
//  Copyright © 2017年 Mr.Huang. All rights reserved.
//

import UIKit

class KZCardStackingLayout: UICollectionViewLayout {
    /// cell头部冒出距离
    var cardDrop = 0.0
    ///  各个cell之间的比例
    var scale = 0.8
    /// cell宽高比(默认1:1)
    var aspectRatio = 1.0
    /// 显示的图片数目，默认比设置的多一张
    var maxlevel = 2
    /// cell宽度和collectionView的比例
    var widthScale = 0.5
    /// 顶端cell是否在移动
    var moved = false
    private  var attrsAry:[UICollectionViewLayoutAttributes] = []
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrsAry
    }
    
    override func prepare() {
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
        attrs.center = CGPoint.init(x: (self.collectionView?.center.x)!, y: (self.collectionView?.center.y)! - dump)
        attrs.bounds = CGRect.init(x: 0, y: 0, width:width*CGFloat(pow(scale, Double(level))), height: CGFloat(aspectRatio)*width*CGFloat(pow(scale, Double(level))))
        return attrs
    }

}
