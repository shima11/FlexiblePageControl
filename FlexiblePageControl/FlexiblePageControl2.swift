//
//  File.swift
//  FlexiblePageControl
//
//  Created by 島仁誠 on 2017/04/06.
//  Copyright © 2017年 jinsei shima. All rights reserved.
//

import UIKit

public class PageControlView_ScrollView: UIView, UIScrollViewDelegate {
    
    public var selectedPage: Int = 0 {
        didSet {
            
            updateDotClor(selectedPage: selectedPage)
            
            if canScroll {
                updateDotPosition(selectedPage: selectedPage, animated: true)
                
                updateDotSize(selectedPage: selectedPage)
            }
        }
    }
    
    public var selectedColor = UIColor(red:0.35, green:0.78, blue:0.98, alpha:1.00)
    
    public var unSelectedColoir = UIColor(red:0.88, green:0.88, blue:0.88, alpha:1.00)

    private let scrollView: UIScrollView

    private let pageCount: Int
    
    private let dotSize: CGFloat
    
    private let dotSpace: CGFloat
    
    private let itemSize: CGFloat
    
    private let displayCount: Int
    
    private let items:[ItemView]
    
    private let canScroll: Bool
    
    public init(dotSize: CGFloat,
                pageCount: Int,
                dotSpace: CGFloat,
                displayCount: Int = 5) {
        
        self.pageCount = pageCount
        self.dotSize = dotSize
        self.dotSpace = dotSpace
        self.displayCount = displayCount
        self.itemSize = dotSize + dotSpace

        var items:[ItemView] = []
        for index in 0..<pageCount {
            let item = ItemView(itemSize: itemSize, dotSize: dotSize, index: index)
            items.append(item)
        }
        self.items = items
        
        self.canScroll = (displayCount < pageCount) ? true : false
        
        if pageCount < 2 {
            scrollView = UIScrollView()
            super.init(frame: CGRect.zero)
            return
        }

        let size = CGSize(width: itemSize*CGFloat(displayCount), height: itemSize)
        let frame = CGRect(origin: CGPoint.zero, size: size)
        
        scrollView = UIScrollView(frame: frame)

        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        
        scrollView.backgroundColor = UIColor.clear
        scrollView.delegate = self
        scrollView.isUserInteractionEnabled = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(width: itemSize*CGFloat(pageCount), height: itemSize)
        if displayCount < pageCount && displayCount > 4 {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: itemSize*2, bottom: 0, right: itemSize*2)
        }
        
        addSubview(scrollView)
        
        for i in 0..<items.count {
            scrollView.addSubview(items[i])
        }
        
        updateDotClor(selectedPage: selectedPage)
        updateDotPosition(selectedPage: 0, animated: false)
        updateDotSize(selectedPage: 0)

    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
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
    
    private func updateDotPosition(selectedPage: Int, animated: Bool) {

        if selectedPage == 0 {
            let x = -scrollView.contentInset.left
//            let y = scrollView.contentOffset.y
//            let point = CGPoint(x: x, y: y)
//            scrollView.setContentOffset(point, animated: animated)
            UIView.animate(withDuration: 0.3, animations: { [unowned self] in
                self.scrollView.contentOffset.x = x
            })
        }
        else if selectedPage == pageCount - 1 {
            let x = scrollView.contentSize.width - scrollView.bounds.width + scrollView.contentInset.right
//            let y = scrollView.contentOffset.y
//            let point = CGPoint(x: x, y: y)
//            scrollView.setContentOffset(point, animated: animated)
            UIView.animate(withDuration: 0.3, animations: { [unowned self] in
                self.scrollView.contentOffset.x = x
            })
        }
        else if CGFloat(selectedPage) * itemSize <= scrollView.contentOffset.x + itemSize {
            let x = scrollView.contentOffset.x - itemSize
//            let y = scrollView.contentOffset.y
//            let position = CGPoint(x: x, y: y)
//            scrollView.setContentOffset(position, animated: animated)
            UIView.animate(withDuration: 0.3, animations: { [unowned self] in
                self.scrollView.contentOffset.x = x
            })
        }
        else if CGFloat(selectedPage) * itemSize + itemSize >= scrollView.contentOffset.x + scrollView.bounds.width - itemSize {
            let x = scrollView.contentOffset.x + itemSize
//            let y = scrollView.contentOffset.y
//            let position = CGPoint(x: x, y: y)
//            scrollView.setContentOffset(position, animated: animated)
            UIView.animate(withDuration: 0.3, animations: { [unowned self] in
                self.scrollView.contentOffset.x = x
            })
        }
    }
    
    private func updateDotSize(selectedPage: Int) {
        
        for index in 0..<pageCount {
            
            let item = items[index]
            
            if index == selectedPage {
                item.state = .Normal
            }
            else if item.frame.minX <= scrollView.contentOffset.x {
                item.state = .Small
            }
            else if item.frame.maxX >= scrollView.contentOffset.x + scrollView.bounds.width {
                item.state = .Small
            }
            else if item.frame.minX <= scrollView.contentOffset.x + itemSize {
                item.state = .Medium
            }
            else if item.frame.maxX >= scrollView.contentOffset.x + scrollView.bounds.width - itemSize {
                item.state = .Medium
            }
            else {
                item.state = .Normal
            }
        }
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        updateDotSize(selectedPage: selectedPage)
    }
    
}


private class ItemView: UIView {
 
    fileprivate let index: Int

    fileprivate var dotColor = UIColor.lightGray {
        didSet {
            dotView.backgroundColor = dotColor
        }
    }
    
    private let dotView = UIView()

    private let itemSize: CGFloat
    private let dotSize: CGFloat

    enum State {
        case Small
        case Medium
        case Normal
    }
    
    fileprivate var state: State = .Normal {
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
            _size = CGSize(width: dotSize*0.7, height: dotSize*0.7)
        case .Small:
            _size = CGSize(width: dotSize*0.5, height: dotSize*0.5)
        }
        
        UIView.animate(withDuration: 0.3, animations: { [unowned self] in
            self.dotView.frame = CGRect(origin: CGPoint.zero, size: _size)
            self.dotView.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        })
    }
    
}

