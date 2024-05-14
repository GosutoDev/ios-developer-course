//
//  ImageCollectionViewCell.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 14.05.2024.
//

import UIKit

final class ImageCollectionViewCell: UICollectionViewCell, ReusableIdentifier {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ImageCollectionViewCell {
    func setupUI() {
        addSubview()
        setupConstraints()
    }
    func addSubview() {
        addSubview(imageView)
    }
    func setupConstraints() {
        let constraintConstant: CGFloat = 5
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: constraintConstant),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: constraintConstant),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -constraintConstant),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -constraintConstant)
        ])
    }
}
