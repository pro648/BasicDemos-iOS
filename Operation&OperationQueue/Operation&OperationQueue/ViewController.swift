//
//  ViewController.swift
//  Operation&OperationQueue
//
//  Created by pro648 on 2020/4/19.
//  Copyright © 2020 pro648. All rights reserved.
//
//  详细介绍：https://github.com/pro648/tips/wiki/Operation%E3%80%81OperationQueue%E7%9A%84%E4%BD%BF%E7%94%A8

import UIKit

class ViewController: UIViewController {
    
    private let queue = OperationQueue()
    private var urls: [URL] = []
    private var operations: [IndexPath: [Operation]] = [:]
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        testBlockOperation()
//        testMultipleBlockOperation()
        
        guard let plist = Bundle.main.url(forResource: "Photos", withExtension: "plist"),
            let contents = try? Data(contentsOf: plist),
            let serial = try? PropertyListSerialization.propertyList(from: contents, format: nil),
            let serialUrls = serial as? [String] else {
                print("Something went horribly wrong!")
                return
        }
        
        urls = serialUrls.compactMap(URL.init)
    }
    
    private func testBlockOperation() {
        let operation = BlockOperation {
            print("7 + 11 = \(7 + 11)")
        }
        operation.start()
    }
    
    private func testMultipleBlockOperation() {
        let sentence = "The author of this article is pro648"
        let wordOperation = BlockOperation()
        
        for word in sentence.split(separator: " ") {
            wordOperation.addExecutionBlock {
                print(word)
                sleep(2)
            }
        }
        
        wordOperation.completionBlock = {
            print("https://github.com/pro648/tips/wiki")
        }
        
        let interval = duration {
            wordOperation.start()
        }
        print("Timeinterval: \(interval)")
    }
    
    private func duration(_ block: () -> ()) -> TimeInterval {
        let startTime = Date()
        block()
        return Date().timeIntervalSince(startTime)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        cell.display(image: nil)
//        let inputImage = UIImage(named: "\(indexPath.row).png")!
//        cell.display(image: inputImage)
        
        // Version 1
//        guard let filteredImage = SepiaFilter().applySepiaFilter(inputImage) else {
//            cell.display(image: nil)
//            return cell
//        }
//        cell.display(image: filteredImage)
        
        // 使用FilterOperation添加滤镜
//        print("Filtering")
//        let op = FilterOperation(image: inputImage)
//        op.start()
//
//        cell.display(image: op.outputImage)
//        print("Done")
        
        // 将Operation添加到OperationQueue
//        let op = FilterOperation(image: inputImage)
//        op.completionBlock = {
//            DispatchQueue.main.async {
//                guard let cell = tableView.cellForRow(at: indexPath) as? PhotoCell else { return }
//
//                cell.isLoading = false
//                cell.display(image: op.outputImage)
//            }
//        }
//        queue.addOperation(op)
        
        // 使用网络图片
//        let op = NetworkImageOperation(url: urls[indexPath.row  ])
//        op.completionBlock = {
//            DispatchQueue.main.async {
//                guard let cell = tableView.cellForRow(at: indexPath) as? PhotoCell else { return }
//
//                cell.isLoading = false
//                cell.display(image: op.image)
//            }
//        }
//        queue.addOperation(op)
        
        // 使用 dependency
        let downloadOp = NetworkImageOperation(url: urls[indexPath.row])
        let filterOp = FilterOperation()
        filterOp.completionBlock = {
            DispatchQueue.main.async {
                guard let cell = tableView.cellForRow(at: indexPath) as? PhotoCell else { return }
                
                cell.isLoading = false
                cell.display(image: filterOp.image)
            }
        }
        filterOp.addDependency(downloadOp)
        
        queue.addOperation(downloadOp)
        queue.addOperation(filterOp)
        
        // 取消已有 operation，将上面的operation添加到字典。
        if let exisingOperations = operations[indexPath] {
            for operation in exisingOperations {
                operation.cancel()
            }
        }
        operations[indexPath] = [downloadOp, filterOp]
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let exisingOperations = operations[indexPath] {
            for operation in exisingOperations {
                operation.cancel()
            }
        }
    }
}
