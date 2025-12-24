//
//  ViewController.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 08.11.25.
//

import UIKit

final class HomeViewController: BaseViewController {
    
    // MARK: - UI Elements
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: CompositionalLayoutFactory.makeHomeLayout())
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        cv.register(HeaderCell.self, forCellWithReuseIdentifier: "HeaderCell")
        cv.register(WallpaperOfDayCell.self, forCellWithReuseIdentifier: "WallpaperOfDayCell")
        cv.register(WallpaperCell.self, forCellWithReuseIdentifier: "WallpaperCell")
        return cv
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.tintColor = .white
        return rc
    }()
    
    private let viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupCollectionView()
        bindViewModel()
        viewModel.fetchRandomPhotos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - Setup
    private func setupCollectionView() {
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
        let indexPath = IndexPath(item: 0, section: 0)
        if let headerCell = collectionView.cellForItem(at: indexPath) as? HeaderCell {
            headerCell.resetSearch()
        }
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
    
    // MARK: - Binding
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
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0, 1: return 1
        default: return viewModel.photos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
            
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
            cell.onSearch = { [weak self] query in
                guard let self else { return }
                if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    self.viewModel.fetchRandomPhotos()
                } else {
                    self.viewModel.searchPhotos(query: query)
                }
            }
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WallpaperOfDayCell", for: indexPath) as! WallpaperOfDayCell
            if indexPath.row < viewModel.photos.count {
                let url = viewModel.photoOfDay?.urls?.regular ?? ""
                cell.configure(imageURL: url)
            }
            return cell
            
        default:
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
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "HeaderCell",
            for: indexPath
        ) as! HeaderCell
        
        header.onSearch = { [weak self] query in
            guard let self else { return }
            
            if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                self.viewModel.fetchRandomPhotos()
            } else {
                self.viewModel.searchPhotos(query: query)
            }
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath),
              let photoOfDay = viewModel.photoOfDay else { return }
        if indexPath.section != 0 {
            let coordinator = WallpaperDetailsCoordinator(
                navigationController: navigationController!,
                photo: indexPath.section == 1 ? photoOfDay : viewModel.photos[indexPath.row],
                sourceCell: cell
            )
            coordinator.start()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.pagination(index: indexPath.row)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}
