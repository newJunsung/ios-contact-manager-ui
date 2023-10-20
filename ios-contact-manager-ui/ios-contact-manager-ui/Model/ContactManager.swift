//
//  ContactManager.swift
//  ios-contact-manager-ui
//
//  Created by 김준성 on 2023/10/10.
//

import Foundation

final class ContactManager {
    private let contactRepository: Repository
    
    init(contactRepository: Repository) {
        self.contactRepository = contactRepository
    }
    
    func create(_ contact: Contact) throws {
        try contactRepository.create(contact)
    }
    
    func readContactsByName() -> [Contact] {
        return contactRepository.read { $0.name < $1.name }
    }
    
    func readFilteredContact(by contain: (Contact) -> Bool) -> [Contact] {
        return contactRepository.read(filteredBy: contain)
    }
    
    func update(_ oldContact: Contact, to newContact: Contact) throws {
        try contactRepository.update(oldContact, to: newContact)
    }
    
    func delete(_ contact: Contact) throws {
        try contactRepository.delete(contact)
    }
}
