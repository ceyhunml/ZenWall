//
//  CategoryCell.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 09.11.25.
//

import Foundation
import UIKit

final class CategoryCell: UICollectionViewCell {
    
    // MARK: - UI
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 16
        return iv
    }()
    
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        lbl.numberOfLines = 1
        
        lbl.layer.shadowColor = UIColor.black.cgColor
        lbl.layer.shadowOpacity = 0.6
        lbl.layer.shadowRadius = 2
        lbl.layer.shadowOffset = CGSize(width: 0, height: 1)
        return lbl
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = nil
    }
    
    func configure(title: String, cover: String) {
        titleLabel.text = title
        imageView.setUnsplashImage(cover)
    }
}
