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
        let constraintConstant: CGFloat = 5
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: constraintConstant),
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: constraintConstant),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -constraintConstant),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -constraintConstant)
        ])
    }
}
