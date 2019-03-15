//
//  ViewController.swift
//  NICLevelSliderDemo
//
//  Created by juzix on 2019/3/12.
//  Copyright © 2019 nicholas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let frame = CGRect(x: 0, y: 200, width: 375, height: 20)
        let slider = NICLevelSlider(frame: frame, numOfLevels: 4, initialLevel: 2)
    
        slider.lineMargin = 30
        slider.delegate = self
        
        let image = UIImage.gradientImage(colors: [UIColor(red: 0x28/255.0, green: 0xAD/255.0, blue: 0xFF/255.0, alpha: 1.0),UIColor(red: 0x10/255.0, green: 0x5C/255.0, blue: 0xFE/255.0, alpha: 1.0)], size: CGSize(width: 20, height: 20))
        
        slider.thumbImage = image?.circleImage()
        
        view.addSubview(slider)
    }

}

extension ViewController: NICLevelSliderDelegate {
    func levleSlider(_ levelSlider: NICLevelSlider, didSwitchToLevel level: Int) {
        print("level:\(level)")
    }
}
