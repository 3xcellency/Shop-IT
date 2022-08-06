//
//  ViewController+Extensions.swift
//  Shop IT
//
//  Created by Ozan on 6.08.2022.
//

import Foundation
import UIKit
extension CartViewController
{
    @IBAction func backToHome()
    {
        //Ana sayfaya dön
        dismiss(animated: true)
    }
    
    @IBAction func wipeAll()
    {
        //Son kontrol
        self.showAlert("Emin misiniz?", message: "Sepetteki tüm ürünler silenecektir.") { success in
            if success
            {
                self.viewModel.wipeAllCart()
            }
        }
    }
    @IBAction func confirmCart()
    {
        //Son kontrol
        self.showAlert("Emin misiniz?", message: "Sepetteki ürünleri satın alacaksınız.") { success in
            if success
            {
                self.viewModel.completeShop()
            }
        }
    }
    @objc func buttonAction(sender: UIButton!) {
   
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cellVM = viewModel.getCellViewModel( at: indexPath)
        //Maksimum olan stok
        let maxStock = cellVM.stock
 

        guard let cell = tableView.cellForRow(at: indexPath) as? CartTableViewCell else {
            fatalError("Cell not exists in storyboard")
        }

        //Miktarın artıp, azalacağını kontrol etme
        lazy var isIncrease: Bool = {
            return sender == cell.btnAdd
        }()
        
        lazy var stock: Int = {
            //Miktar artıyorsa && maksimum stok kontrolü
           if isIncrease && maxStock > cell.lblAmount.tag
                
            {
                 cell.lblAmount.tag += 1
                 viewModel.addToCart(index: sender.tag)
            }
            //Miktar azalıyorsa && minimum miktar kontrolü
            else if !isIncrease && cell.lblAmount.tag > 1
            {
                 cell.lblAmount.tag -= 1
                 viewModel.removeToCart(index: sender.tag)
            }
            return cell.lblAmount.tag
        }()
        
        cell.lblAmount.text = stock.description
     }
}
