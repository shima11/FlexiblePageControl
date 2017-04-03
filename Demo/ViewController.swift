//
//  ViewController.swift
//  Demo
//
//  Created by 島仁誠 on 2017/04/04.
//  Copyright © 2017年 jinsei shima. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    let pageControl = PageControlView(
        dotRadius: 6,
        pageCount: 10,
        dotSpace: 4,
        displayCount: 5,
        selectedColor: .orange,
        unSelectedColor: .lightGray
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let numberOfPages = 10
        
        let size = 300
        
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.lightGray
        scrollView.frame = CGRect(x: 0, y: 0, width: size, height: size)
        scrollView.center = view.center
        scrollView.contentSize = CGSize(width: size*numberOfPages, height: size)
        scrollView.isPagingEnabled = true
        
        pageControl.center = CGPoint(x: scrollView.center.x, y: scrollView.frame.maxY + 16)
        
        view.addSubview(scrollView)
        view.addSubview(pageControl)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.selectedPage = Int(scrollView.contentOffset.x/300)
    }
}

