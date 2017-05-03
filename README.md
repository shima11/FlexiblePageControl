# FlexiblePageControl
A flexible UIPageControl like Instagram.

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/hsylife/SwiftyPickerPopover)
 ![Swift 3.0.x](https://img.shields.io/badge/Swift-3.0.x-orange.svg)
 [![Support](https://img.shields.io/badge/support-iOS%208%2B%20-blue.svg?style=flat)](https://www.apple.com/nl/ios/)

# OverView

![](demo.gif)

# Install

### Carthage
For Installing with Carthage, add it to your Cartfile.

````
github "shima11/FlexiblePageControl"
````
````
$ carthage update
````

### CocoaPods

For installing with CocoaPods, add it to your Podfile.
```
pod "FlexiblePageControl", :git => "https://github.com/shima11/FlexiblePageControl.git"
```
```
$ pod update
```

# Usage

````
let pageControl = FlexiblePageControl()
pageControl.numberOfPages = 10
view.addSubview(pageControl)

// Updated to the minimum size according to the displayCount
pageControl.updateViewSize()
````

### Customize
````
pageControl.dotSize = 8
pageControl.dotSpace = 5

pageControl.displayCount = 8

pageControl.pageIndicatorTintColor = UIColor.gray
pageControl.currentPageIndicatorTintColor = UIColor.blue
````

### Update page

````
func scrollViewDidScroll(_ scrollView: UIScrollView) {
    pageControl.setProgress(contentOffsetX: scrollView.contentOffset.x, pageWidth: scrollView.bounds.width)
}
````
or
````
pageControl.currentPage = page
````

# Licence

Licence MIT
