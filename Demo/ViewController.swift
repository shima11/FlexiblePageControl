//
//  ViewController.swift
//  Demo
//
//  Created by 島仁誠 on 2017/04/04.
//  Copyright © 2017年 jinsei shima. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    let pageControl_scroll = PageControlView_ScrollView(
        pageCount: 10,
        dotSize: 6,
        dotSpace: 4
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let numberOfPages = 10
        
        let scrollSize = 300
        
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.lightGray
        scrollView.frame = CGRect(x: 0, y: 0, width: scrollSize, height: scrollSize)
        scrollView.center = view.center
        scrollView.contentSize = CGSize(width: scrollSize*numberOfPages, height: scrollSize)
        scrollView.isPagingEnabled = true
        
        pageControl_scroll.center = CGPoint(x: scrollView.center.x, y: scrollView.frame.maxY + 16)
        
        view.addSubview(scrollView)
        view.addSubview(pageControl_scroll)
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl_scroll.selectedPage = Int(scrollView.contentOffset.x/300)
    }
    
}
