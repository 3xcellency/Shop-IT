//
//  ViewController+Actions.swift
//  Shop IT
//
//  Created by Ozan on 6.08.2022.
//

import Foundation
import UIKit
extension ViewController
{
    @objc func buttonAction(sender: UIButton!) {
   
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cellVM = viewModel.getCellViewModel( at: indexPath)
        //Maksimum olan stok
        let maxStock = cellVM.stock
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? CustomCollectionCell else {
            fatalError("Cell not exists in storyboard")
        }
        //Miktarın artıp, azalacağını kontrol etme
        lazy var isIncrease: Bool = {
            return sender == cell.btnAdd
        }()
        
        lazy var stock: Int = {
            //Miktar artıyorsa && maksimum stok kontrolü
           if isIncrease && maxStock > cell.lblStock.tag
                
            {
                 cell.lblStock.tag += 1
               viewModel.addToCart(model: viewModel.datas[sender.tag])
            }
            //Miktar azalıyorsa && minimum miktar kontrolü
            else if !isIncrease && cell.lblStock.tag > 1
            {
                 cell.lblStock.tag -= 1
                 viewModel.removeToCart(model: viewModel.datas[sender.tag])
            }
            return cell.lblStock.tag
        }()
        
        cell.lblStock.text = stock.description
        cell.btnReduce.isHidden = false
        cell.lblStock.isHidden = false
     }
}
