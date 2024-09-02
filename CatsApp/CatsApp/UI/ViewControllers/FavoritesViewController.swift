//
//  FavoritesViewController.swift
//  CatsApp
//
//  Created by Dmytro Yaremyshyn on 02/09/2024.
//

import UIKit
import Combine

public class FavoritesViewController: UIViewController {

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(CatViewCell.self, forCellWithReuseIdentifier: CatViewCell.reuseIdentifier)
        collectionView.register(LifespanViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: LifespanViewCell.reuseIdentifier)
        return collectionView
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, CatBreed>!
    
    private var cancellables = Set<AnyCancellable>()
    var viewModel: FavoritesViewModel? {
        didSet { bind() }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupDataSource()
        setupView()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.loadData()
    }

    private func bind() {
        viewModel?.$favoriteBreeds
            .receive(on: DispatchQueue.main)
            .sink { [weak self] breeds in
                guard let self, let breeds = breeds else { return }
                self.applySnapshot(breeds: breeds)
            }
            .store(in: &cancellables)
        
        viewModel?.$averageLifeSpan
            .receive(on: DispatchQueue.main)
            .sink { [weak self] lifespan in
                guard let self, let lifespan = lifespan else { return }
                self.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, CatBreed>(collectionView: collectionView) { [weak self] (collectionView, indexPath, event) -> UICollectionViewCell? in
            guard let self, let model = viewModel?.favoriteBreeds?[indexPath.row] else { return nil }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CatViewCell.reuseIdentifier, for: indexPath) as! CatViewCell
            cell.configure(model: model)
            cell.delegate = self
            return cell
        }
        
        dataSource.supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) -> UICollectionReusableView? in
            guard let self = self else { return nil }
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LifespanViewCell.reuseIdentifier, for: indexPath) as! LifespanViewCell
            header.configure(with: self.viewModel?.averageLifeSpan)
            return header
        }
        
        collectionView.dataSource = dataSource
    }

    private func setupView() {
        title = "Favorites"
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
                
        // Set the delegate for the collection view
        collectionView.delegate = self
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
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
                    
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(60)
            )
            
            // Define the header section that contains the average lifespan information
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            
            section.boundarySupplementaryItems = [sectionHeader]
            
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
extension FavoritesViewController: FavoriteDelegate {
    
    func toggleFavorite(breed: CatBreed, isFavorite: Bool) {
        viewModel?.toggleFavorite(breed: breed, isFavorite: isFavorite)
    }
}

// MARK: - UICollectionViewDelegate - didSelectItemAt
extension FavoritesViewController: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedBreed = viewModel?.favoriteBreeds?[indexPath.row] else { return }
        viewModel?.selected(breed: selectedBreed)
    }
}
