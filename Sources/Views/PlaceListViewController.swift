//
//  PlaceListViewController.swift
//  PlacesUIKit
//

import UIKit
import Combine

final class PlaceListViewController: UIViewController {
    private var tableView: UITableView = UITableView(frame: .zero, style: .plain)
    private let viewModel = PlaceListViewModel()
    private var anyCancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.screenTitle
        setupSubviews()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearchAction))
        
        viewModel.$places.receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.refreshUI()
            }
            .store(in: &anyCancellables)
        
        viewModel.$error.receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.refreshUI()
            }
            .store(in: &anyCancellables)
        
        viewModel.fetchPlaces()
    }
    
    func refreshUI() {
        tableView.reloadData()
        if let errorMessage = viewModel.error?.localizedDescription {
            UIUtils.showAlert(title: "", message: errorMessage, okTitle: viewModel.retryButtonTitle, okAction: { _ in
                self.viewModel.fetchPlaces()
            }, cancelTitle: viewModel.cancelButtonTitle)
        }
    }
}

extension PlaceListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlaceTableViewCell.reusableIdentifier, for: indexPath) as? PlaceTableViewCell else { assertionFailure(); return UITableViewCell() }
        let place = viewModel.places[indexPath.row]
        cell.configure(for: place)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.mapsURL(for: indexPath) { url in
            if UIApplication.shared.canOpenURL(url) {
                // Should confirm with user before opening this link outside the app
                UIApplication.shared.open(url)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

private extension PlaceListViewController {
    @objc func handleSearchAction() {
        let searchFilterViewModel = SearchFilterViewModel(triggerRefetchBlock: { [weak self] in
            self?.viewModel.fetchPlaces()
        })
        let searchFilterVC = SearchFilterViewController(searchFilterViewModel)
        let searchNav = UINavigationController(rootViewController: searchFilterVC)
        searchNav.modalPresentationStyle = .pageSheet
        if let sheet = searchNav.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }
        present(searchNav, animated: true)
        
        
    }
    
    func setupSubviews() {
        tableView.dataSource = self
        tableView.delegate = self
        UIUtils.addAndAnchorSubview(tableView, to: view)
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.register(PlaceTableViewCell.self, forCellReuseIdentifier: PlaceTableViewCell.reusableIdentifier)
    }    
}
