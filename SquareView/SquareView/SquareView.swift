
//  Created by billsong on 14-9-15.
//  Copyright (c) 2014年 hongDing. All rights reserved.

//1 自动滑动时 用户点击 怎样处理
//2 用户点击后,什么时候又开始自动滑动
//swift 的setter和getter?????

import UIKit

enum SquareViewType : Int {
    case OnlyBigImage = 1//
    case OnlyOneData //
    case MoreData
}

class SquareView: UIView, UIScrollViewDelegate {
    
    var mSquareViewType: SquareViewType = SquareViewType.OnlyBigImage
    //var bgImage: UIImage = UIImage(named: "default.png")
    var imagArr: NSMutableArray = [UIImage(named: "bg1"),UIImage(named: "bg2"),UIImage(named: "bg3"),UIImage(named: "bg4")]
    var faceImagArr: NSMutableArray = [UIImage(named: "bg1"),UIImage(named: "bg2"),UIImage(named: "bg3"),UIImage(named: "bg4")]
    
    var isCycle: Bool = false
        //{
//        get {
//            return self.isCycle
//        }
//        set(_isCycle) {
//            self.isCycle = _isCycle
//            if self.isCycle {
//                //加data数据
//                addCycleViewWithData(imagArr)
//                addCycleViewWithData(faceImagArr)
//            }
//        }
//    }
//    }
    var isAutoRun: Bool = false
    var isOnAutoRun: Bool = false
    
    var timer: NSTimer?
    var currentScrollView:UIScrollView!
    // MARK: - life cycle
    
    init(frame:CGRect, withSquareViewType currentSquareViewType: SquareViewType) {
        super.init(frame: frame)
        isCycle = true
        isAutoRun = true
        if isCycle {
            //加data数据
            addCycleViewWithData(imagArr)
            addCycleViewWithData(faceImagArr)
        }
        timerInit()
        self.mSquareViewType = currentSquareViewType
        subViewInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIScrollView Delegate 
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        //只有在 currentScrollView.setContentOffset 调用后才被调用
        println("scrollViewDidEndScrollingAnimation")
        isOnAutoRun = false
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        println("scrollViewWillBeginDragging")
        if isAutoRun {
            if isOnAutoRun {
                println("isOnAutoRun")
                scrollView.contentOffset.x = scrollView.contentOffset.x - scrollView.frame.width
            }
            timerInvalidate()
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        println("scrollViewDidEndDecelerating")
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //println("contentOffSet.x == \(scrollView.contentOffset.x)   \(scrollView.frame.width * CGFloat(imagArr.count - 1))")
        if isCycle {
            if scrollView.contentOffset.x == 0.0 {
                scrollView.contentOffset.x = scrollView.frame.width * CGFloat(imagArr.count - 1 - 1)
            }
             if scrollView.contentOffset.x == scrollView.frame.width * CGFloat(imagArr.count - 1) {
                scrollView.contentOffset.x = scrollView.frame.width
            }
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        println("scrollViewDidEndDragging")
        timerInit()
    }
    
    
    // MARK: - custom method
    
    func timerInvalidate() {
        timer?.invalidate()
        timer = nil
    }
    
    func timerInit() {
        if isAutoRun {
            timer = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: "autoSetCurrentContentOffset", userInfo: nil, repeats: true)
        }

    }
    
    func autoSetCurrentContentOffset() {
        println("autoSetCurrentContentOffset")
        isOnAutoRun = true
        var currentContentOffsetX = currentScrollView.contentOffset.x + currentScrollView.frame.width
        currentScrollView.setContentOffset(CGPoint(x: currentContentOffsetX, y: currentScrollView.contentOffset.y), animated: true)
    }
    
    func addCycleViewWithData(dataArr: NSMutableArray) {
        var firstObj = dataArr[0] as UIImage
        var lastObj = dataArr[dataArr.count - 1] as UIImage
        dataArr.insertObject(firstObj, atIndex: dataArr.count) //不要搞错了
        dataArr.insertObject(lastObj, atIndex: 0)
    }
    
    func subViewInit() {
        switch mSquareViewType {
        case .OnlyBigImage:scrollInit(1.0, withRateOfImageViewInView: 1.0)
        case .OnlyOneData:OnlyOneDataViewscrollInit()
        case .MoreData:moreDataViewsScrollInit()
        default:println("error")
        }
    }
    
    func scrollInit(rateOfScrollviewInView: CGFloat, withRateOfImageViewInView rateOfImageViewInView: CGFloat) ->UIScrollView {
        var squareScrollView: UIScrollView = generateScrollViewWithViewHeight(frame.size.height * rateOfScrollviewInView)
        if isAutoRun {
            currentScrollView = squareScrollView
        }
        //add subView to scrollView
        addBackGroundImageToScrollView(squareScrollView, withImageViewHeight: squareScrollView.frame.size.height * rateOfImageViewInView)
        return squareScrollView
    }
    
    func OnlyOneDataViewscrollInit() {
        var squareScrollView = scrollInit(0.8, withRateOfImageViewInView: 0.8)
        addStaticLabel(squareScrollView, withLabelHeight: frame.size.height * 0.2)
        addStaticFaceImage(squareScrollView, withFaceImageRadius: 30)
    }
    
    func moreDataViewsScrollInit() {
        var squareScrollView = scrollInit(1.0, withRateOfImageViewInView: 0.8)
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
        
        if isCycle {
            squareScrollView.delegate = self
            squareScrollView.contentOffset.x = squareScrollView.frame.width
        }
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
    func addLabel(superView: UIView, withLabelRect labelRect: CGRect, withLabelText text: NSString) {
        var label: UILabel = UILabel(frame: labelRect)
        label.textColor = UIColor.blackColor()
        label.text = text
        superView.addSubview(label)
    }
    
    func addStaticLabel(squareScrollView: UIScrollView, withLabelHeight labelHeight: CGFloat) {
        let labelRect = CGRectMake(CGPointZero.x, frame.size.height - labelHeight, squareScrollView.frame.size.width,labelHeight)
        addLabel(self, withLabelRect: labelRect, withLabelText: "currentImageTag")
    }
    
    func addLabelAboutDetailInformation(squareScrollView: UIScrollView, withLabelHeight labelHeight: CGFloat) {
        // label
        for var i = 0; i < imagArr.count; i++ {
            let labelRect = CGRectMake(CGPointZero.x + CGFloat(i) * squareScrollView.frame.width, frame.size.height - labelHeight, squareScrollView.frame.size.width,labelHeight )
           
            if isCycle {
                //改变 i值
            }
            addLabel(squareScrollView, withLabelRect: labelRect, withLabelText: "currentImageTag--\(i)")
        }
    }
    
    //face Image
    func addFaceView(superView: UIView, withFaceImageViewRect faceImageViewRect: CGRect, withFaceImage faceImage: UIImage, withImageRadius imageRadius: CGFloat) {
        var faceImageV: UIImageView = UIImageView(frame: faceImageViewRect)
        //圆化 + 白边
        faceImageV.layer.cornerRadius = imageRadius
        faceImageV.layer.masksToBounds = true
        faceImageV.layer.borderWidth = 1
        faceImageV.layer.borderColor = UIColor.whiteColor().CGColor
        faceImageV.image = faceImage
        superView.addSubview(faceImageV)
    }
    
    func addStaticFaceImage(squareScrollView: UIScrollView, withFaceImageRadius imageRadius: CGFloat) {
        let faceImageViewRect: CGRect = CGRectMake(frame.size.width - imageRadius * 3, frame.size.height * 0.8 - imageRadius, imageRadius * 2, imageRadius * 2)
        addFaceView(self, withFaceImageViewRect: faceImageViewRect, withFaceImage: faceImagArr[0] as UIImage, withImageRadius: imageRadius)
    }
    
    func addFaceImage(squareScrollView: UIScrollView, withFaceImageRadius imageRadius: CGFloat) {
        //头像imageV
        for var i = 0; i < imagArr.count; i++ {
        let faceImageViewRect: CGRect = CGRectMake(frame.size.width - imageRadius * 3 + CGFloat(i) * squareScrollView.frame.width, frame.size.height * 0.8 - imageRadius, imageRadius * 2, imageRadius * 2)
        addFaceView(squareScrollView, withFaceImageViewRect: faceImageViewRect, withFaceImage: faceImagArr[i] as UIImage, withImageRadius: imageRadius)
        }
    }

}
