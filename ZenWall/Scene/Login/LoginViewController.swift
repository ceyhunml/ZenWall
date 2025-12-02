//
//  LoginViewController.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 26.11.25.
//

import UIKit

final class LoginViewController: UIViewController {
    
    let viewModel = LoginViewModel()
    let builder = UserBuilder()
    
    // MARK: - Title
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "ZenWall"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 32)
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Email Field
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let emailField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter your email"
        tf.backgroundColor = UIColor(red: 0.14, green: 0.28, blue: 0.19, alpha: 1)
        tf.textColor = .white
        tf.layer.cornerRadius = 14
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 0))
        tf.leftViewMode = .always
        return tf
    }()
    
    // MARK: - Password
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password"
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let passwordField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter your password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(red: 0.14, green: 0.28, blue: 0.19, alpha: 1)
        tf.textColor = .white
        tf.layer.cornerRadius = 14
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 0))
        tf.leftViewMode = .always
        return tf
    }()
    
    // MARK: - Login Button
    private let loginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Login", for: .normal)
        btn.backgroundColor = UIColor(red: 0.07, green: 0.83, blue: 0.32, alpha: 1)
        btn.setTitleColor(UIColor(red: 0.06, green: 0.13, blue: 0.09, alpha: 1), for: .normal)
        btn.layer.cornerRadius = 14
        btn.titleLabel?.font = .boldSystemFont(ofSize: 17)
        return btn
    }()
    
    // MARK: Divider
    private let dividerLabel: UILabel = {
        let label = UILabel()
        label.text = "Or continue with"
        label.textColor = UIColor(red: 0.57, green: 0.79, blue: 0.64, alpha: 1)
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Google Button (Custom)
    private let googleButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 14
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor(red: 0.14, green: 0.28, blue: 0.19, alpha: 1).cgColor
        btn.backgroundColor = .clear
        
        let icon = UIImageView(image: UIImage(named: "googleLogo"))
        icon.tintColor = .white
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        let title = UILabel()
        title.text = "Sign in with Google"
        title.textColor = .white
        title.font = .boldSystemFont(ofSize: 16)
        title.translatesAutoresizingMaskIntoConstraints = false
        
        btn.addSubview(icon)
        btn.addSubview(title)
        
        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(equalTo: btn.leadingAnchor, constant: 40),
            icon.centerYAnchor.constraint(equalTo: btn.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 24),
            icon.heightAnchor.constraint(equalToConstant: 24),
            
            title.centerYAnchor.constraint(equalTo: btn.centerYAnchor),
            title.centerXAnchor.constraint(equalTo: btn.centerXAnchor)
        ])
        
        return btn
    }()
    
    private func setupGradientBackground() {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 0.06, green: 0.09, blue: 0.08, alpha: 1).cgColor,
            UIColor(red: 0.09, green: 0.12, blue: 0.10, alpha: 1).cgColor
        ]
        gradient.locations = [0.0, 1.0]
        gradient.frame = view.bounds
        
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    // MARK: - Forgot Password
    private let forgotPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Forgot Password?"
        label.textColor = UIColor(red: 0.57, green: 0.79, blue: 0.64, alpha: 1)
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Footer
    private let footerLabel: UILabel = {
        let label = UILabel()
        label.text = "Don't have an account?"
        label.textColor = UIColor(red: 0.57, green: 0.79, blue: 0.64, alpha: 0.8)
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let signupButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Sign Up", for: .normal)
        btn.setTitleColor(UIColor(red: 0.07, green: 0.83, blue: 0.32, alpha: 1), for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 14)
        return btn
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonTitle = ""
        setupGradientBackground()
        setupUI()
    }
    
    // MARK: - Layout
    private func setupUI() {
        
        [
            titleLabel,
            emailLabel, emailField,
            passwordLabel, passwordField,
            loginButton,
            dividerLabel,
            googleButton,
            forgotPasswordLabel,
            footerLabel, signupButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(signup), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            emailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            emailField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8),
            emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailField.heightAnchor.constraint(equalToConstant: 54),
            
            passwordLabel.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20),
            passwordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            passwordField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 8),
            passwordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordField.heightAnchor.constraint(equalToConstant: 54),
            
            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 32),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            loginButton.heightAnchor.constraint(equalToConstant: 54),
            
            dividerLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 30),
            dividerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            googleButton.topAnchor.constraint(equalTo: dividerLabel.bottomAnchor, constant: 18),
            googleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            googleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            googleButton.heightAnchor.constraint(equalToConstant: 54),
            
            forgotPasswordLabel.topAnchor.constraint(equalTo: googleButton.bottomAnchor, constant: 26),
            forgotPasswordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            footerLabel.topAnchor.constraint(equalTo: forgotPasswordLabel.bottomAnchor, constant: 50),
            footerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -35),
            
            signupButton.centerYAnchor.constraint(equalTo: footerLabel.centerYAnchor),
            signupButton.leadingAnchor.constraint(equalTo: footerLabel.trailingAnchor, constant: 6)
        ])
    }
    
    @objc private func login() {
        guard let email = emailField.text,
              let password = passwordField.text else { return }
        
        viewModel.signIn(email: email, password: password) { [weak self] success, error in
            guard let self else { return }
            if success != nil {
                if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                    sceneDelegate.window?.rootViewController = CustomTabBar()
                    sceneDelegate.window?.makeKeyAndVisible()
                }
            } else if let error {
                self.alertFor(title: "Oops!", message: error)
            }
        }
    }
    
    @objc private func signup() {
        let coordinator = SignupCoordinator(navigationController: self.navigationController ?? UINavigationController(), builder: builder)
        coordinator.start()
    }
}
