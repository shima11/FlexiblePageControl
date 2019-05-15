//
//  ViewController.swift
//  Demo
//
//  Created by 島仁誠 on 2017/04/04.
//  Copyright © 2017年 jinsei shima. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    let pageControl1 = FlexiblePageControl()
    @IBOutlet weak var pageControl2: FlexiblePageControl!

    let scrollView = UIScrollView()
    let scrollSize: CGFloat = 300

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        scrollView.frame = CGRect(x: 0, y: 0, width: scrollSize, height: scrollSize)
        scrollView.center = view.center
        scrollView.isPagingEnabled = true

        pageControl1.center = CGPoint(x: scrollView.center.x, y: scrollView.frame.maxY + 16)

        view.addSubview(scrollView)
        view.addSubview(pageControl1)

        setContent(numberOfPages: 100)
        
        // debug
//        let setPage = { [weak self] (page: Int) -> Void in
//
//            self?.pageControl1.setCurrentPage(at: page)
//            scrollView.setContentOffset(CGPoint(x: scrollView.bounds.width * CGFloat(page), y: scrollView.contentOffset.y), animated: false)
//        }
//        // not work yet
//        [1,9,12].forEach { setPage($0) }

    }
    
    func setContent(numberOfPages: Int) {
        
        scrollView.subviews.forEach { $0.removeFromSuperview() }
        
        scrollView.contentSize = CGSize(width: scrollSize * CGFloat(numberOfPages), height: scrollSize)
        pageControl1.numberOfPages = numberOfPages
        pageControl2.numberOfPages = numberOfPages
        
        for index in  0..<numberOfPages {
            
            let view = UIImageView(
                frame: .init(
                    x: CGFloat(index) * scrollSize,
                    y: 0,
                    width: scrollSize,
                    height: scrollSize
                )
            )
            let imageNamed = NSString(format: "image%02d.jpg", index % 10) as String
            view.image = UIImage(named: imageNamed)
            scrollView.addSubview(view)
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // debug
        setContent(numberOfPages: 10)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        pageControl1.setProgress(contentOffsetX: scrollView.contentOffset.x, pageWidth: scrollView.bounds.width)
        pageControl2.setProgress(contentOffsetX: scrollView.contentOffset.x, pageWidth: scrollView.bounds.width)
    }
}
