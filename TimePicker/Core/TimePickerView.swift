//
//  TimePickerView.swift
//  ServisHero
//
//  Created by DeliveLee on 2017/4/20.
//  Copyright © 2017年 ServisHero. All rights reserved.
//

import UIKit

protocol TimePickerViewDelegate{
    func TimePickerSelectDone(_ time: Date)
}


class TimePickerView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {

    
    @IBOutlet weak var TopView: TimePickerViewTopView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollView: TimePickerViewScrollView!
    
    var everyDayStartTime: Int!
    var everyDayEndTime: Int!
    var selectedDate: [[String: Any]]!
    var selectedDay: [String: Any]!
    
    var delegate: TimePickerViewDelegate?

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    /// Use this func to set Default data
    /// TimePicker will show 3 months days and times options can select
    /// Past Date will be disable
    ///
    /// - parameter frame: Set the popup size
    /// - parameter everyDayStartTime: Set can select time when earliest everyday
    /// - parameter everyDayEndTime: Set can select time when latest everyday
    
    func setData(frame: CGRect, everyDayStartTime: Int, everyDayEndTime: Int){
        self.frame = frame
        self.setDefault()
        self.setDate()
        self.scrollView.setData(timeMinsGap: 30, startTime: everyDayStartTime, endTime: everyDayEndTime)
        self.collectionView.scrollToItem(at: IndexPath(row: (self.selectedDay["index"] as! Int), section: 0), at: .centeredHorizontally, animated: true)
    }

    
    func setDefault(){
        
        let xib : UINib  = UINib (nibName: "TimePickerDateCollectionViewCell", bundle: nil)
        self.collectionView.register(xib, forCellWithReuseIdentifier: "TimePickerDateCollectionViewCell")

        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    func setDate(){
        selectedDate = Array()
        self.selectedDay = nil
        
        var date = Date().dateAtTheStartOfMonth().dateByAddingMonths(TopView.selectedIndex)
        let daysInMonth = date.monthDays()
        for i in 1...daysInMonth{

            if(self.selectedDay == nil){
                if(date.month()-Date().month()>0){
                    self.selectedDay = ["date": date, "isSelected": true, "isEnable": true, "index": i - 1]
                    selectedDate.append(["date": date, "isSelected": true, "isEnable": true, "index": i - 1])
                }else if((date.day()-Date().day()) >= 0){
                    self.selectedDay = ["date": date, "isSelected": true, "isEnable": true, "index": i - 1]
                    selectedDate.append(["date": date, "isSelected": true, "isEnable": true, "index": i - 1])
                }else{
                    selectedDate.append(["date": date, "isSelected": false, "isEnable": false, "index": i - 1])
                }
            }else{
                selectedDate.append(["date": date, "isSelected": false, "isEnable": (((date.day()-Date().day())>=0) || (date.month()-Date().month()>0)) ? true : false, "index": i - 1])
            }
            date = date.dateByAddingDays(1)
        }
    }
    
    
    @IBAction func cancelClicked(_ sender: UIButton) {
        self.removeFromSuperview()

    }
    
    @IBAction func btnOKClicked(_ sender: UIButton) {
        var date = Date().dateAtTheStartOfMonth().dateAtStartOfDay();
        date = date.dateByAddingMonths(self.TopView.selectedIndex)
        date = date.dateByAddingDays(self.selectedDay["index"] as! Int)
        
        let scrollViewDate = self.scrollView.selectedOption["date"] as! Date
        date = date.dateByAddingHours(scrollViewDate.hour())
        date = date.dateByAddingMinutes(scrollViewDate.minute())
        self.delegate?.TimePickerSelectDone(date)
        self.removeFromSuperview()
    }

    @IBAction func btnMonthClicked(_ sender: TimePickerMonthButton) {
        self.TopView.selectedWithBtn(sender)
        self.setDate()
        self.collectionView.reloadData()
        self.collectionView.scrollToItem(at: IndexPath(row: (self.selectedDay["index"] as! Int), section: 0), at: .centeredHorizontally, animated: true)

    }
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectedDate.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell: TimePickerDateCollectionViewCell? = (collectionView.dequeueReusableCell(withReuseIdentifier: "TimePickerDateCollectionViewCell", for: indexPath) as? TimePickerDateCollectionViewCell)
        if (cell == nil)
        {
            let nib:Array = Bundle.main.loadNibNamed("TimePickerDateCollectionViewCell", owner: self, options: nil)!
            cell = nib[0] as? TimePickerDateCollectionViewCell
        }
        
        if(self.selectedDate[indexPath.row]["isSelected"] as! Bool == true){
            cell?.isCellSelected = true
        }else{
            cell?.isCellSelected = false
        }
        
        let date = self.selectedDate[indexPath.row]["date"] as! Date
        cell?.lblDName.text = String(date.day())
        cell?.lblWName.text = date.shortWeekdayToString()
        cell?.isEnable = self.selectedDate[indexPath.row]["isEnable"] as! Bool
//        cell?.lblDName
        
//        if self.timeOptionArr[indexPath.section][indexPath.row]["isSelected"] as! Bool {
//            cell?.view.borderColor = UIColor(rgba: "#207CF7")
//            cell?.lblTime.textColor = UIColor(rgba: "#207CF7")
//        }else{
//            cell?.view.borderColor = UIColor.lightGray
//            cell?.lblTime.textColor = UIColor.black
//        }
//        
//        cell?.lblTime.text = self.timeOptionArr[indexPath.section][indexPath.row]["labelText"] as! String
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard (self.selectedDate[indexPath.row]["isEnable"] as! Bool) else {
            return
        }
        for (index, _) in self.selectedDate.enumerated(){
            self.selectedDate[index]["isSelected"] = false
        }
        self.selectedDate[indexPath.row]["isSelected"] = true
        self.selectedDay = self.selectedDate[indexPath.row]
        self.collectionView.reloadData()
        
//        if self.timeOptionArr[indexPath.section][indexPath.row]["isSelected"] as! Bool {
//            self.timeOptionArr[indexPath.section][indexPath.row]["isSelected"] = !(self.timeOptionArr[indexPath.section][indexPath.row]["isSelected"] as! Bool)
//            self.collectionView.reloadData()
//            
//            self.TopView.removeATimeSelected(self.timeOptionArr[indexPath.section][indexPath.row])
//            self.topViewHeightCons.constant = self.TopView.needHeight
//            
//        }else{
//            
//            var selectedNum = 0
//            for i in 0...self.timeOptionArr.count-1{
//                
//                for k in 0...self.timeOptionArr[i].count-1{
//                    guard !(self.timeOptionArr[i][k]["isSelected"] as! Bool) else {
//                        selectedNum += 1
//                        continue
//                    }
//                }
//                
//            }
//            
//            if selectedNum >= self.maxSelectedNum{
//                let alert = UIAlertController(title: "Sorry", message: "You can select option up to \(String(self.maxSelectedNum))", preferredStyle: UIAlertControllerStyle.alert)
//                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//                let appDelegate = UIApplication.shared.delegate  as! AppDelegate
//                appDelegate.window!.rootViewController!.present(alert, animated: true, completion: nil)
//            }else{
//                self.timeOptionArr[indexPath.section][indexPath.row]["isSelected"] = !(self.timeOptionArr[indexPath.section][indexPath.row]["isSelected"] as! Bool)
//                self.collectionView.reloadData()
//                self.TopView.addATimeSelected(self.timeOptionArr[indexPath.section][indexPath.row])
//                self.topViewHeightCons.constant = self.TopView.needHeight
//                
//            }
//            
//            
//        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize{
        
//        let itemGap : Float = 5.0
//        let cellWidth = (Float(ScreenSize.SCREEN_WIDTH - 60) - (itemGap * 2))/3
        return  CGSize(width: 60, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 5, 5, 5)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}


class TimePickerViewTopView: UIView{
    
    @IBOutlet weak var btnMonthOne: TimePickerMonthButton!
    @IBOutlet weak var btnMonthTwo: TimePickerMonthButton!
    @IBOutlet weak var btnMonthThree: TimePickerMonthButton!

    var btnArr: [TimePickerMonthButton]!
    
    var selectedIndex : Int = 0 {
        didSet{
            self.btnArr.forEach { (btn) in
                btn.isActive = false
            }
            self.btnArr[selectedIndex].isActive = true
        }
    }
    
    func selectedWithBtn(_ selectedBtn: TimePickerMonthButton){
        for (index, btn) in self.btnArr.enumerated(){
            if selectedBtn == btn{
                selectedIndex = index
            }
            
        }

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
         self.btnArr = [btnMonthOne, btnMonthTwo, btnMonthThree]
        self.selectedIndex = 0

    }
    
    
}


class TimePickerViewScrollView: UIScrollView, UIScrollViewDelegate{

    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var contentWidthCons: NSLayoutConstraint!
    
    @IBOutlet weak var lblSelectOption: UILabel!

    let optionWidth = 6
    let optionCountInAScreen = 11
    let tallOptionHeight = 70
    let optionHeight = 50
    var optionGap : CGFloat!
    
    var timeMinsGap : Int = 30
    var startTime : Int = 8
    var endTime : Int = 20
    var howMuchSelectOptions : Int!
    var timeOptionArr : [[String:Any]]!
    var dateFormatter : DateFormatter!
    var selectedOption : [String: Any]!

    
    func setData(timeMinsGap: Int, startTime: Int, endTime: Int){

        self.timeMinsGap = timeMinsGap
        self.startTime = startTime
        self.endTime = endTime
        self.timeOptionArr = Array()

        self.setDefault()
        self.handleTimeArr()
    }

    func setDefault(){
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY - MM - dd HH:mm:ss zzz"
        
        self.bounces = false
        self.delegate = self
    }
    
    func handleTimeArr(){
        howMuchSelectOptions = Int(29 * 60 / timeMinsGap) + 1
        optionGap = (self.frame.width / CGFloat(optionCountInAScreen-1)) - CGFloat(optionWidth)

        let howContentWidth = ((CGFloat(optionWidth) + optionGap) * CGFloat(howMuchSelectOptions - 1))
        self.contentWidthCons.constant = howContentWidth
        
        self.handleTimeUI()
        
        //set default time option
        self.setContentOffset(CGPoint(x: (self.selectedOption["optionView"] as! UIView).frame.origin.x + CGFloat(optionWidth/2) - self.frame.size.width/2, y: 0), animated: true)
        let startStr = (self.selectedOption["date"] as! Date).toString(.custom("h:mm a"), timeZone: .utc)
        let endStr = (self.selectedOption["date"] as! Date).dateByAddingHours(2).toString(.custom("h:mm a"), timeZone: .utc)
        lblSelectOption.text = "\(startStr) - \(endStr)"
    }
    
    func handleTimeUI(){
        
        var date = Date().dateAtStartOfDay().dateByAddingHours(startTime).dateByAddingMinutes(-150)
        var startX = CGFloat(0 - (optionWidth/2))
        for i in -5...(howMuchSelectOptions-1-5) {
            let isTallOption = (date.minute() == 0) ? true : false
            let tempTime = CGFloat(i)*(CGFloat(timeMinsGap)/(CGFloat(60)))
            let isEnableOption = ((tempTime >= CGFloat(startTime))&&(tempTime<=CGFloat(endTime))) ? true : false
            
            let optionView = UIView()
            optionView.frame = CGRect(x: startX, y: self.frame.size.height - (isTallOption ? CGFloat(tallOptionHeight) : CGFloat(optionHeight)) - 23, width: CGFloat(optionWidth), height: (isTallOption ? CGFloat(tallOptionHeight) : CGFloat(optionHeight)))
            optionView.layer.cornerRadius = 3
            optionView.layer.borderWidth = 0
            optionView.backgroundColor = isEnableOption ? UIColor.gray : UIColor.lightGray.withAlphaComponent(0.4)
            self.contentView.addSubview(optionView)
            
            if isTallOption {
                let label = UILabel(frame: CGRect(x: startX, y: self.frame.size.height - CGFloat(23), width: CGFloat(100), height: CGFloat(13)))
                label.text = date.toString(.custom("h a"), timeZone: .utc)
                label.font = UIFont.systemFont(ofSize: 12)
                label.sizeToFit()
                label.center = CGPoint(x: CGFloat(label.center.x-(label.frame.size.width/2)), y: label.center.y)
                self.contentView.addSubview(label)
            }
            
            let time = dateFormatter.date(from: date.toString(.custom(dateFormatter.dateFormat)))
            self.timeOptionArr.append(["optionView":optionView, "date": time!, "isEnableOption": isEnableOption])
            if (self.selectedOption == nil) && isEnableOption{
                self.selectedOption = ["optionView":optionView, "date": time!, "isEnableOption": isEnableOption]
            }
            date = date.dateByAddingMinutes(timeMinsGap)
            startX += (optionGap + CGFloat(optionWidth))
            
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        var distance : Double = Double(self.frame.size.width)
        
        self.timeOptionArr.forEach { (item) in
            let thisPointDistance = self.distanceBetweenPoint(point: CGPoint(x: scrollView.contentOffset.x + self.frame.size.width/2, y: 0), toPoint: CGPoint(x: (item["optionView"] as! UIView).frame.origin.x + CGFloat(optionWidth/2), y: 0))
            if(thisPointDistance<=distance && item["isEnableOption"] as! Bool){
                self.selectedOption = item
                distance = thisPointDistance
            }
        }
        let startStr = (self.selectedOption["date"] as! Date).toString(.custom("h:mm a"), timeZone: .utc)
        let endStr = (self.selectedOption["date"] as! Date).dateByAddingHours(2).toString(.custom("h:mm a"), timeZone: .utc)
        lblSelectOption.text = "\(startStr) - \(endStr)"
        
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool){
        if !decelerate {
            self.setContentOffset(CGPoint(x: (self.selectedOption["optionView"] as! UIView).frame.origin.x + CGFloat(optionWidth/2) - self.frame.size.width/2, y: 0), animated: true)
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        self.setContentOffset(CGPoint(x: (self.selectedOption["optionView"] as! UIView).frame.origin.x + CGFloat(optionWidth/2) - self.frame.size.width/2, y: 0), animated: true)
    }

    func distanceBetweenPoint(point: CGPoint, toPoint: CGPoint) -> Double {
        let dx = Double(toPoint.x - point.x)
        let dy = Double(toPoint.y - point.y)
        return sqrt(dx*dx + dy*dy)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
                
    }
    
    
}
