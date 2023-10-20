//
//  ContactRepository.swift
//  ios-contact-manager-ui
//
//  Created by 김준성 on 10/20/23.
//

import Foundation

class ContactRepository: Repository {
    private(set) var contacts = [UUID: Contact]()

    func create(_ contact: Contact) throws {
        if let exsistContact = contacts[contact.uuid] {
            throw ContactException.contactAlreadyExsist(contact: exsistContact)
        }
        
        contacts[contact.uuid] = contact
    }
    
    func read(by compare: (Contact, Contact) -> Bool) -> [Contact] {
        return contacts.values.sorted(by: compare)
    }
    
    func read(filteredBy: (Contact) -> Bool) -> [Contact] {
        return contacts.values.filter(filteredBy)
    }
    
    func update(_ oldContact: Contact, to newContact: Contact) throws {
        guard let oldContact = contacts.removeValue(forKey: oldContact.uuid) else {
            throw ContactException.contactNotFound(contact: oldContact)
        }
        
        if oldContact.uuid == newContact.uuid {
            contacts[oldContact.uuid] = newContact
        } else {
            contacts[newContact.uuid] = newContact
        }
    }
    
    func delete(_ contact: Contact) throws {
        guard let _ = contacts.removeValue(forKey: contact.uuid) else {
            throw ContactException.contactNotFound(contact: contact)
        }
    }
}
