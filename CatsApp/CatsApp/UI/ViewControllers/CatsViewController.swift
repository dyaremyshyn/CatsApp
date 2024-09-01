//
//  CatsViewController.swift
//  CatsApp
//
//  Created by Dmytro Yaremyshyn on 01/09/2024.
//

import UIKit
import Combine

public class CatsViewController: UIViewController {

    private let searchController = UISearchController(searchResultsController: nil)

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(CatViewCell.self, forCellWithReuseIdentifier: CatViewCell.reuseIdentifier)
        return collectionView
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, CatBreed>!
    
    private var cancellables = Set<AnyCancellable>()
    var viewModel: CatsViewModel? {
        didSet { bind() }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupDataSource()
        setupView()
        viewModel?.loadData()
    }

    private func bind() {
        viewModel?.$fetchedBreeds
            .receive(on: DispatchQueue.main)
            .sink { [weak self] breeds in
                guard let self, let breeds = breeds else { return }
                self.applySnapshot(breeds: breeds)
            }
            .store(in: &cancellables)
        
        viewModel?.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                guard let self, let message = errorMessage else { return }
                self.showError(message: message)
            }
            .store(in: &cancellables)
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, CatBreed>(collectionView: collectionView) { [weak self] (collectionView, indexPath, event) -> UICollectionViewCell? in
            guard let self, let model = viewModel?.fetchedBreeds?[indexPath.row] else { return nil }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CatViewCell.reuseIdentifier, for: indexPath) as! CatViewCell
            cell.configure(model: model)
            cell.delegate = self
            return cell
        }
        
        collectionView.dataSource = dataSource
    }

    private func setupView() {
        title = CatsPresenter.viewTitle
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        setupSearchController()
        
        // Set the delegate for the collection view
        collectionView.delegate = self
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func setupSearchController() {
        // Set the searchResultsUpdater to self
        searchController.searchResultsUpdater = self
        // Place the search bar in the navigation bar.
        navigationItem.searchController = searchController
        // Don't obscure the background when the user is searching
        searchController.obscuresBackgroundDuringPresentation = false
        // Customize the search bar placeholder
        searchController.searchBar.placeholder = CatsPresenter.searchPlaceholder
        // Ensure the search bar doesn't remain on the screen if the user navigates to another view controller while the UISearchController is active
        definesPresentationContext = true
    }
    
    private func createViewLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (index, env) -> NSCollectionLayoutSection? in
                        
            // Define the size for each item. Since we want 3 items per row,
            // the width of each item should be 1/3 of the group's width.
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0 / 3.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            // Define the group that contains three items horizontally
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(150)
            )
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                repeatingSubitem: item,
                count: 3
            )
            
            // Define the section that contains all groups
            let section = NSCollectionLayoutSection(group: group)
            
            // Space between each row
            section.interGroupSpacing = 10
            
            return section
        }
    }
    
    private func applySnapshot(breeds: BreedsResponse) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, CatBreed>()
        
        snapshot.appendSections([0])
        snapshot.appendItems(breeds, toSection: 0)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - Favorite Delegate
extension CatsViewController: FavoriteDelegate {
    
    func toggleFavorite(breed: CatBreed, isFavorite: Bool) {
        viewModel?.toggleFavorite(breed: breed, isFavorite: isFavorite)
    }
}

// MARK: - UISearchResultsUpdating
extension CatsViewController : UISearchResultsUpdating {
    
    public func updateSearchResults(for searchController: UISearchController) {
        viewModel?.search(for: searchController.searchBar.text)
    }
}

// MARK: - Error Handling
extension CatsViewController {
    
    private func showError(message: String) {
        self.showErrorDialog(
            title: CatsPresenter.errorDialogTitle,
            message: message,
            cancelTitle: CatsPresenter.cancelDialogTitle,
            actionTitle: CatsPresenter.retryDialogTitle,
            retryCompletion: viewModel?.loadData)
    }
}

// MARK: - UICollectionViewDelegate - didSelectItemAt
extension CatsViewController: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedBreed = viewModel?.fetchedBreeds?[indexPath.row] else { return }
        viewModel?.selected(breed: selectedBreed)
    }
}
