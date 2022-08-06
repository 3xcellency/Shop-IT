//
//  CartViewController.swift
//  Shop IT
//
//  Created by Ozan on 6.08.2022.
//

import Foundation
import UIKit

class CartViewController: UIViewController {
    
    let viewModel = CartViewModel()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbltotalPrice: UILabel!
    @IBOutlet weak var lblCartisEmpty: UILabel!
    
    override func viewDidLoad() {
        initViewModel()
    }
    
    func initViewModel(){
        
        viewModel.reloadTableView = {
            DispatchQueue.main.async { self.tableView.reloadData() }
        }
        viewModel.showError = { err in
            DispatchQueue.main.async { self.showAlert(err.isEmpty ? "Ops, something went wrong." : err) }
        }
        viewModel.updateTotalPrice = { price in
            DispatchQueue.main.async { self.lbltotalPrice.text = price }
        }
        viewModel.completeCart = { text in
            DispatchQueue.main.async { self.customAlert(text) }
        }
        viewModel.getData()
  
    }

}
extension CartViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       
       if editingStyle == .delete {
           viewModel.deleteItem(indexPath: indexPath)
       }
   }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        lblCartisEmpty.isHidden = viewModel.numberOfCells > 0
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cart_cell", for: indexPath) as? CartTableViewCell else {
            fatalError("Cell not exists in storyboard")
        }
        
        let cellVM = viewModel.getCellViewModel( at: indexPath )
        cell.lblAmount.text = cellVM.amount.description
        cell.lblAmount.tag = cellVM.amount
        cell.tag = cellVM.stock
        cell.lblPrice.text = String(format: "%.2f", (Double(cellVM.amount)  * cellVM.priceText)) .appending(cellVM.currency)
        cell.imgView.kf.setImage(with: URL(string: cellVM.imgPath))
        cell.lblName.text = cellVM.nameText
        cell.btnAdd.tag = indexPath.row
        cell.btnReduce.tag = indexPath.row
        cell.btnAdd.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        cell.btnReduce.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    
        return cell
    }
    
 
}
