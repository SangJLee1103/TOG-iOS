//
//  SettingsViewController.swift
//  TOG
//
//  Created by 이상준 on 4/12/24.
//

import UIKit
import SnapKit
import Firebase
import SafariServices

private enum SettingsSection: String, CaseIterable {
    case account = "계정"
    case app = "앱 관리"
}

private enum SettingsRow: String {
    case email = "Email"
    case help = "Help Center"
    case use = "Terms of Use"
    case signout = "Sign Out"
    case leave = "Leave"
}

final class SettingsViewController: UITableViewController {
    private var sections: [SettingsSection] = [.account, .app]
    private var rows: [[SettingsRow]] = [[.email], [.help, .use, .signout, .leave]]
    
    private var settingDataList: [[Setting]] = [
        
        [Setting(imgName: "email", title: "이메일", desc: UserManager.shared.user?.email ?? "알 수 없음", isLast: false, isAccessory: false)],
        [
            Setting(imgName: "help", title: "고객센터", desc: "", isLast: false, isAccessory: true),
            Setting(imgName: "terms", title: "서비스 약관", desc: "", isLast: false, isAccessory: true),
            Setting(imgName: "sign_out", title: "로그아웃", desc: "", isLast: false, isAccessory: false),
            Setting(imgName: "leave", title: "탈퇴하기", desc: "", isLast: true, isAccessory: false)
        ],
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        navigationController?.navigationBar.backgroundColor = .white
        navigationItem.title = "설정"
        
        let closeImage = UIImage(named: "x_mark")
        let closeButton = UIBarButtonItem(image: closeImage, style: .plain, target: self, action: #selector(actionClose))
        closeButton.tintColor = .black
        navigationItem.rightBarButtonItem = closeButton
        
        view.backgroundColor = .systemGray6
        
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier)
    }
    
    private func showSignInVC() {
        let signinVC = SignInViewController(viewModel: SignInViewModel(userRepository: UserRepositoryImpl()))
        let nav = UINavigationController(rootViewController: signinVC)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
    }
    
    private func showCenter() {
        guard let url = URL(string: "http://pf.kakao.com/_Jxfxixcxj") else {
            print("Invalid URL")
            return
        }
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }

    private func showTermsOfUse() {
        showDetailContent(url: "http://ec2-3-106-213-74.ap-southeast-2.compute.amazonaws.com/info/terms", title: "이용약관")
    }
    
    private func handleSignOut() {
        UserRepositoryImpl().logout {
            self.showSignInVC()
        }
    }
    
    private func handleLeave() {
        let alertVC = TogAlertViewController(type: .leave)
        alertVC.delegate = self
        self.present(alertVC, animated: true)
    }
    
    @objc func actionClose() {
        self.dismiss(animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = sections[section]
        return section.rawValue
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch rows[indexPath.section][indexPath.row] {
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as! SettingsTableViewCell
            
            let accessoryView = UIImageView(image: UIImage(named: "right"))
            accessoryView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            cell.accessoryView = accessoryView
            cell.viewModel = SettingsViewModel(setting: settingDataList[indexPath.section][indexPath.row])
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch rows[indexPath.section][indexPath.row] {
        case .help:
            showCenter()
        case .use:
            showTermsOfUse()
        case .signout:
            handleSignOut()
        case .leave:
            handleLeave()
        default:
            return
        }
    }
}

extension SettingsViewController: TogLeaveDelegate {
    func isSuccessLeave() {
        UserRepositoryImpl().leave {
            self.showSignInVC()
        }
    }
}

extension SettingsViewController: TermsViewDelegate {
    func showDetailContent(url: String?, title: String?) {
        guard let urlString = url, let navTitle = title else {
            print("Invalid URL or Title")
            return
        }
        let webViewController = TogWebViewController(navTitle: navTitle, url: urlString)
        
        let vc = UINavigationController(rootViewController: webViewController)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
