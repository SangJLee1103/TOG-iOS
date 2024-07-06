//
//  ViewController.swift
//  TOG
//
//  Created by 이상준 on 3/24/24.
//

import UIKit
import SnapKit
import SideMenu
import FirebaseAuth
import SafariServices

final class ChatViewController: BaseViewController {
    
    private let viewModel: ChatViewModel
    private var promptTextFieldBottomConstraint: Constraint?
    private var submitButtonBottomConstraint: Constraint?
    private var tableViewBottomConstraint: Constraint?
    private var isUserScrolling = false // 유저 스크롤 상태 플래그
    
    private lazy var tableView = UITableView().then {
        $0.backgroundColor = .white
        $0.separatorStyle = .none
        $0.keyboardDismissMode = .onDrag
        $0.delegate = self
        $0.register(MyTableViewCell.self, forCellReuseIdentifier: MyTableViewCell.identifier)
        $0.register(TogTableViewCell.self, forCellReuseIdentifier: TogTableViewCell.identifier)
    }
    
    private let chatDescriptionLabel = UILabel().then {
        $0.isHidden = true
        $0.textColor = .grey5
        $0.font = UIFont(name: "Pretendard-Regular", size: 14)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.text = "본 서비스는\nAI기반으로 제공되며 부족한 점이 있을 수 있습니다.\n언제든 고객센터로 문의 주세요."
    }
    
    private let promptTextView = ChatTextView().then {
        $0.clipsToBounds = true
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.textContainerInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.layer.cornerRadius = 20
        $0.backgroundColor = .grey1
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.grey2.cgColor
        $0.font = .systemFont(ofSize: 15)
    }
    
    private lazy var submitButton = UIButton().then {
        let image = UIImage(named: "unable_upload")
        $0.imageView?.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.setImage(image, for: .normal)
    }
    
    init(viewModel: ChatViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.promptTextView.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureUI()
        bind()
        setupKeyboardNotification()
    }
    
    private func configureNavBar() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = .togPurple
        navigationBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "GmarketSansBold", size: 16)!
        ]
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        
        
        let leftButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(didTapLeftBarButton))
        navigationItem.leftBarButtonItem = leftButtonItem
        navigationItem.leftBarButtonItem?.tintColor = .white
        
        let rightButtonItem = UIBarButtonItem(image: UIImage(named: "new_chat"), style: .plain, target: self, action: #selector(didTapRightBarButton))
        navigationItem.rightBarButtonItem = rightButtonItem
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    private func configureUI() {
        title = "TOG"
        
        let safeArea = view.safeAreaLayoutGuide
        
        [promptTextView, submitButton, tableView].forEach {
            view.addSubview($0)
        }
        
        promptTextView.snp.makeConstraints {
            $0.leading.equalTo(safeArea).offset(16)
            $0.trailing.equalTo(safeArea).offset(-56)
            self.promptTextFieldBottomConstraint = $0.bottom.equalTo(safeArea).inset(14).constraint
        }
        
        submitButton.snp.makeConstraints {
            $0.trailing.equalTo(safeArea).inset(16)
            $0.centerY.equalTo(promptTextView)
        }
        
        let heightConstraint = NSLayoutConstraint(item: promptTextView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 35)
        promptTextView.addConstraint(heightConstraint)
        promptTextView.heightConstraint = heightConstraint
        
        tableView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(safeArea)
            self.tableViewBottomConstraint = $0.bottom.equalTo(promptTextView.snp.top).offset(-20).constraint
        }
        
        tableView.addSubview(chatDescriptionLabel)
        chatDescriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func bind() {
        viewModel.error
            .asDriver(onErrorJustReturn: MyError.unknown)
            .drive(onNext: { [weak self] error in
                guard let self = self else { return }
                TogAlertViewController.showErrorAlert(on: self)
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.messages
            .map { $0.count != 0 }
            .bind(to: chatDescriptionLabel.rx.isHidden)
            .disposed(by: rx.disposeBag)
        
        promptTextView.rx.text
            .orEmpty
            .bind(to: viewModel.prompt)
            .disposed(by: rx.disposeBag)
        
        viewModel.isValidSend
            .asDriver()
            .drive(onNext: { [weak self] isEnabled in
                guard let self = self else { return }
                self.submitButton.isEnabled = isEnabled
                let image = isEnabled ? "able_upload" : "unable_upload"
                self.submitButton.setImage(UIImage(named: image), for: .normal)
            })
            .disposed(by: rx.disposeBag)
        
        
        if let rightBarButtonItem = navigationItem.rightBarButtonItem {
            viewModel.isEnableCreateNewChat
                .bind(to: rightBarButtonItem.rx.isEnabled)
                .disposed(by: rx.disposeBag)
        }
        
        submitButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                if let promptText = self?.promptTextView.text {
                    self?.viewModel.fetchTogMessage(prompt: promptText)
                    self?.promptTextView.resetUI()
                }
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.messages
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if self.viewModel.messages.value.count > 0 && !self.isUserScrolling {
                        self.scrollToBottom()
                    } 
                }
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.messages
            .bind(to: tableView.rx.items) { (tableView, row, message) in
                let identifier = row % 2 != 0 ? TogTableViewCell.identifier : MyTableViewCell.identifier
                let cell = tableView.dequeueReusableCell(withIdentifier: identifier)!
                
                if let cell = cell as? TogTableViewCell {
                    cell.setMessage(message: message.content)
                    cell.selectionStyle = .none
                } else if let cell = cell as? MyTableViewCell {
                    cell.setMessage(content: message.content)
                    cell.selectionStyle = .none
                }
                return cell
            }
            .disposed(by: rx.disposeBag)
    }
    
    private func scrollToBottom(animated: Bool = false) {
        guard viewModel.messages.value.count > 0 else { return }
        let lastIndexPath = IndexPath(row: viewModel.messages.value.count - 1, section: 0)
        DispatchQueue.main.async {
            self.tableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: animated)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc private func didTapLeftBarButton() {
        let sideVC = SideViewController(viewModel: SideViewModel(chatRepository: ChatRepositoryImpl()))
        sideVC.delegate = self
        
        let sideMenuVC = SideMenuNavigationController(rootViewController: sideVC)
        sideMenuVC.presentationStyle = .menuSlideIn
        sideMenuVC.presentationStyle.presentingEndAlpha = 0.8
        sideMenuVC.menuWidth = self.view.frame.width * 0.8
        sideMenuVC.leftSide = true
        present(sideMenuVC, animated: true)
    }
    
    @objc private func didTapRightBarButton() {
        viewModel.messages.accept([])
        viewModel.chatRoomId.accept(nil)
    }
}

// MARK: - About Keyboard
extension ChatViewController {
    private func setupKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height - view.safeAreaInsets.bottom
            UIView.animate(withDuration: 0.3) {
                self.promptTextFieldBottomConstraint?.update(inset: keyboardHeight + 20)
                self.submitButtonBottomConstraint?.update(inset: keyboardHeight + 20)
                self.view.layoutIfNeeded()
            }

            DispatchQueue.main.async {
                self.scrollToBottom(animated: false)
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.promptTextFieldBottomConstraint?.update(inset: 20)
            self.submitButtonBottomConstraint?.update(inset: 20)
            self.view.layoutIfNeeded()
        }
    }
}

extension ChatViewController: UITableViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isUserScrolling = true
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            isUserScrolling = false
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isUserScrolling = false
    }
}

// MARK: - About SideViewControllerDelegate
extension ChatViewController: SideViewControllerDelegate {
    func didTapChatRoom(chatRoomId: String) {
        viewModel.chatRoomId.accept(chatRoomId)
    }
    
    func didDeleteChatRoom() {
        viewModel.messages.accept([])
        viewModel.fetchLatestChatRoom()
    }
}
