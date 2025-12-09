//
//  FullnameViewController.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 27.11.25.
//

import Foundation
import UIKit

class FullnameViewController: BaseViewController {
    
    // MARK: - UI Elements
    private lazy var nameTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "What's your name?"
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        return lbl
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Let's get to know each other."
        lbl.textColor = UIColor(white: 1, alpha: 0.65)
        lbl.font = UIFont.systemFont(ofSize: 16)
        return lbl
    }()
    
    private lazy var fieldHeaderLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Full Name"
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return lbl
    }()
    
    private lazy var nameField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter your full name"
        tf.textColor = .white
        tf.backgroundColor = UIColor(red: 0.11, green: 0.16, blue: 0.15, alpha: 1)
        tf.layer.cornerRadius = 16
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        tf.leftViewMode = .always
        tf.autocapitalizationType = .words
        tf.autocorrectionType = .no
        tf.font = UIFont.systemFont(ofSize: 17)
        return tf
    }()
    
    private lazy var nextButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Next", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        btn.backgroundColor = UIColor(red: 0.07, green: 0.83, blue: 0.32, alpha: 1)
        btn.tintColor = UIColor(red: 0.07, green: 0.13, blue: 0.10, alpha: 1)
        btn.layer.cornerRadius = 28
        btn.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        return btn
    }()
    
    let viewModel: FullnameViewModel
    let builder: UserBuilder
    
    init(viewModel: FullnameViewModel, builder: UserBuilder) {
        self.viewModel = viewModel
        self.builder = builder
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .white
        setupConstraints()
        hideKeyboardWhenTappedAround()
    }
    
    // MARK: - Setup UI
    private func setupConstraints() {
        title = "Step 2 of 3"
        [nameTitleLabel, subtitleLabel,
         fieldHeaderLabel, nameField, nextButton]
            .forEach { sub in
                sub.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(sub)
            }
        
        NSLayoutConstraint.activate([
            
            nameTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            nameTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            subtitleLabel.topAnchor.constraint(equalTo: nameTitleLabel.bottomAnchor, constant: 6),
            subtitleLabel.leadingAnchor.constraint(equalTo: nameTitleLabel.leadingAnchor),
            
            fieldHeaderLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 32),
            fieldHeaderLabel.leadingAnchor.constraint(equalTo: nameTitleLabel.leadingAnchor),
            
            nameField.topAnchor.constraint(equalTo: fieldHeaderLabel.bottomAnchor, constant: 6),
            nameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameField.heightAnchor.constraint(equalToConstant: 56),
            
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nextButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func nextAction() {
        guard let fullname = nameField.text, !fullname.isEmpty else {
            self.alertFor(title: "Oops!", message: "Please enter your full name.")
            return
        }
        viewModel.coordinator.showPassword(fullname: fullname)
    }
}
