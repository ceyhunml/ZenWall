//
//  FavoritesViewController.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 13.12.25.
//

import UIKit

class FavoritesViewController: BaseViewController {
    
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: CompositionalLayoutFactory.makeGridLayout())
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        cv.register(WallpaperCell.self, forCellWithReuseIdentifier: "WallpaperCell")
        return cv
    }()
    
    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "No favorite photos ❤️"
        label.textColor = UIColor(white: 1, alpha: 0.6)
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        return rc
    }()
    
    private let viewModel = FavoritesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupCollectionView() {
        title = "Favorites"
        navigationItem.largeTitleDisplayMode = .always
        view.addSubview(collectionView)
        view.addSubview(emptyLabel)
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    func loadData() {
        viewModel.success = { [weak self] in
            guard let self else { return }

            self.collectionView.reloadData()
            self.refreshControl.endRefreshing()
            self.updateEmptyState()
        }

        viewModel.error = { message in
            print("Error:", message)
        }

        viewModel.getFavorites()
    }
    
    @objc private func refreshData() {
        viewModel.getFavorites()
    }
    
    private func updateEmptyState() {
        let isEmpty = viewModel.favoritePhotos.isEmpty
        emptyLabel.isHidden = !isEmpty
    }
    
    private func saveImage(photo: UnsplashPhoto) {
        guard let url = photo.urls?.full
        else { return }
        
        UIImage.downloadAndSave(from: url) { [weak self] result in
            guard let self else { return }
            
            let (title, message): (String, String)
            
            switch result {
            case .success:
                title = "Success"
                message = "Photo added to your library!"
                
            case .denied:
                title = "Permission Denied"
                message = "Please allow access to your Photo Library."
                
            case .invalidURL:
                title = "Invalid URL"
                message = "Something went wrong. The image URL is invalid."
                
            case .downloadFailed:
                title = "Download Failed"
                message = "Could not download photo. Please try again."
                
            case .saveFailed:
                title = "Error"
                message = "Failed to save image to your gallery."
            }
            
            self.alertFor(title: title, message: message)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.favoritePhotos.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "WallpaperCell",
            for: indexPath
        ) as! WallpaperCell
        
        let photo = viewModel.favoritePhotos[indexPath.item]
        let isFavorite = viewModel.isFavorite(id: photo.id ?? "")
        
        cell.configure(
            imageURL: photo.urls?.regular ?? "",
            photoId: photo.id ?? "",
            isFavorite: isFavorite
        )
        
        cell.onToggleFavorite = { [weak self] photoId, newState, completion in
            self?.viewModel.toggleFavorite(id: photoId) { success in
                completion(success)
            }
        }
        cell.onDownload = { _ in
            self.saveImage(photo: photo)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return
        }
        let coordinator = WallpaperDetailsCoordinator(
            navigationController: navigationController!,
            photo: viewModel.favoritePhotos[indexPath.row],
            sourceCell: cell
        )
        coordinator.start()
    }
}
