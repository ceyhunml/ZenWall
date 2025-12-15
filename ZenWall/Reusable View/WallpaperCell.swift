//
//  WallpaperCell.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 09.11.25.
//

import UIKit

final class WallpaperCell: UICollectionViewCell {
    
    // MARK: - UI
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 16
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private lazy var favoriteButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.tintColor = .white
        btn.backgroundColor = UIColor(white: 0.1, alpha: 0.6)
        btn.layer.cornerRadius = 16
        btn.setImage(UIImage(systemName: "heart"), for: .normal)
        btn.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)
        btn.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        return btn
    }()
    
    private lazy var downloadButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.tintColor = .white
        btn.backgroundColor = UIColor(white: 0.1, alpha: 0.6)
        btn.layer.cornerRadius = 16
        btn.setImage(UIImage(systemName: "arrow.down.to.line"), for: .normal)
        btn.addTarget(self, action: #selector(downloadTapped), for: .touchUpInside)
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)
        btn.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        return btn
    }()
    
    // MARK: - State
    private var isFavorite: Bool = false
    private var photoId: String?
    
    // MARK: - Callbacks
    var onToggleFavorite: ((String, Bool, @escaping (Bool) -> Void) -> Void)?
    var onDownload: ((String) -> Void)?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        contentView.addSubview(imageView)
        imageView.addSubview(favoriteButton)
        imageView.addSubview(downloadButton)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            favoriteButton.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 10),
            favoriteButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -10),
            favoriteButton.widthAnchor.constraint(equalToConstant: 32),
            favoriteButton.heightAnchor.constraint(equalToConstant: 32),
            
            downloadButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -10),
            downloadButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -10),
            downloadButton.widthAnchor.constraint(equalToConstant: 32),
            downloadButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    // MARK: - Configure
    func configure(
        imageURL: String,
        photoId: String,
        isFavorite: Bool
    ) {
        self.photoId = photoId
        self.isFavorite = isFavorite
        
        imageView.setUnsplashImage(imageURL)
        updateFavoriteIcon()
    }
    
    // MARK: - Actions
    @objc private func favoriteTapped() {
        guard let photoId else { return }
        
        let previousState = isFavorite
        let newState = !previousState
        
        isFavorite = newState
        updateFavoriteIcon()
        
        onToggleFavorite?(photoId, newState) { [weak self] success in
            guard let self else { return }
            if !success {
                self.isFavorite = previousState
                self.updateFavoriteIcon()
            }
        }
    }
    
    @objc private func downloadTapped() {
        guard let photoId else { return }
        onDownload?(photoId)
    }
    
    private func updateFavoriteIcon() {
        let imageName = isFavorite ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    // MARK: - Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        photoId = nil
        isFavorite = false
    }
}
