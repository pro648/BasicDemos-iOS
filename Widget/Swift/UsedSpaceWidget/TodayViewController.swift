//
//  TodayViewController.swift
//  UsedSpaceWidget
//
//  Created by pro648 on 2018/7/22
//  Copyright © 2018 pro648. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        let tapGestureGesture = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(_:)))
        tapGestureGesture.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGestureGesture);
        detailsLabel.numberOfLines = 3

        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        
        updateUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .compact {
            self.preferredContentSize = maxSize
            detailsLabel.isHidden = true
        } else {
            self.preferredContentSize = CGSize(width: 0, height: 180)
            detailsLabel.isHidden = false
        }
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        // Retrieve the attributes from FileManager.
        let rate = UserDefaults.standard.double(forKey: "rate")
        let newRate: Double = Double(usedDiskSpaceInBytes) / Double (totalDiskSpaceInBytes)
        
        if fabs(rate - newRate) < 0.0001 {
            // 如果容量变化小于0.0001，将不更新界面。
            completionHandler(NCUpdateResult.noData)
        } else {
            // 只有容量变化大于0.0001时，才更新界面。
            updateUI()
            completionHandler(NCUpdateResult.newData)
        }
    }
    
    func updateUI() {
        let rate: Double = Double(usedDiskSpaceInBytes) / Double(totalDiskSpaceInBytes)
        
        // 缓存使用比例
        UserDefaults.standard.set(rate, forKey: "rate")
        
        percentLabel.text = String(format: "%.1f%%", rate * 100)
        progressView.progress = Float(rate)
        
        detailsLabel.text = String(format: "Used:\t%@\nFree:\t%@\nTotal:\t%@", convertByteToGB(usedDiskSpaceInBytes), convertByteToGB(freeDiskSpaceInBytes), convertByteToGB(totalDiskSpaceInBytes))
    }
    
    // byte转换为GB
    func convertByteToGB(_ bytes:Int64) -> String {
        let formatter:ByteCountFormatter = ByteCountFormatter()
        formatter.countStyle = .file
        
        return formatter.string(fromByteCount: Int64(bytes))
    }
    
    @objc func handleSingleTap(_ sender: UITapGestureRecognizer) {
        let firstURL = NSURL(string: "widget://first/word?From%20Widget%20To%20First%20VC")
        let secondURL = NSURL(string: "widget://second/word?From%20Widget%20To%20Second%20VC")
        
        // 从app groups读取数据。
        let userDefaults = UserDefaults(suiteName: "group.pro648.widget.swift")
        let isFirst = userDefaults?.bool(forKey: "isFirst")
        
        let url: NSURL
        
        guard let first = isFirst else { return  }
        
        if first {
            url = secondURL!
        } else {
            url = firstURL!
        }
        
        extensionContext?.open(url as URL, completionHandler: { (completed) in
            print("Successfully open \(String(describing: url.query?.removingPercentEncoding))")
        })
    }
    
    // 设备总空间
    var totalDiskSpaceInBytes: Int64 {
        guard let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String),
            let space = (systemAttributes[FileAttributeKey.systemSize] as? NSNumber)?.int64Value else { return 0 }
        return space
    }
    
    // 还未使用空间
    var freeDiskSpaceInBytes: Int64 {
        if #available(iOS 11.0, *) {
            // iOS 11中增加了volumeAvailableCapacityForImportantUsageKey、volumeAvailableCapacityForOpportunisticUsageKey。
            if let space = try? URL(fileURLWithPath: NSHomeDirectory() as String).resourceValues(forKeys: [URLResourceKey.volumeAvailableCapacityForImportantUsageKey]).volumeAvailableCapacityForImportantUsage {
                return space ?? 0
            } else {
                return 0
            }
        } else {
            if let space = try? URL(fileURLWithPath: NSHomeDirectory() as String).resourceValues(forKeys: [URLResourceKey.volumeAvailableCapacityKey]).volumeAvailableCapacity {
                return Int64(space ?? 0)
            } else {
                return 0
            }
        }
    }
    
    // 已使用空间
    var usedDiskSpaceInBytes: Int64 {
        return totalDiskSpaceInBytes - freeDiskSpaceInBytes
    }
    
    
    
    
}
