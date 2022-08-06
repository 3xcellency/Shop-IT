//
//  CartTableViewCell.swift
//  Shop IT
//
//  Created by Ozan on 6.08.2022.
//

import Foundation
import UIKit

class CartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnReduce: UIButton!
    @IBOutlet weak var imgView: UIImageView!
}
