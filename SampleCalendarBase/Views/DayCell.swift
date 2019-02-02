//
//  DayCell.swift
//  SampleCalendarBase
//
//  Created by Madrit on 02/02/2019.
//  Copyright © 2019 Madrit Kacabumi. All rights reserved.
//

import UIKit

class DayCell : UICollectionViewCell{
    
    public static let normalColor = UIColor.black
    
    public static let notBelongToTheMonthColor = UIColor.lightGray
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dayContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dayContainer.asCircle()
    }
}
