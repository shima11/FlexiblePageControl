//
//  ViewController.swift
//  Demo
//
//  Created by 島仁誠 on 2017/04/04.
//  Copyright © 2017年 jinsei shima. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    let scrollSize: CGFloat = 300
    let numberOfPage = 10

    let pageControl = FlexiblePageControl(
        pageCount: 10,
        dotSize: 6,
        dotSpace: 4
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.frame = CGRect(x: 0, y: 0, width: scrollSize, height: scrollSize)
        scrollView.center = view.center
        scrollView.contentSize = CGSize(width: scrollSize*CGFloat(numberOfPage), height: scrollSize)
        scrollView.isPagingEnabled = true
        
        pageControl.center = CGPoint(x: scrollView.center.x, y: scrollView.frame.maxY + 16)
        
        for index in  0..<numberOfPage {
            let view = UIImageView(frame: CGRect(x: CGFloat(index)*scrollSize, y: 0, width: scrollSize, height: scrollSize))
            let imageNamed = NSString(format: "image%02d.jpg", index)
            view.image = UIImage(named: imageNamed as String)
            scrollView.addSubview(view)
        }
        
        view.addSubview(scrollView)
        view.addSubview(pageControl)
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.selectedPage = Int(scrollView.contentOffset.x/scrollSize)
    }
    
}
