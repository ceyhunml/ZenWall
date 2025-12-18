//
//  WallpaperDetailsViewController.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 12.11.25.
//

import UIKit

final class WallpaperDetailsViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - UI Elements
    private lazy var backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isOpaque = true
        iv.backgroundColor = .clear
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var blurView: UIVisualEffectView = {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blur.alpha = 0.9
        return blur
    }()
    
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.delegate = self
        sv.minimumZoomScale = 1.0
        sv.maximumZoomScale = 3.0
        sv.showsVerticalScrollIndicator = false
        sv.showsHorizontalScrollIndicator = false
        sv.clipsToBounds = true
        sv.layer.masksToBounds = true
        sv.isOpaque = true
        sv.backgroundColor = .clear
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private lazy var panToDismissGesture: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanToDismiss(_:)))
        pan.delegate = self
        return pan
    }()
    
    private lazy var wallpaperImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.isOpaque = true
        iv.backgroundColor = .clear
        iv.layer.allowsEdgeAntialiasing = true
        iv.layer.contentsScale = UIScreen.main.scale
        return iv
    }()
    
    private lazy var containerView: UIView = {
        let v = UIView()
        return v
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Download Wallpaper"
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose your preferred option."
        label.textColor = UIColor(white: 1, alpha: 0.7)
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var fullButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Download Maximum Quality", for: .normal)
        btn.backgroundColor = UIColor(white: 1, alpha: 0.2)
        btn.layer.cornerRadius = 12
        btn.tintColor = .white
        return btn
    }()
    
    private lazy var lowButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Download Low Quality", for: .normal)
        btn.backgroundColor = UIColor(white: 1, alpha: 0.1)
        btn.layer.cornerRadius = 12
        btn.tintColor = UIColor(white: 1, alpha: 0.7)
        return btn
    }()
    
    private var scrollTopConstraint: NSLayoutConstraint!
    private var scrollLeadingConstraint: NSLayoutConstraint!
    private var scrollTrailingConstraint: NSLayoutConstraint!
    private var scrollHeightConstraint: NSLayoutConstraint!
    
    
    // MARK: - Properties
    private let viewModel: WallpaperDetailsViewModel
    private var isFullScreen = false
    private var shouldShowNavButtons = false
    
    // MARK: - Init
    init(viewModel: WallpaperDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        applyTransparentNavBar()
        setupUI()
        setupBindings()
        setupGestures()
        viewModel.loadImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        applyTransparentNavBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setupDefaultBar()
        navigationItem.rightBarButtonItem = nil
        shouldShowNavButtons = false
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .black
        setupFavoriteButton()
        fullButton.addTarget(self, action: #selector(saveFullImage), for: .touchUpInside)
        lowButton.addTarget(self, action: #selector(saveLowImage), for: .touchUpInside)
        
        [backgroundImageView, blurView, scrollView, containerView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        scrollView.addSubview(wallpaperImageView)
        [titleLabel, subtitleLabel, fullButton, lowButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
        }
        
        wallpaperImageView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollTopConstraint = scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8)
        scrollLeadingConstraint = scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        scrollTrailingConstraint = scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        scrollHeightConstraint = scrollView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.55)
        
        NSLayoutConstraint.activate([
            scrollTopConstraint,
            scrollLeadingConstraint,
            scrollTrailingConstraint,
            scrollHeightConstraint,
            
            wallpaperImageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            wallpaperImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            wallpaperImageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            wallpaperImageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            wallpaperImageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            wallpaperImageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            containerView.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 24),
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
            
            lowButton.topAnchor.constraint(equalTo: fullButton.bottomAnchor, constant: 12),
            lowButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            lowButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            lowButton.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -8),
            lowButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupFavoriteButton() {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "heart"),
            style: .plain,
            target: self,
            action: #selector(favoriteTapped)
        )
        button.tintColor = .white
        navigationItem.rightBarButtonItem = button
    }
    
    @objc private func favoriteTapped() {
        viewModel.toggleFavorite()
    }
    
    private func setupBindings() {
        viewModel.onImageURL = { [weak self] url in
            guard let self, let url else { return }
            self.wallpaperImageView.setUnsplashImage(url)
            self.backgroundImageView.setUnsplashImage(url)
        }
        viewModel.onFavoriteChanged = { [weak self] isFavorite in
            self?.updateFavoriteIcon(isFavorite)
        }
    }
    
    private func updateFavoriteIcon(_ isFavorite: Bool) {
        let name = isFavorite ? "heart.fill" : "heart"
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: name)
    }
    
    private func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleImageTap))
        wallpaperImageView.addGestureRecognizer(tap)
        scrollView.addGestureRecognizer(panToDismissGesture)
    }
    
    @objc private func handleImageTap() {
        if scrollView.zoomScale > 1.01 {
            scrollView.setZoomScale(1.0, animated: true)
            return
        }
        toggleFullScreen()
    }
    
    @objc private func handlePanToDismiss(_ gesture: UIPanGestureRecognizer) {
        guard isFullScreen else { return }
        guard scrollView.zoomScale <= 1.01 else { return }
        
        let translation = gesture.translation(in: view)
        let progress = max(0, translation.y / view.bounds.height)
        
        switch gesture.state {
        case .changed:
            guard translation.y > 0 else { return }
            
            scrollView.transform = CGAffineTransform(translationX: 0, y: translation.y * 0.8)
            
            view.backgroundColor = UIColor.black.withAlphaComponent(1 - progress * 0.8)
            
        case .ended, .cancelled:
            if progress > 0.20 {
                UIView.animate(withDuration: 0.25, animations: {
                    self.scrollView.transform = .identity
                }, completion: { _ in
                    self.toggleFullScreen()
                })
            } else {
                UIView.animate(withDuration: 0.25) {
                    self.scrollView.transform = .identity
                    self.view.backgroundColor = .black
                }
            }
        default:
            break
        }
    }
    
    // MARK: - Fullscreen toggle
    @objc private func toggleFullScreen() {
        isFullScreen.toggle()
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.35,
                       delay: 0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0.8,
                       options: [.curveEaseInOut],
                       animations: {
            self.containerView.alpha = self.isFullScreen ? 0 : 1
            
            if self.isFullScreen {
                self.scrollTopConstraint.constant = 0
                self.scrollLeadingConstraint.constant = 0
                self.scrollTrailingConstraint.constant = 0
                self.scrollHeightConstraint.isActive = false
                self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
                self.view.backgroundColor = .black
                self.scrollView.maximumZoomScale = 3.0
            } else {
                self.scrollTopConstraint.constant = 8
                self.scrollLeadingConstraint.constant = 16
                self.scrollTrailingConstraint.constant = -16
                self.scrollHeightConstraint.isActive = true
                self.scrollView.setZoomScale(1.0, animated: false)
                self.scrollView.maximumZoomScale = 1.0
                self.view.backgroundColor = UIColor(red: 0.1, green: 0.18, blue: 0.15, alpha: 1)
            }
            
            self.view.layoutIfNeeded()
        })
    }
    
    // MARK: - Photo Download
    private func saveImage(quality: DownloadQuality) {
        guard let url = (quality == .full ? viewModel.imageURL?.full : viewModel.imageURL?.regular)
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
    
    @objc private func saveFullImage() {
        saveImage(quality: .full)
    }
    
    @objc private func saveLowImage() {
        saveImage(quality: .regular)
    }
    
    // MARK: - Zoom Delegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return isFullScreen ? wallpaperImageView : nil
    }
}

extension WallpaperDetailsViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
