//
//  FlexiblePageControl.swift
//  FlexiblePageControl
//
//  Created by 島仁誠 on 2017/04/04.
//  Copyright © 2017年 jinsei shima. All rights reserved.
//


import UIKit

public class PageControlView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    public var selectedPage: Int = 0 {
        didSet {
            for row in 0..<pageCount {
                // dot color
                updateDotSelected(row: row, selectedPage: selectedPage)
            }
            // dot move
            updateDotPosition(selectedPage: selectedPage)
        }
    }
    
    private let pageCount: Int
    
    private let dotRadius: CGFloat
    
    private let dotSpace: CGFloat
    
    private let itemRadius: CGFloat
    
    private let displayCount: Int
    
    private let selectedColor: UIColor
    
    private let unSelectedColoir: UIColor
    
    private var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout())
    
    private let cellIdentifier = "cell"
    
    public init(dotRadius: CGFloat,
                pageCount: Int,
                dotSpace: CGFloat,
                displayCount: Int = 5,
                selectedColor: UIColor = .darkGray,
                unSelectedColor: UIColor = .lightGray) {
        
        self.pageCount = pageCount
        self.dotRadius = dotRadius
        self.dotSpace = dotSpace
        self.displayCount = displayCount
        self.itemRadius = dotRadius + dotSpace
        
        self.selectedColor = selectedColor
        self.unSelectedColoir = unSelectedColor
        
        let size = CGSize(width: itemRadius*CGFloat(displayCount), height: itemRadius)
        let frame = CGRect(origin: CGPoint.zero, size: size)
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemRadius, height: itemRadius)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(
            frame: CGRect(x: 0, y: 0, width: itemRadius*CGFloat(displayCount), height: itemRadius),
            collectionViewLayout: layout
        )
        collectionView.backgroundColor = UIColor.clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isUserInteractionEnabled = false
        collectionView.register(PageCell.self, forCellWithReuseIdentifier: cellIdentifier)

        addSubview(collectionView)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.center = CGPoint(x: bounds.width/2, y: bounds.height/2)
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        updateDotSize(selectedPage: selectedPage)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateDotSelected(row: Int, selectedPage: Int) {
        let indexPath = IndexPath(row: row, section: 0)
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.isSelected = (row == selectedPage) ? true : false
    }

    private func updateDotPosition(selectedPage: Int) {
        
        if selectedPage > 0 && selectedPage < pageCount-1 {
            
            if itemRadius * CGFloat(selectedPage) <= collectionView.contentOffset.x { // left side
                let pointX = collectionView.contentOffset.x - itemRadius
                let pointY = collectionView.contentOffset.y
                let point = CGPoint(x: pointX, y: pointY)
                collectionView.setContentOffset(point, animated: true)
            }
            else if itemRadius * CGFloat(selectedPage) + itemRadius >= collectionView.contentOffset.x + collectionView.bounds.width { // right side
                let pointX = collectionView.contentOffset.x + itemRadius
                let pointY = collectionView.contentOffset.y
                let point = CGPoint(x: pointX, y: pointY)
                collectionView.setContentOffset(point, animated: true)
            }
        }
    }
    
    private func updateDotSize(selectedPage: Int) {
        
        let displayCells = collectionView.visibleCells.filter {
            collectionView.bounds.contains($0.frame)
        }
        guard let cells = displayCells as? [PageCell] else { return }
        let indexs = cells.map { $0.index }
        let min = indexs.min()
        let max = indexs.max()
        
        for cell in cells {
            if cell.index == selectedPage {
                cell.state = PageCell.DotSize.Large
            }
            else if cell.index == 0 || cell.index == pageCount - 1 {
                cell.state = PageCell.DotSize.Large
            }
            else if cell.index == min || cell.index == max {
                cell.state = PageCell.DotSize.Small
            }
            else {
                cell.state = PageCell.DotSize.Large
            }
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! PageCell
        cell.setup(dotRadius: dotRadius)
        cell.index = indexPath.row
        cell.selectedColor = selectedColor
        cell.unSelectedColor = unSelectedColoir
        cell.isSelected = (selectedPage == indexPath.row) ? true : false
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        // dot size
        updateDotSize(selectedPage: selectedPage)
    }
}


private class PageCell: UICollectionViewCell {
    
    public var selectedColor = UIColor.darkGray
    public var unSelectedColor = UIColor.lightGray
    
    public var index: Int = 0
    
    enum DotSize {
        case Tiny
        case Small
        case Medium
        case Large
    }
    
    let dot = UIView()
    
    var state = DotSize.Large {
        didSet {
            updateSize(size: state)
        }
    }
    
    public override var isSelected: Bool {
        didSet {
            updateDot(selected: isSelected)
        }
    }
    
    private var dotRadius: CGFloat = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setup(dotRadius: CGFloat = 4.0) {
        
        self.dotRadius = dotRadius
        
        let size = CGSize(width: dotRadius, height: dotRadius)
        let point = CGPoint(x: bounds.width/2, y: bounds.height/2)
        
        dot.frame.size = size
        dot.center = point
        
        dot.layer.cornerRadius = dotRadius/2
        dot.layer.masksToBounds = true
        
        addSubview(dot)
        
        updateDot(selected: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateDot(selected: Bool) {
        dot.backgroundColor = selected ? selectedColor : unSelectedColor
    }
    
    func updateSize(size: DotSize) {
        var dotSize: CGSize
        
        let dotWidth = dotRadius
        
        switch size {
        case .Large:
            dotSize = CGSize(width: dotWidth, height: dotWidth)
        case .Medium:
            dotSize = CGSize(width: dotWidth*0.9, height: dotWidth*0.9)
        case .Small:
            dotSize = CGSize(width: dotWidth*0.7, height: dotWidth*0.7)
        case .Tiny:
            dotSize = CGSize(width: dotWidth*0.5, height: dotWidth*0.5)
        }
        
        dot.frame = CGRect(origin: CGPoint.zero, size: dotSize)
        dot.center = CGPoint(x: bounds.width/2, y: bounds.height/2)
    }
    
}
