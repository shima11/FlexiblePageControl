//
//  ViewController.swift
//  Demo
//
//  Created by Jinsei Shima on 2017/04/04.
//  Copyright © 2017年 jinsei shima. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    let scrollSize: CGFloat = 300
    let numberOfPage: Int = 100

    let pageControl = FlexiblePageControl()
    let scrollView = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        scrollView.frame = CGRect(x: 0, y: 0, width: scrollSize, height: scrollSize)
        scrollView.center = view.center
        scrollView.contentSize = CGSize(width: scrollSize * CGFloat(numberOfPage), height: scrollSize)
        scrollView.isPagingEnabled = true
        
        pageControl.center = CGPoint(x: scrollView.center.x, y: scrollView.frame.maxY + 16)
        pageControl.numberOfPages = numberOfPage

        for index in  0..<numberOfPage {
            let view = UIImageView(frame: CGRect(x: CGFloat(index) * scrollSize, y: 0, width: scrollSize, height: scrollSize))
            let _index = index % 10
            let imageNamed = NSString(format: "image%02d.jpg", _index)
            view.image = UIImage(named: imageNamed as String)
            scrollView.addSubview(view)
        }

        view.addSubview(scrollView)
        view.addSubview(pageControl)

        changePage(index: 4)
        changePage(index: 0)
        changePage(index: 5)

        #warning("index=4までは動作しているっぽいが、５以上を設定すると挙動があやしい")

    }

    func changePage(index: Int) {
        pageControl.setCurrentPage(at: index)
        scrollView.setContentOffset(.init(x: CGFloat(index) * scrollSize, y: 0), animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        pageControl.setProgress(contentOffsetX: scrollView.contentOffset.x, pageWidth: scrollView.bounds.width)
    }
}
