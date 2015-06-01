//
//  CounterView.swift
//  $Mate
//
//  Created by 郭振永 on 15/3/24.
//  Copyright (c) 2015年 guozy. All rights reserved.
//

import UIKit

let PI:CGFloat = CGFloat(M_PI)

class CounterView: UIView {
    var numbers: [Kind] = [Kind()] {
        didSet {
            setNeedsDisplay()
        }
    }
    var label: UILabel?
//    var colors = [UIColor.purpleColor(), UIColor.blueColor(), UIColor.brownColor(), UIColor.yellowColor()]
    var colors = [0xeed9678, 0xee7dac9, 0xecb8e85, 0xef3f39d, 0xec8e49c,
                    0xef16d7a, 0xef3d999, 0xed3758f, 0xedcc392, 0xe2e4783,
                    0xe82b6e9, 0xeff6347, 0xea092f1, 0xe0a915d, 0xeeaf889,
                    0xe6699FF, 0xeff6666, 0xe3cb371, 0xed5b158, 0xe38b6b6
                ]

    override func drawRect(rect: CGRect) {
        self.layer.sublayers = nil
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2 - 10)
        //width of circle
        let arcWidth: CGFloat = 20
        //inner radius of corcle
        let radius:CGFloat = 70
        var animation: CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 0.4
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.removedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
//        get every angle of data
        var total: Float = 0.0
        if numbers.count > 0 {
            var beforeAll = [Float]()
            var num = [Float]()
            for number in numbers {
                num.append(number.sum)
            }
            for var i = num.count - 1; i >= 0 ; i-- {
                var before = num[i]
                for var j = i - 1; j >= 0; j-- {
                    before += num[j]
                }
                num[i] = before
            }
            
            total = num[num.count - 1]
            
            var angles = [CGFloat]()
            angles.append(0.0)
            for var i = 0; i < num.count - 1; i++ {
                var angle = CGFloat(num[i]) / CGFloat(total) * CGFloat(2) * PI
                angles.append(angle)
            }
            angles.append(2 * PI)
            
            for var i = 0; i < numbers.count; i++ {
                var path = UIBezierPath(arcCenter: center, radius: radius, startAngle: angles[i], endAngle: angles[i + 1], clockwise: true)
                var calyer = CAShapeLayer()
                calyer.path = path.CGPath
                calyer.strokeColor = UIColor.colorFromCode(colors[i]).CGColor
                calyer.strokeStart = 0
                calyer.strokeEnd = 0
                calyer.fillColor = UIColor.clearColor().CGColor
                calyer.lineWidth = arcWidth
                animation.beginTime = CACurrentMediaTime() + animation.duration * Double(i)
                animation.duration = 0.4 / Double(numbers.count)
                
                calyer.addAnimation(animation, forKey: "strokeEnd")
                self.layer.addSublayer(calyer)
            }
        } else {
            var path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2 * PI, clockwise: true)
            var calyer = CAShapeLayer()
            calyer.path = path.CGPath
            calyer.strokeColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5).CGColor
            calyer.strokeStart = 0
            calyer.strokeEnd = 0
            calyer.fillColor = UIColor.clearColor().CGColor
            calyer.lineWidth = arcWidth
            animation.beginTime = CACurrentMediaTime()
            
            calyer.addAnimation(animation, forKey: "strokeEnd")
            self.layer.addSublayer(calyer)
        }
        
//        var outerPath = UIBezierPath(arcCenter: center, radius: radius + arcWidth / 2, startAngle: 0, endAngle: 2 * PI, clockwise: true)
//        outerPath.lineWidth = 2
//        UIColor.whiteColor().setStroke()
//        outerPath.stroke()
//        
//        var innerPath = UIBezierPath(arcCenter: center, radius: radius - arcWidth / 2, startAngle: 0, endAngle: 2 * PI, clockwise: true)
//        innerPath.lineWidth = 2
//        UIColor.whiteColor().setStroke()
//        innerPath.stroke()
        
        label = UILabel(frame: CGRectMake(center.x - 50, center.y - 20, 100, 40))
        label!.textAlignment = .Center
        label!.font = UIFont.boldSystemFontOfSize(30)
        label!.textColor = UIColor.whiteColor()
//        label!.backgroundColor = UIColor.redColor()
        addSubview(label!)
        if total == 0.0 {
            label!.text = "0.00"
        } else {
            label!.text = "\(total)"
        }
    }
}