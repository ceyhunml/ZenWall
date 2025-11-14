//
//  WallpaperCell.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 09.11.25.
//

import UIKit

final class WallpaperCell: UICollectionViewCell {
    
    var onFavorite: (() -> Void)?
    var onDownload: (() -> Void)?
    
    private let imageView = UIImageView()
    private let favoriteButton = UIButton(type: .system)
    private let downloadButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        setupButtons()
    }
    
    private func setupButtons() {
        [favoriteButton, downloadButton].forEach {
            $0.tintColor = .white
            $0.backgroundColor = UIColor(white: 0.1, alpha: 0.5)
            $0.layer.cornerRadius = 16
            $0.translatesAutoresizingMaskIntoConstraints = false
            imageView.addSubview($0)
        }
        
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        downloadButton.setImage(UIImage(systemName: "arrow.down.circle"), for: .normal)
        
        NSLayoutConstraint.activate([
            favoriteButton.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 10),
            favoriteButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -10),
            favoriteButton.widthAnchor.constraint(equalToConstant: 32),
            favoriteButton.heightAnchor.constraint(equalToConstant: 32),
            
            downloadButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -10),
            downloadButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -10),
            downloadButton.widthAnchor.constraint(equalToConstant: 32),
            downloadButton.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
        downloadButton.addTarget(self, action: #selector(downloadTapped), for: .touchUpInside)
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - Configure
    func configure(imageURL: String) {
        imageView.setUnsplashImage(imageURL)
    }
    
    // MARK: - Actions
    @objc private func favoriteTapped() {
        onFavorite?()
    }
    
    @objc private func downloadTapped() {
        onDownload?()
    }
}
