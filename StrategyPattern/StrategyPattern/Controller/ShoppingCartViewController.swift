//
//  ShoppingCartViewController.swift
//  StrategyPattern
//
//  Created by pro648 on 2019/5/25.
//  Copyright © 2019 pro648. All rights reserved.
//

import UIKit

class ShoppingCartViewController: UIViewController {

    var meals: [Meal] = []
    private let cellIdentifier = "cellIdentifier"
    
    var itemPrices: [Int] = [60, 80, 39]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let caprese = Meal(name: "Caprese Salad", image: "meal1", price: "$ 90")
        let pasta = Meal(name: "Pasta with Meatballs", image: "meal2", price: "$ 75")
        let delivery = Meal(name: "Delivery", image: "delivery", price: "$ 20")
        meals.append(caprese)
        meals.append(pasta)
        meals.append(delivery)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        view.endEditing(false)
        
        if let destinationViewController: TotalPriceViewController = segue.destination as? TotalPriceViewController {
//            destinationViewController.bindProperties(itemPrices: itemPrices, checkoutType: .normal)
            
            destinationViewController.bindProperties(itemPrices: itemPrices, checkoutStrategy: NormalPriceStrategy())
//            destinationViewController.bindProperties(itemPrices: itemPrices, checkoutStrategy: DiscountStrategy())
//            destinationViewController.bindProperties(itemPrices: itemPrices, checkoutStrategy: FreeShippingStrategy())
        }
    }
    
    // MARK: - IBACtion
    
    @IBAction func checkoutBarButtonItemTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "detailSegue", sender: nil)
    }
}

// MARK: - UITableViewDataSource

extension ShoppingCartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell")
        }
        
        let meal = meals[indexPath.row]
        cell.nameLabel?.text = meal.name
        cell.priceLabel?.text = meal.price
        cell.photoImageView?.image = UIImage(named: meal.image)
        
        return cell
    }
}

extension ShoppingCartViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
