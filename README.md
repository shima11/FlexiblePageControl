# FlexiblePageControl
A flexible PageControl like Instagram.

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/hsylife/SwiftyPickerPopover)
 ![Swift 3.0.x](https://img.shields.io/badge/Swift-3.0.x-orange.svg)
 
# OverView


# Install

For Installing with Carthage, add it to your Cartfile.

````
github "shima11/FlexiblePageControl"
````

terminal

````
carthage update
````

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
Update page
````
pageControl.selectedPage = page

````

# Licence

Licence MIT
