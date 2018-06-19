# **SPRINGVIEW**
[![License](https://img.shields.io/cocoapods/l/Hero.svg?style=flat)](https://github.com/lucasassisro/springview/blob/master/LICENSE?raw=true)
![Swift 4.0+](https://img.shields.io/badge/Swift-4.0%2B-orange.svg)

UIView subclass with associated spring animations.

![gif example](https://cdn.rawgit.com/LucasAssisRo/springview/02ab78ec/resources/out.gif)


## **INSTALL**
Just download the springview folder and add it to your project

## **HOW TO USE**

  1- Create the view controller to be embedded on the spring view.

  2- Implement the SpringViewDelegate on the embedded view controller to handle the expand and colapse events.

  3- Add contraints to your spring views **(the animations will not work without contraints)**.

  4- On the master view controller call ```swift springView.embed(viewController: embededViewController, in: self, delegate: embededViewController)```
  
  5- If you want to handle the spring view events on the master view controller also add notification observers to the notifications  ```swift .springExpand``` and ```swift .springColapse``` like so:
  
      ```swift
       NotificationCenter.default.addObserver(self,
                                              selector: #selector(expandSpring(_:)),
                                              name: NSNotification.Name.springExpand,
                                              object: nil)
                                         
       NotificationCenter.default.addObserver(self,
                                              selector: #selector(colapseSpring(_:)),
                                              name: NSNotification.Name.springColapse,
                                              object: nil)
      ```
