//
//  ReuseIdentyFiable.swift
//  ios-contact-manager-ui
//
//  Created by BOMBSGIE on 2023/10/20.
//

import Foundation

protocol ReuseIdentiFiable {
    static var reuseID: String { get }
}

extension ReuseIdentiFiable {
    static var reuseID: String {
        String(describing: self)
    }
}
