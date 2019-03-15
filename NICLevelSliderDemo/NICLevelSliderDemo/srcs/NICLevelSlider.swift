//
//  NICLevelSlider.swift
//  sliderTest
//
//  Created by nicholas on 2019/3/11.
//  Copyright © 2019 nicholas. All rights reserved.
//

import UIKit

public protocol NICLevelSliderDelegate: AnyObject {
    func levleSlider(_ levelSlider:NICLevelSlider, didSwitchToLevel level:Int)
}

open class NICLevelSlider: UIView {
    
    //support Gradient color
    open var minimumTrackTintColor: [UIColor] = 
        [UIColor(red: 0x28/255.0, green: 0xAD/255.0, blue: 0xFF/255.0, alpha: 1.0),
         UIColor(red: 0x10/255.0, green: 0x5C/255.0, blue: 0xFE/255.0, alpha: 1.0)]
    
    open var maximumTrackTintColor: UIColor = 
        UIColor(red: 0xD5/255.0, green: 0xD8/255.0, blue: 0xDF/255.0, alpha: 1.0)
    
    open var lineMargin: CGFloat = 16.0 {
        didSet{
            updateSliderConstraints()
        }
    }
    
    open var circleDotRadius: CGFloat = 3.0 {
        didSet{
            updateSliderConstraints()
        }
    }
    
    open var thumbImage: UIImage? {
        didSet{
            if thumbImage != nil {
                
                slider.setThumbImage(thumbImage, for: .normal)
                
                thumbImageWidth = thumbImage!.size.width
            }
        }
    }
    
    open var lineWidth: CGFloat = 2.0
    
    open var level: Int = 4
    
    private(set) open var currentLevel: Int = 1 {
        didSet{
            if oldValue != currentLevel {
                delegate?.levleSlider(self, didSwitchToLevel: currentLevel)
            }
        }
    }
    
    private weak var delegate: NICLevelSliderDelegate?
    
    private var sliderValue: Float = 0 {
        didSet{
            
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            glayer.locations = getGradientLayerLocations(sliderValue)
            CATransaction.commit()
            if sliderValue != slider.value {
                CATransaction.setCompletionBlock { 
                    self.slider.setValue(self.sliderValue, animated: true)
                }
            }
            
        }
    }
    
    private var thumbImageWidth: CGFloat = 14.0 {
        didSet{
            updateSliderConstraints()
        }
    }
    
    private var margin: CGFloat {
        return lineMargin - (thumbImageWidth/2.0 - circleDotRadius)
    }
    
    
    private var sliderLeftConstraints: NSLayoutConstraint!
    
    private var sliderRightConstraints: NSLayoutConstraint!
    
    private var sliderConstraints: [NSLayoutConstraint] {
        
        sliderLeftConstraints = NSLayoutConstraint(item: slider, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: margin)
        
        sliderRightConstraints = NSLayoutConstraint(item: slider, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -margin)
        let topC = NSLayoutConstraint(item: slider, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let bottomC = NSLayoutConstraint(item: slider, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        return [sliderLeftConstraints, sliderRightConstraints, topC, bottomC]
    }
    
    
    lazy private var slider: UISlider! = { () -> UISlider in
        let slider = UISlider(frame: .zero)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = UIColor.clear
        slider.maximumTrackTintColor = UIColor.clear
        slider.addTarget(self, action: #selector(sliderEnd(_:)), for: [.touchUpInside,.touchUpOutside])
        slider.addTarget(self, action: #selector(sliderChange(_:)), for: .valueChanged)

        return slider
    }()
    
    private var glayer: CAGradientLayer!
    private var lLayer: CAShapeLayer!
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override open func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
        drawGradientLayer()
        drawlineLayer()       
        updateSliderValue(value: Float(currentLevel - 1)/Float(level - 1), animated: false)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func updateSliderConstraints() {
        sliderLeftConstraints.constant = margin
        sliderRightConstraints.constant = -margin
        updateConstraintsIfNeeded()
        
    }
    
    private func initSubviews() {
        addSubview(slider)
        addConstraints(sliderConstraints)
    }
    
    private func setup() {
        initSubviews()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
    }
    
    private func drawGradientLayer() {
        
        if glayer != nil {
            return
        }
        glayer = CAGradientLayer()
        glayer.frame = CGRect(x: lineMargin, y: 0, width: bounds.width - 2 * lineMargin, height: bounds.height)
        var cgColors = minimumTrackTintColor.map { (color) -> CGColor in
            color.cgColor
        }
        cgColors.append(contentsOf: [maximumTrackTintColor.cgColor, maximumTrackTintColor.cgColor])
        glayer.colors = cgColors
        glayer.startPoint = CGPoint(x: 0, y: 0.5)
        glayer.endPoint = CGPoint(x: 1, y: 0.5)
        var locations: [NSNumber] = []
        for _ in 0..<cgColors.count-1 {
            locations.append(0)
        }
        locations.append(1)
        glayer.locations = locations
        layer.insertSublayer(glayer, at: 0)
    }
    
    private func drawlineLayer() {
        
        if lLayer != nil {
            return
        }
        
        lLayer = CAShapeLayer()
        
        lLayer.frame = CGRect(x: 1, y: 0, width: glayer.bounds.width - 2, height: glayer.bounds.height)
        
        lLayer.fillColor = UIColor.red.cgColor
        lLayer.strokeColor = UIColor.red.cgColor
        
        let path = UIBezierPath()
        
        let center_y = bounds.height/2
        //draw line
        path.move(to: CGPoint(x: circleDotRadius, y: center_y))
        path.addLine(to: CGPoint(x: lLayer.bounds.width - (circleDotRadius), y: center_y))
        
        //draw circle
        let w = (lLayer.frame.width - 2 * circleDotRadius) / CGFloat(level-1)
        
        for i in 0..<level {
            
            path.addArc(withCenter: CGPoint(x: circleDotRadius + (CGFloat(i) * w), y: center_y), radius: circleDotRadius, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: true)
            
        }
        
        lLayer.path = path.cgPath
        lLayer.lineWidth = lineWidth
        glayer.mask = lLayer
    }
    
    @objc func sliderEnd(_ sender: Any) {
        let s = sender as! UISlider
        updateSliderValue(value: s.value)
        
    }
    
    @objc func sliderChange(_ sender: Any) {
        let s = sender as! UISlider
        sliderValue = s.value
    }
    
    @objc func tap(_ gesture: UIGestureRecognizer) {
        let point = gesture.location(in: self)
        let realPoint = self.convert(point, to: slider)
        let value = Float(realPoint.x) / Float(slider.bounds.width)
        updateSliderValue(value: value)
    }
    
    private func updateSliderValue(value: Float, animated: Bool = true) {
        
        let ava = 1.0 / Float(level-1)
        let half = ava / 2
        let targetValue:Float
        if value.truncatingRemainder(dividingBy: ava) < half {
            currentLevel = Int(value / ava) + 1
            targetValue = Float(Int(value / ava)) * ava
        }else {
            currentLevel = Int(value / ava) + 1 + 1
            targetValue = Float(Int(value / ava) + 1) * ava
        }
        sliderValue = targetValue
        
    }
    
    private func getGradientLayerLocations(_ value: Float) -> [NSNumber] {
        let locationCount = minimumTrackTintColor.count + 2
        let avaValue = value / Float(minimumTrackTintColor.count - 1)
        var locations:[NSNumber] = [0]
        for i in 1..<locationCount-2 {
            locations.append(NSNumber(value: Float(i) * avaValue))
        }
        locations.append(contentsOf: [NSNumber(value: value),1])
        return locations
    }
}
