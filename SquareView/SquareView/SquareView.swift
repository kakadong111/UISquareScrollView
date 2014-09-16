//
//  SquareView.swift
//  SquareView
//
//  Created by billsong on 14-9-15.
//  Copyright (c) 2014年 hongDing. All rights reserved.
//

import UIKit

enum SquareViewType : Int {
    case OnlyBigImage = 1//
    case OnlyOneData //
    case MoreData
}

class SquareView: UIView {
    var mSquareViewType: SquareViewType = SquareViewType.OnlyBigImage
    var bagImage: UIImage = UIImage(named: "default.png")
    var imagArr:NSArray = [UIImage(named: "bg1.png"),UIImage(named: "bg2.png"),UIImage(named: "bg3.png"),UIImage(named: "bg4.png"),UIImage(named: "title1.png"),UIImage(named: "title2.png")]

    var faceImagArr:NSArray = [UIImage(named: "bg1.png"),UIImage(named: "bg2.png"),UIImage(named: "bg3.png"),UIImage(named: "bg4.png"),UIImage(named: "title1.png"),UIImage(named: "title2.png")]
    
    init(frame:CGRect, withSquareViewType currentSquareViewType: SquareViewType) {
        super.init(frame: frame)
        self.mSquareViewType = currentSquareViewType
        subViewInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func subViewInit() {
        //1 建立scrollView
        switch mSquareViewType {
        case .OnlyBigImage:OnlyBigImageViewscrollInit()
        case .OnlyOneData:OnlyOneDataViewscrollInit()
        case .MoreData:moreDataViewsScrollInit()
        default:println("error")
        }
    }
    
    func OnlyBigImageViewscrollInit() {
        var squareScrollView: UIScrollView = generateScrollViewWithViewHeight(frame.size.height)
        //add subView to scrollView
        addBackGroundImageToScrollView(squareScrollView, withImageViewHeight: squareScrollView.frame.size.height)
    }
    
    func OnlyOneDataViewscrollInit() {
        var squareScrollView: UIScrollView = generateScrollViewWithViewHeight(frame.size.height * 0.8)
        addBackGroundImageToScrollView(squareScrollView, withImageViewHeight: frame.size.height * 0.8)
        addStaticLabel(squareScrollView, withLabelHeight: frame.size.height * 0.2)
        addStaticFaceImage(squareScrollView, withFaceImageRadius: 30)
    }
    
    func moreDataViewsScrollInit() {
        var squareScrollView: UIScrollView = generateScrollViewWithViewHeight(frame.size.height)
        addBackGroundImageToScrollView(squareScrollView, withImageViewHeight: frame.size.height * 0.8)
        addLabelAboutDetailInformation(squareScrollView, withLabelHeight: frame.size.height * 0.2)
        addFaceImage(squareScrollView, withFaceImageRadius: 30)
    }
    
    
    //MARK: - subView
    //scrollView
    func generateScrollViewWithViewHeight(scrollViewHeight: CGFloat) ->UIScrollView {
        var squareScrollView: UIScrollView = UIScrollView(frame: CGRectMake(CGPointZero.x, CGPointZero.y, frame.size.width, scrollViewHeight))
        squareScrollView.backgroundColor = UIColor.grayColor()
        squareScrollView.pagingEnabled = true
        addSubview(squareScrollView)
        squareScrollView.contentSize = CGSizeMake(squareScrollView.frame.width *  CGFloat(imagArr.count), squareScrollView.frame.height)
        squareScrollView.showsHorizontalScrollIndicator = false
        return squareScrollView
    }
    
    // backGround Image
    func addBackGroundImageToScrollView(squareScrollView: UIScrollView, withImageViewHeight imageViewHeight: CGFloat) {
        for var i = 0; i < imagArr.count; i++ {
            var squareRect: CGRect = CGRectMake(CGPointZero.x + CGFloat(i) * squareScrollView.frame.width, CGPointZero.y, squareScrollView.frame.width, imageViewHeight)
            //大图
            var imageV: UIImageView = UIImageView(frame:squareRect)
            imageV.image = imagArr[i] as? UIImage
            squareScrollView.addSubview(imageV)
        }
    }
    
    //label
    func addStaticLabel(squareScrollView: UIScrollView, withLabelHeight labelHeight: CGFloat) {
        let labelRect = CGRectMake(CGPointZero.x, frame.size.height - labelHeight, squareScrollView.frame.size.width,labelHeight)
        var label: UILabel = UILabel(frame: labelRect)
        label.textColor = UIColor.blackColor()
        
        label.text = "currentImageTag"
        
        addSubview(label)
    }
    
    func addLabelAboutDetailInformation(squareScrollView: UIScrollView, withLabelHeight labelHeight: CGFloat) {
        // label
        for var i = 0; i < imagArr.count; i++ {
            let labelRect = CGRectMake(CGPointZero.x + CGFloat(i) * squareScrollView.frame.width, frame.size.height - labelHeight, squareScrollView.frame.size.width,labelHeight )
            var label: UILabel = UILabel(frame: labelRect)
            label.textColor = UIColor.blackColor()
            
            label.text = "currentImageTag--\(i)"
            
            squareScrollView.addSubview(label)
        }
    }
    
    //face Image
    func addStaticFaceImage(squareScrollView: UIScrollView, withFaceImageRadius imageRadius: CGFloat) {
        let faceImageViewRect: CGRect = CGRectMake(frame.size.width - imageRadius * 3, frame.size.height * 0.8 - imageRadius, imageRadius * 2, imageRadius * 2)
        var faceImageV: UIImageView = UIImageView(frame: faceImageViewRect)
        //圆化 + 白边
        faceImageV.layer.cornerRadius = imageRadius
        faceImageV.layer.masksToBounds = true
        faceImageV.layer.borderWidth = 1
        faceImageV.layer.borderColor = UIColor.whiteColor().CGColor
        faceImageV.image = faceImagArr[0] as? UIImage
        addSubview(faceImageV)
    }
    
    func addFaceImage(squareScrollView: UIScrollView, withFaceImageRadius imageRadius: CGFloat) {
        //头像imageV
        for var i = 0; i < imagArr.count; i++ {
        let faceImageViewRect: CGRect = CGRectMake(frame.size.width - imageRadius * 3 + CGFloat(i) * squareScrollView.frame.width, frame.size.height * 0.8 - imageRadius, imageRadius * 2, imageRadius * 2)
        var faceImageV: UIImageView = UIImageView(frame: faceImageViewRect)
        //圆化 + 白边
        faceImageV.layer.cornerRadius = imageRadius
        faceImageV.layer.masksToBounds = true
        faceImageV.layer.borderWidth = 1
        faceImageV.layer.borderColor = UIColor.whiteColor().CGColor
        faceImageV.image = faceImagArr[i] as? UIImage
        squareScrollView.addSubview(faceImageV)
        }
    }

}
