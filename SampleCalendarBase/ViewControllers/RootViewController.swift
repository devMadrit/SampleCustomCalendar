//
//  ViewController.swift
//  SampleCalendarBase
//
//  Created by Madrit on 02/02/2019.
//  Copyright © 2019 Madrit Kacabumi. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    /* data **/
    
    var currentPagerIndex = 0 {
        didSet{
            updateHeaderInfo()
        }
    }
    
    /*views**/
    @IBOutlet weak var shortMonthNameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var weekDaysContainer: UIStackView!
    @IBOutlet weak var pagerContainer: UIView!
    var uiPageView : UIPageViewController!
    
    /* actions outlet**/
    @IBAction func todayBtnClick(_ sender: UIButton) {
        if(currentPagerIndex != 0){
            let pagerDirection = (currentPagerIndex > 0) ? UIPageViewController.NavigationDirection.reverse : UIPageViewController.NavigationDirection.forward
            self.uiPageView.setViewControllers([viewControllerAtIndex(index: 0)], direction: pagerDirection, animated: true, completion: nil)
            currentPagerIndex = 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initWeekDayNames();
        initUiPageViewController()
    }
    
    func initWeekDayNames(){
        
        weekDaysContainer.clearAllSuBViews()
        let weekNames = Calendar.mapWeekDaysName()
        
        for shortWeekName in weekNames{
            let weekView = UINib(nibName: "WeekDayNameView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! WeekDayNameView
            weekView.setWeekDayName(shortWeekName: shortWeekName)
            weekDaysContainer.addArrangedSubview(weekView)
        }
    }
    
    func updateHeaderInfo(){
        let calendar = Calendar.current
        let newMonthAndYear = calendar.date(byAdding: Calendar.Component.month, value: currentPagerIndex, to: Date())!
        shortMonthNameLabel.text = newMonthAndYear.toString(formatToConvert: "MMM")
        yearLabel.text = newMonthAndYear.toString(formatToConvert: "yyyy")
    }
    
    func initUiPageViewController(){
        uiPageView = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        addChild(uiPageView)
        uiPageView.view.attachTo(view: pagerContainer)
        uiPageView.delegate = self
        uiPageView.dataSource = self
        uiPageView.setViewControllers([viewControllerAtIndex(index: 0)], direction: .forward, animated: false, completion: nil)
    }
    
}

// Mark : UIPageViewCOntrollerDelegate, UIPageViewControllerDataSource

extension RootViewController : UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let oldIndex = (viewController as! MonthViewController).uiPagerIndex!
        
        return viewControllerAtIndex(index: oldIndex - 1)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let oldIndex = (viewController as! MonthViewController).uiPagerIndex!
        
        return viewControllerAtIndex(index: oldIndex + 1)
    }
    
    private func viewControllerAtIndex(index : Int) -> MonthViewController{
        let monthViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MonthViewController") as! MonthViewController
        monthViewController.uiPagerIndex = index
        
        return monthViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if(completed){
            currentPagerIndex = (pageViewController.viewControllers![0] as! MonthViewController).uiPagerIndex
        }
    }
}
