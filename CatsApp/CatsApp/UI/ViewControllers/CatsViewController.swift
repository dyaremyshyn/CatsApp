//
//  CatsViewController.swift
//  CatsApp
//
//  Created by Dmytro Yaremyshyn on 01/09/2024.
//

import UIKit
import Combine

public class CatsViewController: UIViewController {

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
                print(message)
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
        title = viewModel?.title
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)

        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func createViewLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (index, env) -> NSCollectionLayoutSection? in
                        
            // Define the size for each item
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            // Set the spacing around each item
//            item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            
            // Define the group that contains three items horizontally
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(150)
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitem: item,
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

extension CatsViewController: FavoriteDelegate {
    func toggleFavorite(breed: CatBreed, isFavorite: Bool) {
        // viewModel.toggleFavorite
    }    
}
