//
//  CalendarViewController.swift
//  SampleCalendarBase
//
//  Created by Madrit on 02/02/2019.
//  Copyright © 2019 Madrit Kacabumi. All rights reserved.
//

import UIKit

class MonthViewController: UIViewController {

    public var uiPagerIndex : Int!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initCollectionView()
    }
    
    func initCollectionView(){
        
        collectionView.register(UINib(nibName: "DayCell", bundle: nil), forCellWithReuseIdentifier: "DayCell")
        
        collectionView.setItemsInRow(items: 7)
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

//Mark : UICollectionViewDelegate, UICollectionViewDataSource
extension MonthViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 42
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCell", for: indexPath) as! DayCell
        
        /**
         * Adding days depending on the pager index for the month and the indexPath.row for day in month
         */
        
        // 1. Go to the Month based on pagerindex
        let currentMonthDate = Calendar.current.date(byAdding: Calendar.Component.month, value: uiPagerIndex, to: Date())!
        
        // 2. go to the begining of the month
         let beginingOfTheMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: currentMonthDate)))!
        
        // 3. now go to the first day of the week , starting from the begining of the month,
        //      we will call it @finalStartMonthDay
        let finalStartMonthDay = beginingOfTheMonth.startOfWeek
        
        // 4. now update thouse dates starting from @finalStartMonthDay with indexPath.row
        
        let dayInThisIndexPath = Calendar.current.date(byAdding: .day, value: indexPath.row, to: finalStartMonthDay)!
        
        // now just update the cell
        
        cell.dayLabel.text = dayInThisIndexPath.toString(formatToConvert: "d")
        
        
        if(dayInThisIndexPath.compareMonths(toDate: beginingOfTheMonth) == 0){
            
            if(uiPagerIndex == 0 && dayInThisIndexPath.isToday()){
                cell.dayContainer.backgroundColor = UIColor(hexString: "#3DB1BF")
                cell.dayLabel.textColor = .white
            }else{
                cell.dayContainer.backgroundColor = .clear
                cell.dayLabel.textColor = DayCell.normalColor
            }
            
        }else{
            cell.dayContainer.backgroundColor = .clear
            cell.dayLabel.textColor = DayCell.notBelongToTheMonthColor
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.getCellComputedWidthWithFixedColums(columns: 7)!, height: collectionView.getCellComputedHeightWithFixedColums(rows: 6)!)
    }
}
