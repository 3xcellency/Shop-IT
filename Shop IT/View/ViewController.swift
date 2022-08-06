//
//  ViewController.swift
//  Shop IT
//
//  Created by Ozan on 4.08.2022.
//

import UIKit
import Alamofire
import RxSwift
import Kingfisher
class ViewController: UIViewController {
 
    let viewModel = ListViewModel()
    @IBOutlet var cartBtn: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()

    }
    override func viewWillAppear(_ animated: Bool) {
        //Sepetten geri dönüş yapıldığında güncelleme.
        viewModel.getData()
    }
    func initViewModel(){
        
        viewModel.reloadCollectionView = {
            DispatchQueue.main.async { self.collectionView.reloadData() }
        }
        viewModel.showError = {
            DispatchQueue.main.async { self.showAlert("Ops, something went wrong.") }
        }
        viewModel.showLoading = {
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
                self.activityIndicator.isHidden = false }
        }
        viewModel.hideLoading = {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true }
        }
        //Badge güncelleme
        viewModel.updateCartBadge = {
            DispatchQueue.main.async {
                BadgeView.shared.showBadge(btn: self.cartBtn, withCount: CartStoreManager.shared.carts.count)}
        }
 
    }
}
extension ViewController: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "custom_cell", for: indexPath) as? CustomCollectionCell else {
            fatalError("Cell not exists in storyboard")
        }
        
        let cellVM = viewModel.getCellViewModel( at: indexPath )
        cell.tag = cellVM.stock
        cell.lblName.text = cellVM.nameText
        cell.lblPrice.text = cellVM.priceText.description.appending(cellVM.currency)
        cell.imgView.kf.setImage(with: URL(string: cellVM.imgPath))
        cell.btnAdd.tag = indexPath.row
        cell.btnReduce.tag = indexPath.row
        cell.btnAdd.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        cell.btnReduce.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        //Sepete eklenilen ürünleri ana sayfadaki ürünler ile eşleştirme
        updateAmountCarts(id: cellVM.id, cell: cell)
        return cell
    }
    
    func updateAmountCarts(id: String, cell: CustomCollectionCell)
    {
        let count = CartStoreManager.shared.carts.filter({$0.id == id}).count
        let hidden = count == 0
        cell.lblStock.tag = count
        cell.btnReduce.isHidden = hidden
        cell.lblStock.isHidden = hidden
        cell.lblStock.text = !hidden ? count.description : 0.description
    }

}
