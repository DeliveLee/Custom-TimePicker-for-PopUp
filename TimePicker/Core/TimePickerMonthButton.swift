//
//  TimePickerMonthButton.swift
//  ServisHero
//
//  Created by DeliveLee on 2017/4/20.
//  Copyright © 2017年 ServisHero. All rights reserved.
//

import UIKit

class TimePickerMonthButton: UIButton {

    var bottomBorder: CALayer = CALayer()
    
    var isActive: Bool = false {
        didSet {
            if isActive {
                self.bottomBorder.backgroundColor = UIColor(rgba:"#FFC816").cgColor
                self.setTitleColor(UIColor.black, for: .normal)
            }else{
                self.bottomBorder.backgroundColor = UIColor.gray.cgColor
                self.setTitleColor(UIColor.gray, for: .normal)
            }
            self.layoutSubviews()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        bottomBorder.frame = CGRect(x: 0, y: self.frame.height-2, width: self.frame.width, height: 2)
        
        self.layer.addSublayer(bottomBorder)
    }

    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
