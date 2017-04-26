//
//  TimePickerDateCollectionViewCell.swift
//  ServisHero
//
//  Created by DeliveLee on 2017/4/20.
//  Copyright © 2017年 ServisHero. All rights reserved.
//

import UIKit

class TimePickerDateCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblWName: UILabel!
    @IBOutlet weak var lblDName: UILabel!
    
    var isEnable: Bool = false {
        didSet{
            if isEnable{
                if isCellSelected{
                    lblDName.textColor = UIColor.white
                }else{
                    lblDName.textColor = UIColor.black
                }
            }else{
                lblDName.textColor = UIColor.lightGray.withAlphaComponent(0.2)
            }
        }
    }

    
    var isCellSelected: Bool = false{
        didSet{
            if isCellSelected{
                bgView.backgroundColor = UIColor(rgba: "#0069FF")
                lblWName.textColor = UIColor.white
                lblDName.textColor = UIColor.white
            }else{
                bgView.backgroundColor = UIColor(rgba: "#FFFFFF")
                lblWName.textColor = UIColor.black
                lblDName.textColor = UIColor.black
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
