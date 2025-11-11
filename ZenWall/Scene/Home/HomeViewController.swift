//
//  ViewController.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 08.11.25.
//

import UIKit

final class HomeViewController: UIViewController {
    
    // MARK: - ViewModel
    private let viewModel = HomeViewModel()
    
    // MARK: - UI Elements
    private lazy var collectionView: UICollectionView = {
        let layout = HomeViewController.createLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        cv.register(HeaderCell.self, forCellWithReuseIdentifier: "HeaderCell")
        cv.register(WallpaperOfDayCell.self, forCellWithReuseIdentifier: "WallpaperOfDayCell")
        cv.register(WallpaperCell.self, forCellWithReuseIdentifier: "WallpaperCell")
        return cv
    }()
    
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
    private func setupGradientBackground() {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 0.06, green: 0.09, blue: 0.08, alpha: 1).cgColor,
            UIColor(red: 0.09, green: 0.12, blue: 0.10, alpha: 1).cgColor
        ]
        gradient.locations = [0.0, 1.0]
        gradient.frame = view.bounds
        
        let bgView = UIView(frame: view.bounds)
        bgView.layer.addSublayer(gradient)
        collectionView.backgroundView = bgView
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Binding
    private func bindViewModel() {
        viewModel.success = { [weak self] in
            self?.collectionView.reloadData()
        }
        
        viewModel.error = { errorMsg in
            print("Error: \(errorMsg)")
        }
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int { 3 }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0, 1: return 1
        default: return viewModel.photos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            return collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WallpaperOfDayCell", for: indexPath) as! WallpaperOfDayCell
            cell.configure(imageURL: "https://images.unsplash.com/photo-1507149833265-60c372daea22"
            )
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WallpaperCell", for: indexPath) as! WallpaperCell
            if let url = viewModel.photos[indexPath.row].urls?.regular {
                cell.configure(imageURL: url)
            }
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {}

extension HomeViewController {
    static func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            switch sectionIndex {
            case 0:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(110)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .estimated(110)
                    ),
                    subitems: [item]
                )
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: 0, leading: 16, bottom: 4, trailing: 16)
                return section
                
            case 1:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(200)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(200)
                    ),
                    subitems: [item]
                )
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: 8, leading: 16, bottom: 10, trailing: 16)
                return section
                
            default:
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
                section.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
                return section
            }
        }
    }
}
