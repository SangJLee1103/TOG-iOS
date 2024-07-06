//
//  BaseViewController.swift
//  TOG
//
//  Created by 이상준 on 4/22/24.
//

import UIKit
import Then
import SnapKit
import Firebase
import FirebaseAuth
import JGProgressHUD
import RxSwift
import RxCocoa
import RxGesture
import NSObject_Rx

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    func showFullScreenNavigationView(_ vc: UIViewController) {
        let vc = UINavigationController(rootViewController: vc)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc func popVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func closeVC() {
        self.dismiss(animated: true)
    }
}
