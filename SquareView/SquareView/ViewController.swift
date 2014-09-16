//
//  ViewController.swift
//  SquareView
//
//  Created by billsong on 14-9-15.
//  Copyright (c) 2014年 hongDing. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let screenWidth: CGFloat = UIScreen.mainScreen().bounds.size.width
    var mSquareView: SquareView? = nil
    @IBAction func cancel(sender: AnyObject) {
        mSquareView?.removeFromSuperview()
    }
    @IBAction func toTypeOne(sender: AnyObject) {
        squareViewInitWithType(SquareViewType.OnlyBigImage)
    }
    
    @IBAction func toTypeTwo(sender: AnyObject) {
         squareViewInitWithType(SquareViewType.MoreData)
    }
    
    @IBAction func toTypeThree(sender: AnyObject) {
         squareViewInitWithType(SquareViewType.OnlyOneData)
    }
    
    func squareViewInitWithType(mType: SquareViewType) {
        mSquareView = SquareView(frame: CGRectMake(0, 80, screenWidth, screenWidth), withSquareViewType: mType)
       // mSquareView?.mSquareViewType = mType
        view.addSubview(mSquareView!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // mSquareView.imagArr = [UIImage(named: "bg1.png"),UIImage(named: "bg2.png"),UIImage(named: "bg3.png"),UIImage(named: "bg4.png"),UIImage(named: "title1.png"),UIImage(named: "title2.png")]
    }

}

