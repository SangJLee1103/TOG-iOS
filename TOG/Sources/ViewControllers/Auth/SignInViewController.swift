//
//  SignInViewController.swift
//  TOG
//
//  Created by 이상준 on 4/3/24.
//

import UIKit
import Then
import SnapKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import AuthenticationServices
import CryptoKit

final class SignInViewController: BaseViewController {
    
    private let viewModel: SignInViewModel
    
    fileprivate var currentNonce: String?
    
    private let logoImgView = UIImageView().then {
        $0.image = UIImage(named: "auth_logo")
    }
    
    private lazy var googleButton = LoginButton().then {
        $0.setStyle(type: .google, title: "Google 로그인")
        $0.addTarget(self, action: #selector(signinGoogle), for: .touchUpInside)
    }
    
    private lazy var appleButton = LoginButton().then {
        $0.setStyle(type: .apple, title: "Apple 로그인")
        $0.addTarget(self, action: #selector(signinApple), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(logoImgView)
        logoImgView.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(200)
            $0.width.equalTo(200)
            $0.height.equalTo(90.8)
            $0.centerX.equalTo(safeArea)
        }
        
        let stackView = UIStackView(arrangedSubviews: [googleButton, appleButton])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.leading.trailing.equalTo(safeArea).inset(16)
            $0.bottom.equalTo(safeArea).inset(150)
        }
    }
    
    private func showChatVC() {
        DispatchQueue.main.async {
            let chatVC = ChatViewController(viewModel: ChatViewModel(chatRepository: ChatRepositoryImpl()))
            let navigationController = UINavigationController(rootViewController: chatVC)
            self.view.window?.rootViewController = navigationController
            self.view.window?.makeKeyAndVisible()
        }
    }
    
    // MARK: - About Signin Google
    @objc private func signinGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            if let error = error {
                print("ERROR", error.localizedDescription)
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { [self] _, _ in
                guard let name = user.profile?.name,
                      let email = user.profile?.email,
                      let imgUrl = user.profile?.imageURL(withDimension: 320)?.absoluteString else { return }
                
                if let uid = Auth.auth().currentUser?.uid {
                    viewModel.isUserExist(uid: uid)
                        .subscribe(onNext: { [weak self] exist in
                            if exist {
                                self?.viewModel.fetchUser()
                                self?.showChatVC()
                            } else {
                                let termsVC = TermsViewController(viewModel: TermsViewModel(userRepository: UserRepositoryImpl())) {
                                    self?.viewModel.signUp(displayname: name, email: email, photoUrl: imgUrl)
                                    self?.showChatVC()
                                }
                                self?.showFullScreenNavigationView(termsVC)
                            }
                        }).disposed(by: rx.disposeBag)
                } else {
                    print("DEBUG: Fetch uid Failed")
                    return
                }
            }
        }
    }
    
    // MARK: - About Signin Apple
    @objc private func signinApple() {
        startSignInWithAppleFlow()
    }
}

// MARK: - About Apple login logic
private extension SignInViewController {
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        return String(nonce)
    }
    
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}

// MARK: - About Apple login logic
extension SignInViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window ?? UIWindow()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString, rawNonce: nonce, fullName: appleIDCredential.fullName)
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print ("Error Apple sign in: \(error.localizedDescription)")
                    return
                }
                
                guard let uid = Auth.auth().currentUser?.uid else { return }
                
                self.viewModel.isUserExist(uid: uid)
                    .subscribe(onNext: { [weak self] exist in
                        if exist {
                            self?.viewModel.fetchUser()
                            self?.showChatVC()
                        } else {
                            let termsVC = TermsViewController(viewModel: TermsViewModel(userRepository: UserRepositoryImpl())) {
                                if let familyName = appleIDCredential.fullName?.familyName,
                                   let givenName = appleIDCredential.fullName?.givenName,
                                   let email = appleIDCredential.email {
                                    self?.viewModel.signUp(displayname: "\(familyName)\(givenName)", email: email, photoUrl: "")
                                } else if let email = appleIDCredential.email {
                                    self?.viewModel.signUp(displayname: "알 수 없음", email: email, photoUrl: "")
                                } else {
                                    print("회원가입 불가")
                                    return
                                }
                                self?.showChatVC()
                            }
                            self?.showFullScreenNavigationView(termsVC)
                        }
                    })
                    .disposed(by: self.rx.disposeBag)
            }
        }
    }
}
