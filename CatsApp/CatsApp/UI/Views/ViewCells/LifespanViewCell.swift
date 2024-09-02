//
//  LifespanViewCell.swift
//  CatsApp
//
//  Created by Dmytro Yaremyshyn on 02/09/2024.
//

import UIKit

class LifespanViewCell: UICollectionReusableView {
    static let reuseIdentifier = String(describing: LifespanViewCell.self)
    
    private lazy var lifespanLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        self.backgroundColor = .systemBackground
        addSubview(lifespanLabel)
        
        lifespanLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        lifespanLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        lifespanLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        lifespanLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15).isActive = true
    }
    
    public func configure(with text: String?) {
        lifespanLabel.text = text
    }
}

