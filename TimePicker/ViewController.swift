//
//  ViewController.swift
//  TimePicker
//
//  Created by DeliveLee on 2017/4/26.
//  Copyright © 2017年 DeliveLee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, TimePickerViewDelegate {

    
    @IBOutlet weak var lblTime: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func btnDisplayClicked(_ sender: UIButton) {
        let nib:Array = Bundle.main.loadNibNamed("TimePickerView", owner: self, options: nil)!
        let TimePickerView = nib[0] as? TimePickerView
        TimePickerView?.setData(frame: self.view.frame, everyDayStartTime: 8, everyDayEndTime: 15)
                TimePickerView?.delegate = self
        self.view.addSubview(TimePickerView!)

    }
    
    func TimePickerSelectDone(_ time: Date){
        self.lblTime.text = time.toString(.custom("d/M, H:mm a"), timeZone: .utc)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

