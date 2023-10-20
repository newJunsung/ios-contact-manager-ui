//
//  FilteredContactListViewController.swift
//  ios-contact-manager-ui
//
//  Created by 김준성 on 10/18/23.
//

import UIKit

class FilteredContactListViewController: UITableViewController {
    private(set) var filteredContacts = [Contact]()
    private weak var contactManager: ContactManager?
    private weak var presenter: CellPresenter?
    
    init?(coder: NSCoder, contactManager: ContactManager, presenter: CellPresenter) {
        self.contactManager = contactManager
        self.presenter = presenter
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: ContactCell.reuseID, bundle: nil), forCellReuseIdentifier: ContactCell.reuseID)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredContacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactCell.reuseID, for: indexPath)
        presenter?.setCell(cell)
        presenter?.formatContent(filteredContacts[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                try contactManager?.delete(filteredContacts[indexPath.row])
                filteredContacts.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                NotificationCenter.default.post(name: Notification.didUpdateContact, object: nil)
            } catch {
                return
            }
        }
    }
    
    func setFilteredContacts(_ contacts: [Contact]) {
        filteredContacts = contacts
    }
}


