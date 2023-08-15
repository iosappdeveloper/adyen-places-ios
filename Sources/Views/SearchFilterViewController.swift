//
//  SearchFilterViewController.swift
//  PlacesUIKit
//
//  Created by Matoria, Ashok on 8/14/23.
//

import UIKit
import CoreLocation

final class SearchFilterViewController: UIViewController {
    private var tableView: UITableView = UITableView(frame: .zero, style: .plain)
    private var viewModel: SearchFilterViewModel
    
    init(_ viewModel: SearchFilterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.screenTitle
        setupSubviews()
        tableView.reloadData()
        
        viewModel.refreshUI = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.handleLocationAuthorizationStatus()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewModel.checkAndTriggerRefetch()
    }
}

extension SearchFilterViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 { // location
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.font = .preferredFont(forTextStyle: .body)
            cell.textLabel?.textColor = .label
            cell.textLabel?.text = NSLocalizedString("Current Location", comment: "Prompt user to select current location")
            cell.accessoryType = viewModel.showCurrentLocationCheck ? .checkmark : .none
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == 1 {    // radius
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RadiusTableViewCell.reusableIdentifier, for: indexPath) as? RadiusTableViewCell else { assertionFailure(); return UITableViewCell() }
            
            cell.configure(for: viewModel.currentRadius)
            cell.sliderActionHandler = { [weak self] currentRadius in
                self?.viewModel.update(currentRadius: currentRadius)
            }
            return cell
        } else {
            fatalError("Unexpected section, check and handle this")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            viewModel.handleLocationAuthorizationStatus()
        }
    }
}

private extension SearchFilterViewController {
    func setupSubviews() {
        let stackView = UIStackView(arrangedSubviews: [tableView])
        stackView.axis = .vertical
        UIUtils.addAndAnchorSubview(stackView, to: view)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(RadiusTableViewCell.self, forCellReuseIdentifier: RadiusTableViewCell.reusableIdentifier)
    }
}
