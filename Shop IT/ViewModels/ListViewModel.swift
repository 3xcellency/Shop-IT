//
//  ListViewHolder.swift
//  Shop IT
//
//  Created by Ozan on 4.08.2022.
//

import Foundation
import RxSwift
class ListViewModel {
    
    let disposeBag = DisposeBag()
     var apiClient: APIClient
     var datas: [ShopModel] = [ShopModel]()
     var reloadCollectionView: (()->())?
     var showError: (()->())?
     var showLoading: (()->())?
     var hideLoading: (()->())?
     var updateCartBadge: (()->())?
    
    private var cellViewModels: [DataListCellViewModel] = [DataListCellViewModel]() {
        didSet {
            self.reloadCollectionView?()
        }
    }
     init() {
        apiClient = APIClient.init(restClient: RESTClient<APIRequest>.init())
     }
    //Ürünlerin listesini çekmek
    func getData(){
        showLoading?()
        apiClient.getList().subscribe { response in
            self.hideLoading?()
            self.createCell(datas: response)
            self.reloadCollectionView?()
            self.updateCartBadge?()
        } onFailure: { err in
            self.showError?()
            print(err)
        }.disposed(by: disposeBag)
    }
    //Hücre sayısı
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> DataListCellViewModel {
        return cellViewModels[indexPath.row]
    }
    func createCell(datas: [ShopModel]){
        self.datas = datas
        var vms = [DataListCellViewModel]()
        
        vms.append(contentsOf: datas.compactMap { data in
            return DataListCellViewModel(id: data.id, nameText: data.name, priceText: data.price, imgPath: data.imageUrl, stock: data.stock, currency: data.currency)
        })
        cellViewModels = vms
    }
 
    //Sepete ekle
    func addToCart(model: ShopModel)
    {
        CartStoreManager.shared.carts.append(model)
        updateCartBadge?()
    }
    //Sepetten çıkar
    func removeToCart(model: ShopModel)
    {
        let arrays = CartStoreManager.shared.carts
        guard let modelIndex = arrays.firstIndex(where: {$0.id == model.id}) else
        {
            return
        }
        CartStoreManager.shared.carts.remove(at: modelIndex)
        updateCartBadge?()
    }

}
struct DataListCellViewModel {
    let id: String
    let nameText: String
    let priceText: Double
    let imgPath: String
    let stock: Int
    let currency: String
}
