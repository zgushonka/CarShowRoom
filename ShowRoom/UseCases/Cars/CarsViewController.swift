//
//  CarsViewController.swift
//  ShowRoom
//
//  Created by Oleksandr Buravlyov on 4/9/18.
//  Copyright © 2018 farelapps. All rights reserved.
//

import UIKit

class CarsViewController: ItemsViewController {
    
    private func showDetailsAlert(forItem index: Int) {
        if let car = viewModel.item(forIndex: index) as? Car {
            let message = "\(viewModel.viewTitle) - \(car.name)"
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel)
            alert.addAction(action)
            present(alert, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showDetailsAlert(forItem: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

