//
//  CatViewCell.swift
//  CatsApp
//
//  Created by Dmytro Yaremyshyn on 01/09/2024.
//

import UIKit

class CatViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: CatViewCell.self)
    
    public weak var delegate: FavoriteDelegate?
    private var model: CatBreed!
    
    private var starImage: UIImage {
        UIImage(systemName: "star")?.withRenderingMode(.alwaysTemplate) ?? UIImage()
    }
    
    private var starFillImage: UIImage {
        UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysTemplate) ?? UIImage()
    }
        
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        button.setBackgroundImage(starImage, for: .normal)
        button.tintColor = .systemYellow
        return button
    }()
    
    private lazy var breedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "cat")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .darkGray
        return imageView
    }()
    
    private lazy var breedNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .caption1)
        return label
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [breedImageView, breedNameLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 15
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        breedNameLabel.text = ""
        breedImageView.image = UIImage(systemName: "cat")
    }
    
    private func setupView() {
        contentView.addSubview(verticalStackView)
        contentView.addSubview(favoriteButton)
        
        verticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5).isActive = true
        verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
        verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        
        favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        favoriteButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        favoriteButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        breedImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        breedImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    public func configure(model: CatBreed) {
        self.model = model
        breedNameLabel.text = model.name
    }
}
    
extension CatViewCell {
    @objc private func favoriteButtonTapped() {
        // Visual part
        let isFavorite = favoriteButton.currentBackgroundImage == starFillImage
        favoriteButton.setBackgroundImage(isFavorite ? starImage : starFillImage, for: .normal)
        
        // Toggle favorite and send it back to VC to sort
        delegate?.toggleFavorite(breed: model, isFavorite: isFavorite)
    }
}
