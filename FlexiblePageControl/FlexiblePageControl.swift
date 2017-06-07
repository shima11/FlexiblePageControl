//
//  File.swift
//  FlexiblePageControl
//
//  Created by 島仁誠 on 2017/04/06.
//  Copyright © 2017年 jinsei shima. All rights reserved.
//

import UIKit

public class FlexiblePageControl: UIView {

    // MARK: public

    public var pageIndicatorTintColor: UIColor = UIColor(red:0.86, green:0.86, blue:0.86, alpha:1.00) {
        didSet {
            updateDotColor(currentPage: currentPage)
        }
    }

    public var currentPageIndicatorTintColor: UIColor = UIColor(red:0.32, green:0.59, blue:0.91, alpha:1.00) {
        didSet {
            updateDotColor(currentPage: currentPage)
        }
    }

    public var currentPage: Int = 0 {
        didSet {
            scrollView.layer.removeAllAnimations()
            setCurrentPage(currentPage: currentPage, animated: true)
        }
    }

    public var numberOfPages: Int = 0 {
        didSet {
            scrollView.isHidden = (numberOfPages <= 1 && hidesForSinglePage)
            displayCount = min(displayCount, numberOfPages)
        }
    }

    // Recommended displayCount is 5 or more.

    public var displayCount: Int = 7 {
        didSet {
            canScroll = (numberOfPages > displayCount)
            update()
        }
    }

    public var dotSize: CGFloat = 6 {
        didSet {
            update()
        }
    }

    public var dotSpace: CGFloat = 4 {
        didSet {
            update()
        }
    }

    public var smallDotSizeRatio: CGFloat = 0.5 {
        didSet {
            ItemView.smallSizeRatio = smallDotSizeRatio
        }
    }

    public var mediumDotSizeRatio: CGFloat = 0.7 {
        didSet {
            ItemView.mediumSizeRatio = mediumDotSizeRatio
        }
    }

    public var animateDuration: TimeInterval = 0.3

    public var hidesForSinglePage: Bool = false {
        didSet {
            scrollView.isHidden = (numberOfPages <= 1 && hidesForSinglePage)
        }
    }

    public init() {

        super.init(frame: .zero)

        setup()
        updateViewSize()
    }

    public override init(frame: CGRect) {

        super.init(frame: frame)

        setup()
    }

    required public init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)

        setup()
        updateViewSize()
    }

    public override func layoutSubviews() {

        super.layoutSubviews()
        
        scrollView.center = CGPoint(x: bounds.width/2, y: bounds.height/2)
    }

    public override var intrinsicContentSize: CGSize {

        return CGSize(width: itemSize * CGFloat(displayCount), height: itemSize)
    }

    public func setProgress(contentOffsetX: CGFloat, pageWidth: CGFloat) {

        let currentPage = Int(round(contentOffsetX/pageWidth))
        if currentPage == self.currentPage { return }
        self.currentPage = currentPage
    }

    public func updateViewSize() {

        self.bounds.size = intrinsicContentSize
    }

    // MARK: private

    private let scrollView: UIScrollView = UIScrollView()

    private var canScroll: Bool = false

    private var itemSize: CGFloat {

        return dotSize + dotSpace
    }
    
    private var items:[ItemView] = [ItemView]()

    private func setup() {

        backgroundColor = UIColor.clear

        scrollView.backgroundColor = UIColor.clear
        scrollView.isUserInteractionEnabled = false
        scrollView.showsHorizontalScrollIndicator = false

        addSubview(scrollView)
    }

    private func update() {

        var items:[ItemView] = []
        for index in -2..<(displayCount+2) {
            let item = ItemView(itemSize: itemSize, dotSize: dotSize, index: index)
            items.append(item)
        }
        self.items = items

        scrollView.contentSize = CGSize(width: itemSize * CGFloat(numberOfPages), height: itemSize)

        let views = scrollView.subviews
        for view in views {
            view.removeFromSuperview()
        }
        for i in 0..<items.count {
            scrollView.addSubview(items[i])
        }

        let size = CGSize(width: itemSize * CGFloat(displayCount), height: itemSize)
        let frame = CGRect(origin: .zero, size: size)

        scrollView.frame = frame

        if displayCount < numberOfPages {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: itemSize * 2, bottom: 0, right: itemSize * 2)
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }

        setCurrentPage(currentPage: currentPage, animated: false)
    }

    private func setCurrentPage(currentPage: Int, animated: Bool) {

        updateDotColor(currentPage: currentPage)
        
        if canScroll {
            updateDotPosition(currentPage: currentPage, animated: animated)
            updateDotSize(currentPage: currentPage, animated: animated)
        }
    }
    
    private func updateDotColor(currentPage: Int) {
     
        for index in 0..<(displayCount + 4) {
            let pageIndex = items[index].index
            items[index].dotColor = (pageIndex == currentPage) ? currentPageIndicatorTintColor : pageIndicatorTintColor
        }
    }
    
    private func updateDotPosition(currentPage: Int, animated: Bool) {

        let duration = animated ? animateDuration : 0

        if currentPage == 0 {
            let x = -scrollView.contentInset.left
            moveScrollViewView(x: x, duration: duration)
        }
        else if currentPage == numberOfPages - 1 {
            let x = scrollView.contentSize.width - scrollView.bounds.width + scrollView.contentInset.right
            moveScrollViewView(x: x, duration: duration)
        }
        else if CGFloat(currentPage) * itemSize <= scrollView.contentOffset.x + itemSize {
            let x = scrollView.contentOffset.x - itemSize
            moveScrollViewView(x: x, duration: duration)
        }
        else if CGFloat(currentPage) * itemSize + itemSize >= scrollView.contentOffset.x + scrollView.bounds.width - itemSize {
            let x = scrollView.contentOffset.x + itemSize
            moveScrollViewView(x: x, duration: duration)
        }
    }

    private func moveScrollViewView(x: CGFloat, duration: TimeInterval) {

        let direction = behaviorDirection(x: x)
        reusedView(direction: direction)
        UIView.animate(withDuration: duration, animations: { [unowned self] in
            self.scrollView.contentOffset.x = x
        })
    }

    private enum Direction {

        case left, right, stay
    }

    private func behaviorDirection(x:CGFloat) -> Direction {

        if x > scrollView.contentOffset.x {
            return .right
        }
        else if x < scrollView.contentOffset.x {
            return .left
        }
        else {
            return .stay
        }
    }

    private func reusedView(direction: Direction) {

        guard let firstItem = items.first else { return }
        guard let lastItem = items.last else { return }

        switch direction {
        case .left:

            lastItem.index = firstItem.index - 1
            lastItem.frame = CGRect(x: CGFloat(lastItem.index) * itemSize, y: 0, width: itemSize, height: itemSize)
            items.insert(lastItem, at: 0)
            items.removeLast()

        case .right:

            firstItem.index = lastItem.index + 1
            firstItem.frame = CGRect(x: CGFloat(firstItem.index) * itemSize, y: 0, width: itemSize, height: itemSize)
            items.insert(firstItem, at: items.count)
            items.removeFirst()

        case .stay:

            break
        }
    }

    private func updateDotSize(currentPage: Int, animated: Bool) {

        let duration = animated ? animateDuration : 0

        for index in 0..<(displayCount + 4) {

            let item = items[index]

            item.animateDuration = duration

            if item.index == currentPage {
                item.state = .Normal
            }
            // outside of left
            else if item.index < 0 {
                item.state = .None
            }
            // outside of right
            else if item.index > numberOfPages - 1 {
                item.state = .None
            }
            // first dot from left
            else if item.frame.minX <= scrollView.contentOffset.x {
                item.state = .Small
            }
            // first dot from right
            else if item.frame.maxX >= scrollView.contentOffset.x + scrollView.bounds.width {
                item.state = .Small
            }
            // second dot from left
            else if item.frame.minX <= scrollView.contentOffset.x + itemSize {
                item.state = .Medium
            }
            // second dot from right
            else if item.frame.maxX >= scrollView.contentOffset.x + scrollView.bounds.width - itemSize {
                item.state = .Medium
            }
            else {
                item.state = .Normal
            }
        }
    }
}


private class ItemView: UIView {

    enum State {
        case None
        case Small
        case Medium
        case Normal
    }

    static var mediumSizeRatio: CGFloat = 0.7

    static var smallSizeRatio: CGFloat = 0.5

    var index: Int

    var dotColor = UIColor.lightGray {
        didSet {
            dotView.backgroundColor = dotColor
        }
    }

    var state: State = .Normal {
        didSet {
            updateDotSize(state: state)
        }
    }

    var animateDuration: TimeInterval = 0.3

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


    // MARK: private

    private let dotView = UIView()

    private let itemSize: CGFloat

    private let dotSize: CGFloat
    
    private func updateDotSize(state: State) {
        
        var _size: CGSize
        
        switch state {
        case .Normal:
            _size = CGSize(width: dotSize, height: dotSize)
        case .Medium:
            _size = CGSize(width: dotSize * ItemView.mediumSizeRatio, height: dotSize * ItemView.mediumSizeRatio)
        case .Small:
            _size = CGSize(width: dotSize * ItemView.smallSizeRatio, height: dotSize * ItemView.smallSizeRatio)
        case .None:
            _size = CGSize.zero
        }

        dotView.layer.cornerRadius = _size.height / 2.0

        UIView.animate(withDuration: animateDuration, animations: { [unowned self] in
            self.dotView.layer.bounds.size = _size
        })
    }
}

