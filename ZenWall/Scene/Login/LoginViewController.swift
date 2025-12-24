//
//  LoginViewController.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 26.11.25.
//

import UIKit

final class LoginViewController: BaseViewController {
    
    // MARK: - Title
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "ZenWall"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 32)
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Email Field
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var emailField: UITextField = {
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
    private lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password"
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var passwordField: UITextField = {
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
    private lazy var loginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Login", for: .normal)
        btn.backgroundColor = UIColor(red: 0.07, green: 0.83, blue: 0.32, alpha: 1)
        btn.setTitleColor(UIColor(red: 0.06, green: 0.13, blue: 0.09, alpha: 1), for: .normal)
        btn.layer.cornerRadius = 14
        btn.titleLabel?.font = .boldSystemFont(ofSize: 17)
        return btn
    }()
    
    // MARK: Divider
    private lazy var dividerLabel: UILabel = {
        let label = UILabel()
        label.text = "Or continue with"
        label.textColor = UIColor(red: 0.57, green: 0.79, blue: 0.64, alpha: 1)
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Google Button (Custom)
    private lazy var googleButton: UIButton = {
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
    
    // MARK: - Forgot Password
    private lazy var forgotPasswordButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Forgot Password?", for: .normal)
        btn.setTitleColor(UIColor(red: 0.57, green: 0.79, blue: 0.64, alpha: 1), for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14)
        return btn
    }()
    
    // MARK: - Footer
    private lazy var footerLabel: UILabel = {
        let label = UILabel()
        label.text = "Don't have an account?"
        label.textColor = UIColor(red: 0.57, green: 0.79, blue: 0.64, alpha: 0.8)
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var signupButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Sign Up", for: .normal)
        btn.setTitleColor(UIColor(red: 0.07, green: 0.83, blue: 0.32, alpha: 1), for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 14)
        return btn
    }()
    
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        sv.showsVerticalScrollIndicator = false
        sv.keyboardDismissMode = .interactive
        return sv
    }()
    
    private let contentView = UIView()
    
    let viewModel = LoginViewModel()
    let builder = UserBuilder()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        closureHandler()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func closureHandler() {
        viewModel.successForReset = {
            self.alertFor(title: "Email Sent!", message: "Check your Inbox!")
        }
        viewModel.successForSignIn = { userId in
            UserDefaults.standard.set(userId, forKey: "userId")
            UserSessionManager.shared.isLoggedIn = true
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                if let window = sceneDelegate.window {
                    UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromRight, animations: {
                        window.rootViewController = CustomTabBar()
                    }, completion: nil)
                }
            }
        }
        viewModel.failure = { error in
            self.alertFor(title: "Error", message: error)
        }
    }
    
    // MARK: - Layout
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [
            titleLabel,
            emailLabel, emailField,
            passwordLabel, passwordField,
            loginButton,
            dividerLabel,
            googleButton,
            forgotPasswordButton,
            footerLabel, signupButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        navigationItem.backButtonTitle = ""
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(signup), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(googleTapped), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: view.bounds.height * 0.05),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            emailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            emailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            emailField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8),
            emailField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emailField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            emailField.heightAnchor.constraint(equalToConstant: 54),
            
            passwordLabel.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20),
            passwordLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            passwordField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 8),
            passwordField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            passwordField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            passwordField.heightAnchor.constraint(equalToConstant: 54),
            
            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 32),
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            loginButton.heightAnchor.constraint(equalToConstant: 54),
            
            dividerLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 30),
            dividerLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            googleButton.topAnchor.constraint(equalTo: dividerLabel.bottomAnchor, constant: 18),
            googleButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            googleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            googleButton.heightAnchor.constraint(equalToConstant: 54),
            
            forgotPasswordButton.topAnchor.constraint(equalTo: googleButton.bottomAnchor, constant: 26),
            forgotPasswordButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            footerLabel.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 50),
            footerLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -35),
            
            signupButton.centerYAnchor.constraint(equalTo: footerLabel.centerYAnchor),
            signupButton.leadingAnchor.constraint(equalTo: footerLabel.trailingAnchor, constant: 6),
            
            footerLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
    }
    
    @objc private func login() {
        guard let email = emailField.text,
              let password = passwordField.text else { return }
        viewModel.signIn(email: email, password: password)
    }
    
    @objc private func googleTapped() {
        FirebaseAdapter.shared.signInWithGoogle(presentingVC: self) { [weak self] userId, error in
            
            guard let self else { return }
            
            if let userId {
                UserDefaults.standard.set(userId, forKey: "userId")
                UserSessionManager.shared.isLoggedIn = true
                if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                    if let window = sceneDelegate.window {
                        UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromRight, animations: {
                            window.rootViewController = CustomTabBar()
                        }, completion: nil)
                    }
                }
            } else {
                self.alertFor(title: "Google Sign-In Failed", message: error ?? "Unknown error")
            }
        }
    }
    
    @objc private func forgotPasswordTapped() {
        guard let email = emailField.text, !email.isEmpty else {
            self.alertFor(title: "Oops!", message: "Please enter your email first.")
            return
        }
        viewModel.resetPassword(email: email)
    }
    
    @objc private func signup() {
        let coordinator = SignupCoordinator(navigationController: self.navigationController ?? UINavigationController(), builder: builder)
        coordinator.start()
    }
}
