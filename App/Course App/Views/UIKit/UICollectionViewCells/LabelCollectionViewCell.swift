//
//  LabelCollectionViewCell.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 14.05.2024.
//

import UIKit

final class LabelCollectionViewCell: UICollectionViewCell, ReusableIdentifier {
    
    lazy var nameLabel = UILabel()
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension LabelCollectionViewCell {
    func setupUI() {
        addSubview()
        configureLabel()
        setupConstraints()
    }
    func addSubview() {
        addSubview(nameLabel)
    }
    func configureLabel() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = .white
    }
    func setupConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }
}
