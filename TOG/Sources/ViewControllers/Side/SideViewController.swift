//
//  ChatSideViewController.swift
//  TOG
//
//  Created by 이상준 on 4/1/24.
//

import UIKit
import Then
import SnapKit
import SideMenu
import JGProgressHUD
import Firebase
import RxSwift
import NSObject_Rx

protocol SideViewControllerDelegate: class {
    func didDeleteChatRoom()
    func didTapChatRoom(chatRoomId: String)
}

private enum SideMenuSection: String, CaseIterable {
    case user = ""
    case record = "기록"
}

final class SideViewController: BaseViewController {
    
    weak var delegate: SideViewControllerDelegate?
    
    private var sections: [SideMenuSection] = [.user, .record]
    private let viewModel: SideViewModel
    
    private let hud = JGProgressHUD()
    private lazy var tableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .none
        $0.separatorInset.right = 20
        $0.backgroundColor = .white
        $0.register(SideTableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: SideTableViewHeaderView.identifier)
        $0.register(SideUserTableViewCell.self, forCellReuseIdentifier: SideUserTableViewCell.identifier)
        $0.register(SideChatHistoryTableViewCell.self, forCellReuseIdentifier: SideChatHistoryTableViewCell.identifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = true
    }
    
    init(viewModel: SideViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(safeArea)
        }
    }
    
    private func bind() {
        viewModel.chatRoomList
            .asDriver()
            .drive(onNext: { [weak self] rooms in
                self?.tableView.reloadData()
            })
            .disposed(by: rx.disposeBag)
    }
}

// MARK: UITableViewDelegate, UITableViewDatSource
extension SideViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch sections[section] {
        case .record:
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: SideTableViewHeaderView.identifier) as! SideTableViewHeaderView
            headerView.setTitle(title: sections[section].rawValue)
            return headerView
        default:
            return nil
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SideMenuSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .user:
            return 1
        default:
            return viewModel.chatRoomList.value.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case .user:
            let cell = tableView.dequeueReusableCell(withIdentifier: SideUserTableViewCell.identifier, for: indexPath) as! SideUserTableViewCell
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: SideChatHistoryTableViewCell.identifier, for: indexPath) as! SideChatHistoryTableViewCell
            cell.delegate = self
            cell.selectionStyle = .none
            cell.setTitle(title: viewModel.chatRoomList.value[indexPath.row].title)
            cell.indexPath = indexPath
            return cell
        }
    }
}

// MARK: - SideUserTableViewCellDelegate
extension SideViewController: SideUserTableViewCellDelegate {
    func didTapMoreButton() {
        let settingsVC = UINavigationController(rootViewController: SettingsViewController())
        self.present(settingsVC, animated: true)
    }
}

// MARK: - SideChatHistoryTableViewCellDelegate
extension SideViewController: SideChatHistoryTableViewCellDelegate {
    func didTapChatRoom(at indexPath: IndexPath) {
        let chatRoomId = viewModel.chatRoomList.value[indexPath.row].chatRoomId
        delegate?.didTapChatRoom(chatRoomId: chatRoomId)
        self.dismiss(animated: true)
    }
    
    func didTapDeleteButton(at indexPath: IndexPath) {
        let chatRoomId = viewModel.chatRoomList.value[indexPath.row].chatRoomId
        hud.show(in: self.view, animated: true)
        
        viewModel.deleteChatRoom(chatRoomId: chatRoomId)
            .subscribe(onNext: { [weak self] result in
                self?.hud.dismiss(animated: true)
                switch result {
                case .success(_):
                    self?.delegate?.didDeleteChatRoom()
                    self?.dismiss(animated: true)
                case .failure(let error):
                    print("DEBUG: delete ChatRoom fail", error.localizedDescription)
                }
            })
            .disposed(by: rx.disposeBag)
    }
}
