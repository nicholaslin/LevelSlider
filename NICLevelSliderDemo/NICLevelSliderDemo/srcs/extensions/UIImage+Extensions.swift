//
//  UIImage+Extensions.swift
//  platonWallet
//
//  Created by nicholas on 17/10/2018.
//  Copyright © 2018 ju. All rights reserved.
//

import Foundation
import UIKit

public extension UIImage {
    
    public class func gradientImage(colors:[UIColor], size: CGSize) -> UIImage? {
        if colors.count == 0 || size == .zero {
            return nil
        }
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        let cgColors = colors.map { (color) -> CGColor in
            return color.cgColor
        }
        gradientLayer.colors = cgColors
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    
    public func circleImage() -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let path = UIBezierPath(arcCenter: CGPoint(x: size.width/2, y: size.height/2), radius: size.width/2, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        path.addClip()
        draw(at: .zero)
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImg!


    }
}
