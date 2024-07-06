//
//  SignInViewModel.swift
//  TOG
//
//  Created by 이상준 on 4/8/24.
//

import RxSwift
import RxRelay
import FirebaseAuth

final class SignInViewModel: BaseViewModel {
    
    private let userRepository: UserRepository
    var user: User? = nil
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func isUserExist(uid: String) -> Observable<Bool> {
        return userRepository.userExists(uid: uid)
    }
    
    func signUp(displayname: String, email: String, photoUrl: String) {
        userRepository.createUser(displayname: displayname, email: email, photoUrl: photoUrl)
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let user):
                    print("DEBUG: createUser success: \(user.uid)")
                    self?.fetchUser()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func fetchUser() {
        userRepository.fetchUser().subscribe(onNext: { [weak self] result in
            switch result {
            case .success(let user):
                self?.user = user
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
        .disposed(by: disposeBag)
    }
}
