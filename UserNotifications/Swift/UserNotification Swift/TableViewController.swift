//
//  TableViewController.swift
//  UserNotification Swift
//
//  Created by pro648 on 18/8/18
//  Copyright © 2018年 pro648. All rights reserved.
//

import UIKit
import UserNotifications

class TableViewController: UITableViewController {
    
    enum Segue: String {
        case showCalendar
        case showTimeInterval
        case showLocation
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let string = segue.identifier, let seg = Segue(rawValue: string) else {
            return
        }
        
        switch seg {
        case .showCalendar:
            guard let vc = segue.destination as? CalendarViewController else {
                fatalError("The destination should be CalendarViewController")
            }
            vc.notificationType = .calendar
            
        case .showTimeInterval:
            guard let vc = segue.destination as? TimeIntervalViewController else {
                fatalError("The destination should be TimeIntervalViewController")
            }
            vc.notificationType = .timeInterval
            
        case .showLocation:
            guard let vc = segue.destination as? LocationViewController else {
                fatalError("The destination should be LocationViewController")
            }
            vc.notificationType = .location
        }
    }
}
