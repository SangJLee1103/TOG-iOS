//
//  UserRepository.swift
//  TOG
//
//  Created by 이상준 on 4/4/24.
//

import Firebase
import RxSwift

protocol UserRepository {
    func fetchUser(uid: String, completion: @escaping (Result<User, Error>) -> Void)
    func fetchUser() -> Observable<Result<User, Error>>
    func userExists(uid: String) -> Observable<Bool>
    func createUser(displayname: String, email: String, photoUrl: String) -> Observable<Result<User, Error>>
    func logout(completion: @escaping (() -> Void))
    func leave(completion: @escaping(() -> Void))
}
