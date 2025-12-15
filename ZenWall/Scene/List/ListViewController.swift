//
//  ListViewController.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 14.11.25.
//

import UIKit

class ListViewController: BaseViewController {
    
    private lazy var collectionView: UICollectionView = {
        let layout = ListViewController.createLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        cv.register(WallpaperCell.self, forCellWithReuseIdentifier: "WallpaperCell")
        return cv
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        return rc
    }()
    
    private let viewModel: ListViewModel
    
    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        setupDefaultBar()
        setupCollectionView()
        bindViewModel()
        viewModel.fetchImages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    private func setupCollectionView() {
        title = viewModel.selectedTopicForUI
        view.addSubview(collectionView)
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func refreshData() {
        viewModel.refresh()
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
    
    private func bindViewModel() {
        viewModel.success = { [weak self] in
            self?.collectionView.reloadData()
            self?.refreshControl.endRefreshing()
        }
        
        viewModel.error = { errorMessage in
            print("Error: \(errorMessage)")
        }
    }
}

// MARK: - UICollectionViewDataSource
extension ListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "WallpaperCell",
            for: indexPath
        ) as! WallpaperCell
        
        let photo = viewModel.photos[indexPath.row]
        let photoId = photo.id ?? ""
        let imageURL = photo.urls?.regular ?? ""
        
        let isFavorite = viewModel.isFavorite(photoId: photoId)
        
        cell.configure(
            imageURL: imageURL,
            photoId: photoId,
            isFavorite: isFavorite
        )
        
        cell.onToggleFavorite = { [weak self] photoId, _, completion in
            self?.viewModel.toggleFavorite(photoId: photoId) { success in
                completion(success)
            }
        }
        cell.onDownload = { _ in
            self.saveImage(photo: photo)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let coordinator = WallpaperDetailsCoordinator(navigationController: navigationController ?? UINavigationController(), photo: viewModel.photos[indexPath.row])
        coordinator.start()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.pagination(index: indexPath.row)
    }
}

extension ListViewController {
    static func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { _, _ in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .absolute(260)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(260)
                ),
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 0, leading: 8, bottom: 8, trailing: 8)
            return section
        }
    }
}
