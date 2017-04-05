//
//  File.swift
//  FlexiblePageControl
//
//  Created by 島仁誠 on 2017/04/06.
//  Copyright © 2017年 jinsei shima. All rights reserved.
//

import UIKit

class PageControl: UIView, UIScrollViewDelegate {
    
    var scrollView = UIScrollView()
    
    public var selectedPage: Int = 0 {
        didSet {
            updateDotClor(selectedPage: selectedPage)
        }
    }
    
    private let pageCount: Int
    
    private let dotSize: CGFloat
    
    private let dotSpace: CGFloat
    
    private let itemSize: CGFloat
    
    private let displayCount: Int
    
    private let selectedColor: UIColor
    
    private let unSelectedColoir: UIColor
    
    private let items:[ItemView]
    
    public init(dotSize: CGFloat,
                pageCount: Int,
                dotSpace: CGFloat,
                displayCount: Int = 5,
                selectedColor: UIColor = .darkGray,
                unSelectedColor: UIColor = .lightGray) {
        
        self.pageCount = pageCount
        self.dotSize = dotSize
        self.dotSpace = dotSpace
        self.displayCount = displayCount
        self.itemSize = dotSize + dotSpace
        
        self.selectedColor = selectedColor
        self.unSelectedColoir = unSelectedColor
        
        var items:[ItemView] = []
        for index in 0..<pageCount {
            let item = ItemView(itemSize: itemSize, dotSize: dotSize, index: index)
            items.append(item)
        }
        self.items = items
        
        let size = CGSize(width: itemSize*CGFloat(displayCount), height: itemSize)
        let frame = CGRect(origin: CGPoint.zero, size: size)
        
        if pageCount < 2 {
            super.init(frame: CGRect.zero)
            return
        }
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        
        scrollView = UIScrollView(frame: frame)
        scrollView.backgroundColor = UIColor.clear
        scrollView.delegate = self
//        scrollView.isUserInteractionEnabled = false
        scrollView.isScrollEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(width: itemSize*CGFloat(pageCount), height: itemSize)
        
        addSubview(scrollView)
        
        for i in 0..<items.count {
            scrollView.addSubview(items[i])
        }
        
        updateDotClor(selectedPage: selectedPage)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
    }
    
    private func updateDotClor(selectedPage: Int) {
        for index in 0..<pageCount {
            if index == selectedPage {
                items[index].dotColor = selectedColor
                items[index].state = .Normal
            }
            else {
                items[index].dotColor = unSelectedColoir
                items[index].state = .Small
            }
        }
    }
    
}


class ItemView: UIView {
 
    let itemSize: CGFloat
    let dotSize: CGFloat

    let index: Int

    let dotView = UIView()
    
    var dotColor = UIColor.lightGray {
        didSet {
            dotView.backgroundColor = dotColor
        }
    }
    
    enum State {
        case Small
        case Medium
        case Normal
    }
    
    var state: State = .Normal {
        didSet {
            updateDotSize(state: state)
        }
    }
    
    init(itemSize: CGFloat, dotSize: CGFloat, index: Int) {
        
        self.itemSize = itemSize
        self.dotSize = dotSize
        self.index = index
        
        let x = itemSize * CGFloat(index)
        
        let frame = CGRect(x: x, y: 0, width: itemSize, height: itemSize)

        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        
        dotView.frame.size = CGSize(width: dotSize, height: dotSize)
        dotView.center = CGPoint(x: itemSize/2, y: itemSize/2)
        dotView.backgroundColor = dotColor
        dotView.layer.cornerRadius = dotSize/2
        dotView.layer.masksToBounds = true
        
        addSubview(dotView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateDotSize(state: State) {
        
        var _size: CGSize
        
        switch state {
        case .Normal:
            _size = CGSize(width: dotSize, height: dotSize)
        case .Medium:
            _size = CGSize(width: dotSize*0.8, height: dotSize*0.8)
        case .Small:
            _size = CGSize(width: dotSize*0.6, height: dotSize*0.6)
        }
        
        dotView.frame = CGRect(origin: CGPoint.zero, size: _size)
        dotView.center = CGPoint(x: bounds.width/2, y: bounds.height/2)
    }
    
}

