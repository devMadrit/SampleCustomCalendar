//
//  WeekDayNameView.swift
//  SampleCalendarBase
//
//  Created by Madrit on 02/02/2019.
//  Copyright © 2019 Madrit Kacabumi. All rights reserved.
//

import UIKit

class WeekDayNameView: UIView {
    
    @IBOutlet weak var weekName: UILabel!
    
    func setWeekDayName(shortWeekName : String){
        weekName.text = shortWeekName
    }
    
}
