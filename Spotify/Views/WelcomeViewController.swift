//
//  WelcomeViewController.swift
//  Spotify
//
//  Created by Salvador on 05/02/23.
//

import UIKit

class WelcomeViewController: UIViewController {

    private let signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign In with Spotify", for: .normal)
        button.setTitleColor(.systemGreen, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let bgImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "album_cover")
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()

    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.6
        return view
    }()

    private let logoImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "icon")
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()

    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.text = "Listen to Millions\nof Songs on\nthe go."
        label.textAlignment = .center
        label.textColor = .systemGreen
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Spotify"

        view.backgroundColor = .systemGreen
        view.addSubview(bgImgView)
        view.addSubview(overlayView)
        view.addSubview(logoImgView)
        view.addSubview(welcomeLabel)
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)

        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        NSLayoutConstraint.activate([
            signInButton.heightAnchor.constraint(equalToConstant: 100),
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            signInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc func didTapSignIn() {
        let authViewController = AuthViewController()
        authViewController.completionHandler = {[weak self] success in
            self?.handleSignIn(success: success)
        }
        authViewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(authViewController, animated: true)
    }

    private func handleSignIn(success: Bool) {
        guard success else {
            let alert = UIAlertController(title: "Oops",
                                          message: "Something went wrong on signing in",
                                          preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }

        let mainAppTabBarVc = Spotify()
        mainAppTabBarVc.modalPresentationStyle = .fullScreen
        present(mainAppTabBarVc, animated: true)
    }
}
