# FlexiblePageControl
A flexible UIPageControl like Instagram.

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/hsylife/SwiftyPickerPopover)
 ![Swift 4.2.x](https://img.shields.io/badge/Swift-4.2.x-orange.svg)
 [![Support](https://img.shields.io/badge/support-iOS%208%2B%20-blue.svg?style=flat)](https://www.apple.com/nl/ios/)

# OverView

![](demo.gif)

# Install

### Carthage

For Installing with Carthage, add it to your `Cartfile`.

````
github "shima11/FlexiblePageControl"
````
````
$ carthage update
````

### CocoaPods

For installing with CocoaPods, add it to your `Podfile`.
```
pod "FlexiblePageControl"
```
```
$ pod update
```

# Usage

````
let pageControl = FlexiblePageControl()
pageControl.numberOfPages = 10
view.addSubview(pageControl)
````

### Customize

````
// color
pageControl.pageIndicatorTintColor = color1
pageControl.currentPageIndicatorTintColor = color2

// size
let config = Config(
    displayCount: 7,
    dotSize: 6,
    dotSpace: 4,
    smallDotSizeRatio: 0.5,
    mediumDotSizeRatio: 0.7
)
pageControl.setConfig(config)
````

### Update page

````
func scrollViewDidScroll(_ scrollView: UIScrollView) {
    pageControl.setProgress(contentOffsetX: scrollView.contentOffset.x, pageWidth: scrollView.bounds.width)
}
````
or
````
pageControl.setCurrentPage(at: page)
````

# Licence

Licence MIT
