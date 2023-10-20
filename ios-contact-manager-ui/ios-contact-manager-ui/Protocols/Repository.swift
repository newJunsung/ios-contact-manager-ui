//
//  Repository.swift
//  ios-contact-manager-ui
//
//  Created by 김준성 on 10/20/23.
//

import Foundation

protocol Repository {
    func create(_ contact: Contact) throws
    func read(by: (Contact, Contact) -> Bool) -> [Contact]
    func read(filteredBy: (Contact) -> Bool) -> [Contact]
    func update(_ oldContact: Contact, to newContact: Contact) throws
    func delete(_ contact: Contact) throws
}
