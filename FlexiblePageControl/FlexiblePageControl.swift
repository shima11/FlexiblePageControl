//
//  FlexiblePageControl.swift
//  FlexiblePageControl
//
//  Created by 島仁誠 on 2017/04/04.
//  Copyright © 2017年 jinsei shima. All rights reserved.
//


import UIKit

class PageControlView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout())
    
    var selectedPage: Int = 0 {
        didSet {
            
            for row in 0..<pageCount {
                
                // dot color
                updateDotSelected(row: row, selectedPage: selectedPage)
                
//                    // dot size
//                if let cell = cell as? PageCell {
//                    if (selectedPage - row) < -3 || (selectedPage - row) > 3 {
//                        cell.size = PageCell.DotSize.Small
//                    } else if (selectedPage - row) < -2 || (selectedPage - row) > 2 {
//                        cell.size = PageCell.DotSize.Medium
//                    } else {
//                        cell.size = PageCell.DotSize.Large
//                    }
//                }
            }
            
            // dotの移動
            updateDotPosition(selectedPage: selectedPage)
            
            let displayCells = collectionView.visibleCells
            print("displaycell:\(displayCells.count)")
        }
    }
    
    let pageCount: Int
    
    let dotRadius: CGFloat
    
    let dotSpace: CGFloat
    
    let itemRadius: CGFloat
    
    let displayCount: Int
    
    init(dotRadius: CGFloat, pageCount: Int, dotSpace: CGFloat, displayCount: Int = 5) {
        
        self.pageCount = pageCount
        self.dotRadius = dotRadius
        self.dotSpace = dotSpace
        self.displayCount = displayCount
        self.itemRadius = dotRadius + dotSpace
        
        let size = CGSize(width: itemRadius*CGFloat(displayCount), height: itemRadius)
        let frame = CGRect(origin: CGPoint.zero, size: size)
        super.init(frame: frame)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemRadius, height: itemRadius)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: itemRadius*CGFloat(displayCount), height: itemRadius), collectionViewLayout: layout)
        self.addSubview(collectionView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.center = CGPoint(x: bounds.width/2, y: bounds.height/2)
        collectionView.backgroundColor = UIColor.clear
        collectionView.dataSource = self
        collectionView.isUserInteractionEnabled = false
        collectionView.register(PageCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    required init?(coder aDecoder: NSCoder) {
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
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(indexPath.row)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PageCell
        cell.setup(dotRadius: dotRadius)
        cell.isSelected = (selectedPage == indexPath.row) ? true : false
        return cell
    }
}




class PageCell: UICollectionViewCell {
    
    let selectedColor = UIColor.darkGray
    let unSelectedColor = UIColor.lightGray
    
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
    
    override var isSelected: Bool {
        didSet {
            updateDot(selected: isSelected)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setup(dotRadius: CGFloat = 4.0) {
        
        let size = CGSize(width: dotRadius, height: dotRadius)
        let point = CGPoint(x: bounds.width/2, y: bounds.height/2)
        
        dot.frame.size = size
        dot.center = point
        
        dot.layer.cornerRadius = dotRadius/2
        dot.layer.masksToBounds = true
        
        self.addSubview(dot)
        
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
        
        let dotWidth = dot.bounds.width
        
        switch size {
        case .Large:
            dotSize = CGSize(width: dotWidth, height: dotWidth)
        case .Medium:
            dotSize = CGSize(width: dotWidth*0.7, height: dotWidth*0.7)
        case .Small:
            dotSize = CGSize(width: dotWidth*0.5, height: dotWidth*0.5)
        case .Tiny:
            dotSize = CGSize(width: dotWidth*0.3, height: dotWidth*0.3)
        }
        
        dot.frame = CGRect(origin: CGPoint.zero, size: dotSize)
        dot.center = CGPoint(x: bounds.width/2, y: bounds.height/2)
    }
    
}
