//
//  WallpaperDetailsViewController.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 12.11.25.
//

import UIKit

import UIKit

final class WallpaperDetailsViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: WallpaperDetailsViewModel
    private var isFullScreen = false
    
    // MARK: - Init
    init(viewModel: WallpaperDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Elements
    private let wallpaperImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 20
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private let containerView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Download Wallpaper"
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose your preferred option."
        label.textColor = UIColor(white: 1, alpha: 0.7)
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let fullButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Download Full Size", for: .normal)
        button.backgroundColor = UIColor(white: 1, alpha: 0.2)
        button.layer.cornerRadius = 12
        button.tintColor = .white
        return button
    }()
    
    private let fitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Download Fit to Screen", for: .normal)
        button.backgroundColor = UIColor(white: 1, alpha: 0.1)
        button.layer.cornerRadius = 12
        button.tintColor = UIColor(white: 1, alpha: 0.7)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        setupTapGesture()
        viewModel.fetchImage()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.1, green: 0.18, blue: 0.15, alpha: 1)
        
        view.addSubview(wallpaperImageView)
        view.addSubview(containerView)
        [titleLabel, subtitleLabel, fullButton, fitButton].forEach { containerView.addSubview($0) }
        
        wallpaperImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        [titleLabel, subtitleLabel, fullButton, fitButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            wallpaperImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            wallpaperImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            wallpaperImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            wallpaperImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            
            containerView.topAnchor.constraint(equalTo: wallpaperImageView.bottomAnchor, constant: 24),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            fullButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 16),
            fullButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            fullButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            fullButton.heightAnchor.constraint(equalToConstant: 50),
            
            fitButton.topAnchor.constraint(equalTo: fullButton.bottomAnchor, constant: 12),
            fitButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            fitButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            fitButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupBindings() {
        viewModel.onImageLoaded = { [weak self] image in
            self?.wallpaperImageView.image = image
        }
    }
    
    private func setupTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(toggleFullScreen))
        wallpaperImageView.addGestureRecognizer(tap)
    }
    
    @objc private func toggleFullScreen() {
        isFullScreen.toggle()
        
        UIView.animate(withDuration: 0.3, animations: {
            self.containerView.alpha = self.isFullScreen ? 0 : 1
            self.wallpaperImageView.layer.cornerRadius = self.isFullScreen ? 0 : 20
            self.wallpaperImageView.contentMode = self.isFullScreen ? .scaleAspectFit : .scaleAspectFill
        })
    }
}
