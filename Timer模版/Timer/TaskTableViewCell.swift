//
//  TaskTableViewCell.swift
//  Timer
//
//  Created by pro648 on 2020/1/19.
//  Copyright © 2020 pro648. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var task: Task? {
        didSet {
            taskLabel.text = task?.name
            setState()
            updateTime()
        }
    }
    
    func updateState() {
        guard let task = task else {
            return
        }
        
        task.completed.toggle()
        
        setState()
        updateTime()
    }
    
    func updateTime() {
        guard let task = task else {
            return
        }
        
        if task.completed {
            timeLabel.text = "Completed"
        } else {
            let time = Date().timeIntervalSince(task.creationDate)
            
            let hours = Int(time) / 3600
            let minutes = Int(time) / 60 % 60
            let seconds = Int(time) % 60
            
            var times: [String] = []
            if hours > 0 {
                times.append("\(hours)h")
            }
            if minutes > 0 {
                times.append("\(minutes)m")
            }
            times.append("\(seconds)s")
            
            timeLabel.text = times.joined(separator: " ")
        }
    }
    
    private func setState() {
        guard let task = task else {
            return
        }
        
        if task.completed {
            taskLabel.attributedText = NSAttributedString(string: task.name, attributes: [.strikethroughStyle: 1])
        } else {
            taskLabel.attributedText = NSAttributedString(string: task.name, attributes: nil)
        }
    }

}
