//
//  extensions.swift
//  SampleCalendarBase
//
//  Created by Madrit on 02/02/2019.
//  Copyright © 2019 Madrit Kacabumi. All rights reserved.
//

import Foundation
import UIKit

var weekStart = 2 // for monday

extension Calendar{
    
    /**
     * Returns an array of shortened week day names
     */
    public static func mapWeekDaysName()->[String]{
        
        var weekDayNames  = [String]()
        
        let today = Date()
        var customCalendar = Calendar.current
        customCalendar.firstWeekday = weekStart // 2 if we want to start from monday, we can also change this dynamically
        
        let startOfWeek = today.startOfWeek// this date must be the day that is the begining of the week
        
        for i in 0..<7{
            
            let nextLoopDate = customCalendar.date(byAdding: .day, value: i, to: startOfWeek, wrappingComponents: false)!
            
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE"
            formatter.locale = Locale.current
            
            let dayWeekName = formatter.string(from: nextLoopDate)
            weekDayNames.append(dayWeekName)
            
        }
        
        
        return weekDayNames
    }
    
    
    
}

extension Date{
    
    /*
     * first day of the week starting from the current day
     */
    var startOfWeek: Date {
        var gregorianCalendar = Calendar(identifier: .gregorian)
        gregorianCalendar.firstWeekday = weekStart
        return gregorianCalendar.date(from: gregorianCalendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
    }
    
    /*
     * Convert a date instance to string formatting it with the given format type
     */
    public func toString(formatToConvert : String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.init(identifier: Locale.current.identifier)
        dateFormatter.dateFormat = formatToConvert
        return dateFormatter.string(from: self);
    }
    
    public func isToday()->Bool{
        
        return self.compareWithYMD(toDate: Date()) == 0
    }
    
    /**
     * Returns -1 if is smaller than
     * Return 0 if are the same
     *
     * Return 1 if is bigger than
     * */
    public func compareWithYMD(toDate : Date) -> Int{
        
        let calendar = Calendar.current
        let thisInstanceYear = calendar.component(.year, from: self)
        let thisInstanceMonth = calendar.component(.month, from: self)
        let thisInstanceDay = calendar.component(.day, from: self)
        
        let toCompareInstanceYear = calendar.component(.year, from: toDate)
        let toCompareInstanceMonth = calendar.component(.month, from: toDate)
        let toCompareInstanceDay = calendar.component(.day, from: toDate)
        
        if(thisInstanceYear == toCompareInstanceYear
            && thisInstanceMonth == toCompareInstanceMonth
            && thisInstanceDay == toCompareInstanceDay){
            
            return 0
        }
        
        //check for smaller than
        if(thisInstanceYear < toCompareInstanceYear){ return -1 }
        
        if(thisInstanceYear == toCompareInstanceYear && thisInstanceMonth < toCompareInstanceMonth){ return -1 }
        
        if(thisInstanceYear == toCompareInstanceYear && thisInstanceMonth == toCompareInstanceMonth && thisInstanceDay < toCompareInstanceDay){ return -1 }
        
        //ok is grater
        
        return 1
    }
    
    /**
     * Returns -1 if is smaller than
     * Return 0 if are the same
     *
     * Return 1 if is bigger than
     *
     * WARNING WARNING WARNING , it compares only the months
     * */
    
    public func compareMonths(toDate : Date) -> Int{
        
        let calendar = Calendar.current
        let thisInstanceMonth = calendar.component(.month, from: self)
        let toCompareInstanceMonth = calendar.component(.month, from: toDate)
        
        if(thisInstanceMonth == toCompareInstanceMonth){ return 0 }
        if(thisInstanceMonth < toCompareInstanceMonth) { return -1 }
        
        return 1
    }
}


extension UIView{
    
    /**
     * removes all child view of a given view
     */
    public func clearAllSuBViews(){
        for view in self.subviews{
            view.removeFromSuperview()
        }
    }
    
    
    /**
     * adds a child view to this views instance
     * adds constrainsts programatically attaching them to this instance with 0
     *  margins at all directions
     **/
    public func attachTo(view : UIView, animated : Bool = true){
        
        view.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: self.superview!.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: self.superview!.bottomAnchor).isActive = true
        self.leadingAnchor.constraint(equalTo: self.superview!.leadingAnchor, constant: 0).isActive = true
        self.trailingAnchor.constraint(equalTo: self.superview!.trailingAnchor, constant: 0).isActive = true
    }
    
    // UI view material
    public func elevate(elevation: Double) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: elevation)
        self.layer.shadowRadius = abs(CGFloat(elevation))
        self.layer.shadowOpacity = 0.5
    }
    
    public func elevate(elevation: Double, radius : Double ,shadowOpacity : Float) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: elevation)
        self.layer.shadowRadius = abs(CGFloat(radius))
        self.layer.shadowOpacity = shadowOpacity
    }
    
    public func asCircle(){
        self.layer.cornerRadius = self.frame.width / 2;
        self.layer.masksToBounds = true
    }
}

extension UICollectionView {
    
    /**
     * Calculates the width and the height of the cell to give it fixed number of columns
     * Should be called in rotation too
     */
    
    func setItemsInRow(items: Int) {
        if let flowLayout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            let horizontalSpacing = flowLayout.scrollDirection == .vertical ? flowLayout.minimumInteritemSpacing : flowLayout.minimumLineSpacing
            
            let cellWidth = (self.frame.width - CGFloat(max(0, items - 1)) * horizontalSpacing) / CGFloat(items)
            
            flowLayout.itemSize = CGSize(width: cellWidth, height: flowLayout.itemSize.height)
        }
    }
    
    func getCellComputedWidthWithFixedColums(columns: Int) -> CGFloat?{
        
        if let flowLayout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            
            let horizontalSpacing = flowLayout.scrollDirection == .vertical ? flowLayout.minimumInteritemSpacing : flowLayout.minimumLineSpacing
            let cellWidth = (self.frame.width - CGFloat(max(0, columns - 1)) * horizontalSpacing) / CGFloat(columns)
            return cellWidth
            
        }
        
        return nil
    }
    
    func getCellComputedHeightWithFixedColums(rows: Int) -> CGFloat?{
        
        if let flowLayout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            
            let verticalSpacing = flowLayout.scrollDirection == .vertical ? flowLayout.minimumLineSpacing : flowLayout.minimumInteritemSpacing
            let cellHeight = (self.frame.height - CGFloat(max(0, rows - 1)) * verticalSpacing) / CGFloat(rows)
            return cellHeight
            
        }
        
        return nil
    }
}

extension UIColor {
    
    public convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}


