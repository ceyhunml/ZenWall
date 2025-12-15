//
//  FavoritesViewController.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 13.12.25.
//

import UIKit

class FavoritesViewController: BaseViewController {
    
    private lazy var collectionView: UICollectionView = {
        let layout = FavoritesViewController.createLayout()
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
    
    private let viewModel = FavoritesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.getFavorites()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        collectionView.setContentOffset(.zero, animated: false)
    }
    
    private func setupCollectionView() {
        title = "Favorites"
        navigationItem.largeTitleDisplayMode = .always
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
    
    func loadData() {
        viewModel.success = { [weak self] in
            self?.collectionView.reloadData()
            self?.refreshControl.endRefreshing()
        }
        viewModel.error = { message in
            print("Error:", message)
        }
        viewModel.getFavorites()
    }
    
    @objc func refreshData() {
        viewModel.getFavorites()
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

            return cell
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let coordinator = WallpaperDetailsCoordinator(navigationController: navigationController ?? UINavigationController(), photo: viewModel.favoritePhotos[indexPath.row])
        coordinator.start()
    }
}

extension FavoritesViewController {
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
