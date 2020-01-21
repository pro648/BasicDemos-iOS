//
//  ViewController.swift
//  Timer
//
//  Created by pro648 on 2020/1/19.
//  Copyright © 2020 pro648. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var balloon: Balloon!
    
    var timer: Timer?
    
    var taskList: [Task] = []
    
//    var animationTimer: Timer?
//    var startTime: TimeInterval?, endTime: TimeInterval?
    var displayLink: CADisplayLink?
    var startTime: CFTimeInterval?, endTime: CFTimeInterval?
    let animationDuration = 3.0
    var height: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentAlertController(_:)))
    }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? TaskTableViewCell else { return }
        
        cell.updateState()
        
        showCongratulationsIfNeeded()
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        
        if let cell = cell as? TaskTableViewCell {
            cell.task = taskList[indexPath.row]
        }
        
        return cell
    }
}

// MARK: - Actions
extension ViewController {
    @objc func presentAlertController(_ sender: UIBarButtonItem) {
        createTimer()
        
        let alertController = UIAlertController(title: "Task Name", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Task name"
            textField.autocapitalizationType = .sentences
        }
        
        let createAction = UIAlertAction(title: "OK", style: .default) { [weak self, weak alertController] _ in
            guard let self = self,
                let text = alertController?.textFields?.first?.text else {
                    return
            }
            
            DispatchQueue.main.async {
                let task = Task(name: text)
                self.taskList.append(task)
                let indexPath = IndexPath(row: self.taskList.count - 1, section: 0)
                
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: [indexPath], with: .top)
                self.tableView.endUpdates()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(createAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Timer
extension ViewController {
    func createTimer() {
        if timer == nil {
//            timer = Timer.scheduledTimer(timeInterval: 1.0,
//                                         target: self,
//                                         selector: #selector(updateTimer),
//                                         userInfo: nil,
//                                         repeats: true)
//            timer?.tolerance = 0.15
            
            let timer = Timer(timeInterval: 1.0,
                              target: self,
                              selector: #selector(updateTimer),
                              userInfo: nil,
                              repeats: true)
            RunLoop.current.add(timer, forMode: .common)
            timer.tolerance = 0.15
            
            self.timer = timer
        }
    }
    
    func cancelTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func updateTimer() {
        if let fireDateDescription = timer?.fireDate.description {
            print(fireDateDescription)
        }
        
        guard let visibleRowsIndexPaths = tableView.indexPathsForVisibleRows else {
            return
        }
        
        for indexPath in visibleRowsIndexPaths {
            if let cell = tableView.cellForRow(at: indexPath) as? TaskTableViewCell {
                cell.updateTime()
            }
        }
    }
}

// MARK: - Animation
extension ViewController {
    func showCongratulationAnimation() {
        height = UIScreen.main.bounds.height + balloon.frame.size.height
        balloon.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: height + balloon.frame.size.height / 2)
        balloon.isHidden = false
        
        startTime = Date().timeIntervalSince1970
        endTime = animationDuration + startTime!
        
//        animationTimer = Timer.scheduledTimer(withTimeInterval: 1 / 60, repeats: true, block: { (timer) in
//            self.updateAnimation()
//        })
        displayLink = CADisplayLink(target: self,
                                    selector: #selector(updateAnimation))
        displayLink?.add(to: RunLoop.main, forMode: .common)
    }
    
    @objc func updateAnimation() {
        guard let endTime = endTime,
        let startTime = startTime else { return }
        
//        let now = Date().timeIntervalSince1970
        let now = CACurrentMediaTime()
        
        if now >= endTime {
//            animationTimer?.invalidate()
            displayLink?.isPaused = true
            displayLink?.invalidate()
            balloon.isHidden = true
        }
        
        let percentage = (now - startTime) * 100 / animationDuration
        let y = height - ((height + balloon.frame.height / 2) / 100 * CGFloat(percentage))
        
        balloon.center = CGPoint(x: balloon.center.x + CGFloat.random(in: -0.5...0.5), y: y)
    }
    
    func showCongratulationsIfNeeded() {
        if taskList.filter({ !$0.completed }).count == 0 {
            cancelTimer()
            showCongratulationAnimation()
        } else {
            createTimer()
        }
    }
}
