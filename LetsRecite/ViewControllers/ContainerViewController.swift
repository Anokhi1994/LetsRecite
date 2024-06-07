//
//  ViewController.swift
//  SideMenu
//
//  Created by Anokhi Shah on 28.10.23.
//

import UIKit

class ContainerViewController: UIViewController {
    
    
    enum MenuState {
        case opened
        case closed
    }
    
    private var menuState: MenuState = .closed
    
    let menuVC = MenuViewController()
    let homeVC = HomeViewController()
    var navVC: UINavigationController?
    lazy var reciteVC = ReciteViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        // Add a tap gesture recognizer to the entire screen
        //let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        //view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
        addChildVCs()
    }
    
    func addChildVCs(){
        //Menu
        menuVC.delegate = self
        addChild(menuVC)
        view.addSubview(menuVC.view)
        menuVC.didMove(toParent: self)
        
        //Home
        homeVC.delegate = self
        let navVC = UINavigationController(rootViewController: homeVC)
        addChild(navVC)
        view.addSubview(navVC.view)
        navVC.didMove(toParent: self)
        self.navVC = navVC

    }


}

extension ContainerViewController: HomeViewControllerDelegate {
    func didTapMenuButton() {
        toggleMenu(completion: nil)
    }
    
    func toggleMenu(completion: (() -> Void)?){
        switch menuState{
        case .closed:
            //open it
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn) {
                self.navVC?.view.frame.origin.x = self.homeVC.view.frame.size.width - 100
            } completion: { [weak self] done in
                if done {
                    self?.menuState = .opened

                }
            }
            
        case .opened:
            // close it
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn) {
                self.navVC?.view.frame.origin.x = 0
            } completion: { [weak self] done in
                if done {
                    self?.menuState = .closed
                    DispatchQueue.main.async {
                        completion?()
                    }
                }
            }
            
        }
    }
    
    
}

extension ContainerViewController: MenuViewControllerDelegate{
    func didSelect(menuItem: MenuViewController.MenuOptions) {
        toggleMenu(completion: nil)
            switch menuItem{
            case .home:
                self.resetToHome()
            case .recite:
                self.letsRecite()
            case .appRating:
                break
            case .shareApp:
                break
            case .settings:
                break
                
            }
        
    }
    
    func letsRecite(){
        let vc = reciteVC
        homeVC.addChild(vc)
        homeVC.view.addSubview(vc.view)
        vc.view.frame = view.frame
        vc.didMove(toParent: homeVC)
        homeVC.title = vc.title
    }
    
    func resetToHome(){
        reciteVC.view.removeFromSuperview()
        reciteVC.didMove(toParent: nil)
        homeVC.title = "Home"
    }
    
    
}

