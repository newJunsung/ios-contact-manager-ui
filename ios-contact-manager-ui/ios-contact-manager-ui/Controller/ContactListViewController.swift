//
//  ViewController.swift
//  ios-contact-manager-ui
//
//  Created by 김준성 on 2023/10/04.
//

import UIKit

final class ContactListViewController: UIViewController {
    private let contactManager = ContactManager(contactRepository: ContactRepository())
    private let presenter: CellPresenter = ContactCellPresenter()
    private var contacts: [Contact]!
    private var searchController: UISearchController!
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 5...20 {
                    try! contactManager.create(Contact(name: "1\(i)", age: i, phoneNumber: "111-23123-23123"))
                }
        
        contacts = contactManager.readContactsByName()
        
        configureNavigationBar()
        configureTableView()
        observeUpdatedContacts()
        configureSearchBar()
    }
    
    private func configureNavigationBar() {
        self.navigationItem.title = "연락처"
        self.navigationItem.rightBarButtonItem = buildAddButton()
    }
    
    private func configureTableView() {
        tableView.register(UINib(nibName: ContactCell.reuseID, bundle: nil), forCellReuseIdentifier: ContactCell.reuseID)
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func buildAddButton() -> UIBarButtonItem {
        let addButton = UIBarButtonItem(systemItem: .add)
        addButton.target = self
        addButton.action = #selector(tapAddButton(_:))
        return addButton
    }
    
    @objc private func tapAddButton(_ sender: UIButton) {
        if let viewController = storyboard?.instantiateViewController(identifier: EditContactViewController.reuseID, creator: { coder in
            return EditContactViewController(coder: coder, contactValidityChecker: ContactValidityChecker(), contactManager: self.contactManager)
        }) {
            present(UINavigationController(rootViewController: viewController), animated: true)
        }
    }
    
    @objc private func reloadContacts(_ notification: Notification) {
        contacts = self.contactManager.readContactsByName()
        self.tableView.reloadData()
    }
    
    
    private func observeUpdatedContacts() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadContacts(_:)), name: Notification.didUpdateContact, object: nil)
    }
    
    private func configureSearchBar() {
        guard let filteredViewController = storyboard?.instantiateViewController(identifier: FilteredContactListViewController.reuseID, creator: { coder in
            return FilteredContactListViewController(coder: coder, contactManager: self.contactManager, presenter: self.presenter)
        }) else {
            return
        }
        
        searchController = UISearchController(searchResultsController: filteredViewController)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
}

extension ContactListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contact = contacts[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactCell.reuseID, for: indexPath)
        
        presenter.setCell(cell)
        presenter.formatContent(contact)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                try contactManager.delete(contacts[indexPath.row])
                contacts.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch {
                return
            }
        }
    }
}

extension ContactListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text{
            guard let viewController = searchController.searchResultsController as? FilteredContactListViewController else {
                return
            }
            
            viewController.setFilteredContacts(contactManager.readFilteredContact(by: {
                $0.name.localizedCaseInsensitiveContains(text)
            }))
            viewController.tableView.reloadData()
        }
    }
}
