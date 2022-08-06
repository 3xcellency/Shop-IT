//
//  BadgeView.swift
//  Shop IT
//
//  Created by Ozan on 5.08.2022.
//

import Foundation
import UIKit

class BadgeView {
    let badgeSize: CGFloat = 18
    let badgeTag = 1881
    public static var shared = BadgeView()
    func badgeLabel(withCount count: Int) -> UILabel {
        let badgeCount = UILabel(frame: CGRect(x: 0, y: 0, width: badgeSize, height: badgeSize))
        badgeCount.translatesAutoresizingMaskIntoConstraints = false
        badgeCount.tag = badgeTag
        badgeCount.layer.cornerRadius = badgeCount.bounds.size.height / 2
        badgeCount.textAlignment = .center
        badgeCount.layer.masksToBounds = true
        badgeCount.textColor = .white
        badgeCount.font = badgeCount.font.withSize(12)
        badgeCount.backgroundColor = .systemRed
        badgeCount.text = count.description
        return badgeCount
    }
    func showBadge(btn: UIButton, withCount count: Int) {
        removeBadge(btn: btn)
        guard count != 0 else {
            return
        }
        let badge = badgeLabel(withCount: count)
        btn.addSubview(badge)
        NSLayoutConstraint.activate([
            badge.leftAnchor.constraint(equalTo: btn.leftAnchor, constant: 20),
            badge.topAnchor.constraint(equalTo: btn.topAnchor, constant: -5),
            badge.widthAnchor.constraint(equalToConstant: badgeSize),
            badge.heightAnchor.constraint(equalToConstant: badgeSize)
        ])
    }
    func removeBadge(btn: UIButton) {
        if let badge = btn.viewWithTag(badgeTag) {
            badge.removeFromSuperview()
        }
    }
}
