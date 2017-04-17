# FlexiblePageControl
A flexible PageControl like Instagram.

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/hsylife/SwiftyPickerPopover)
 ![Swift 3.0.x](https://img.shields.io/badge/Swift-3.0.x-orange.svg)
 
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

Initialize

````
let pageControl = FlexiblePageControl(
        pageCount: 10,
        dotSize: 6,
        dotSpace: 4
    )
view.addSubview(pageControl)
````

update page

````
func scrollViewDidScroll(_ scrollView: UIScrollView) {
    pageControl.setProgress(contentOffsetX: scrollView.contentOffset.x, pageWidth: scrollView.bounds.width)
}
````

# Licence

Licence MIT
