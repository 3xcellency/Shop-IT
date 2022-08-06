//
//  CartViewModel.swift
//  Shop IT
//
//  Created by Ozan on 6.08.2022.
//

import Foundation
import RxSwift
class CartViewModel
{
    let disposeBag = DisposeBag()
    var apiClient: APIClient
   
    var datas: [ShopModel] = [ShopModel]()
    var reloadTableView: (()->())?
    var showError: ((_ err: String)->())?
    var updateTotalPrice: ((_ price: String)->())?
    var completeCart: ((_ price: String)->())?
    
    init() {
        apiClient = APIClient.init(restClient: RESTClient<APIRequest>.init())
    }
    private var cellViewModels: [CartListCellViewModel] = [CartListCellViewModel]() {
        didSet {
            self.reloadTableView?()
        }
    }
    //Sepetteki ürünleri çek ve hücreler ile eşleştir.
    func getData(){
        self.createCell(datas: CartStoreManager.shared.carts)
        self.reloadTableView?()
        self.calculateTotalPrice()
    }
    //Hücre sayısı
    var numberOfCells: Int {
        return cellViewModels.count
    }

    func getCellViewModel( at indexPath: IndexPath ) -> CartListCellViewModel {
        return cellViewModels[indexPath.row]
    }
    func createCell(datas: [ShopModel]){
        self.datas = datas
        var vms = [CartListCellViewModel]()
        let cartArray = CartStoreManager.shared.carts
        let array =  Set(cartArray.map { model -> CartModel in
            let amount = cartArray.filter({$0.id == model.id}).count
            return CartModel(id: model.id, amount: amount)
        })
        vms.append(contentsOf: array.compactMap { model in
            guard let shopModel = datas.filter({$0.id == model.id}).first else
            {
                fatalError("Doesnt work well.")
            }
            return CartListCellViewModel(id: model.id, nameText: shopModel.name, priceText: shopModel.price, imgPath: shopModel.imageUrl, stock: shopModel.stock, amount: model.amount, currency: shopModel.currency)
        })
        //Sepetteki ürünleri id'sine göre sırala.
        cellViewModels = vms.sorted(by: {$0.id > $1.id})
    }
    //Toplam fiyatı hesaplama ve güncelleme
    func calculateTotalPrice()
    {
       let totalPrice = cellViewModels
            .lazy
            .compactMap { (Double($0.amount) * $0.priceText) }
            .reduce(0, +)
        self.updateTotalPrice?(String(format: "%.2f", totalPrice).appending("₺"))
    }
    //Sepetteki ürünlerin servise gönderimi
    func completeShop()
    {
        let cartArray = CartStoreManager.shared.carts
        let array =  Set(cartArray.map { model -> CartModel in
            let amount = cartArray.filter({$0.id == model.id}).count
            return CartModel(id: model.id, amount: amount)
        })
        
        apiClient.complete(models: Array(array)).subscribe { response in
            self.completeCart?(response.result)
            CartStoreManager.shared.carts.removeAll()
            self.getData()
        } onFailure: { err in
            self.showError?(err.localizedDescription)
        }.disposed(by: disposeBag)

    }
    //Sepetteki tüm ürünleri silmek
    func wipeAllCart()
    {
        CartStoreManager.shared.carts.removeAll()
        getData()
    }
    //Sepetteki tek ürünü silebilme
    func deleteItem(indexPath: IndexPath)
    {
        let cellVM = getCellViewModel( at: indexPath )
        CartStoreManager.shared.carts.removeAll(where: {$0.id == cellVM.id})
        getData()
    }
    //Sepetteki ürünün miktarını arttırma
    func addToCart(index: Int)
    {
        let id = cellViewModels[index].id
        guard let firstModel = CartStoreManager.shared.carts.first(where: {$0.id == id}) else {
            return
        }
        CartStoreManager.shared.carts.append(firstModel)
        getData()
    }
    //Sepetteki ürünün miktarını azaltma
    func removeToCart(index: Int)
    {
        let id = cellViewModels[index].id
        guard let firstIndex = CartStoreManager.shared.carts.firstIndex(where: {$0.id == id}) else {
            return
        }
        CartStoreManager.shared.carts.remove(at: firstIndex)
        getData()
    }
}
struct CartListCellViewModel {
    let id: String
    let nameText: String
    let priceText: Double
    let imgPath: String
    let stock: Int
    let amount: Int
    let currency: String
}

