//
//  Spotify.swift
//  Spotify
//
//  Created by Salvador on 05/02/23.
//

import UIKit

class Spotify: UIViewController {

    private lazy var playerBar: PlayerBar = {
        let playerBar = PlayerBar()
        playerBar.delegate = self
        playerBar.translatesAutoresizingMaskIntoConstraints = false
        return playerBar
    }()

    private lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()

        gradient.colors = [UIColor.black.withAlphaComponent(0).cgColor, UIColor.black.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0, y: 1.0)
        gradient.frame = CGRect(x: 0, y: -100,
                                width: tabBar.tabBar.bounds.width,
                                height: tabBar.tabBar.bounds.height + 150)

        return gradient
    }()

    let vc1 = Home()
    let vc2 = SearchView()
    let vc3 = LibraryView()

    private lazy var nav1: UINavigationController = UINavigationController(rootViewController: vc1)

    let tabBar = UITabBarController()

    override func viewDidLoad() {
        super.viewDidLoad()

        vc1.navigationItem.title = "Music"
        vc2.navigationItem.title = "Search"
        vc3.navigationItem.title = "Library"

        vc1.navigationItem.largeTitleDisplayMode = .always
        vc2.navigationItem.largeTitleDisplayMode = .always
        vc3.navigationItem.largeTitleDisplayMode = .always

        let nav2 = UINavigationController(rootViewController: vc2)
        let nav3 = UINavigationController(rootViewController: vc3)

        nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "home"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Search", image: UIImage(named: "search"), tag: 1)
        nav3.tabBarItem = UITabBarItem(title: "Library", image: UIImage(named: "library"), tag: 1)

        nav1.navigationBar.prefersLargeTitles = true
        nav2.navigationBar.prefersLargeTitles = true
        nav3.navigationBar.prefersLargeTitles = true

        tabBar.viewControllers = [nav1, nav2, nav3]
        tabBar.view.frame = view.bounds

        let appearance = UITabBarAppearance()
        appearance.backgroundEffect = .none
        appearance.shadowColor = .clear

        let tabBarItemAppearance = UITabBarItemAppearance()
        tabBarItemAppearance.selected.iconColor = .white
        tabBarItemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        tabBarItemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        tabBarItemAppearance.selected.titlePositionAdjustment = .init(horizontal: 0, vertical: 5)
        tabBarItemAppearance.normal.titlePositionAdjustment = .init(horizontal: 0, vertical: 5)
        additionalSafeAreaInsets.bottom = 8
        appearance.stackedLayoutAppearance = tabBarItemAppearance
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance


        tabBar.tabBar.layer.insertSublayer(gradient, at: 0)
        tabBar.view.insertSubview(playerBar, aboveSubview: tabBar.tabBar)
        tabBar.view.addConstraints([
            NSLayoutConstraint(item: playerBar, attribute: .leading, relatedBy: .equal, toItem: tabBar.tabBar, attribute: .leading, multiplier: 1, constant: 5),
            NSLayoutConstraint(item: playerBar, attribute: .trailing, relatedBy: .equal, toItem: tabBar.tabBar, attribute: .trailing, multiplier: 1, constant: -5),
            NSLayoutConstraint(item: playerBar, attribute: .top, relatedBy: .equal, toItem: tabBar.tabBar, attribute: .top, multiplier: 1, constant: -65),
            NSLayoutConstraint(item: playerBar, attribute: .bottom, relatedBy: .equal, toItem: tabBar.tabBar, attribute: .top, multiplier: 1, constant: -5)
        ])
        tabBar.willMove(toParent: self)
        view.addSubview(tabBar.view)
        self.addChild(tabBar)
    }
}

extension Spotify: PlayerBarDelegate {
    func tap() {
        let player = PlayerView()
        player.spotifyDelegate = self
        self.show(player, sender: self)
    }

    func playTap() {
        if AudioManager.sharedInstance.isPlaying() {
            AudioManager.sharedInstance.pause()
            playerBar.setPlayIcon()
        } else {
            AudioManager.sharedInstance.resume()
            playerBar.setPauseIcon()
        }
    }
}

extension Spotify: SpotifyDelegate {
    func showArtist(artistId: String) {
        Task {
            do {
                let artist = try await SpotifyRepository.shared.getArtist(artistId: artistId)
                let artistView = ArtistView(artist: artist)
                self.tabBar.selectedIndex = 0

                if let actualView = self.nav1.viewControllers.last as? ArtistView {
                    if actualView.artist.name != artist.name {
                        self.nav1.popToRootViewController(animated: false)
                        self.nav1.pushViewController(artistView, animated: true)
                    }
                } else {
                    self.nav1.pushViewController(artistView, animated: true)
                }
            } catch {

            }
        }
    }
}

protocol SpotifyDelegate: AnyObject {
    func showArtist(artistId: String)
}
