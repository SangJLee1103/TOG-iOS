//
//  UserRepositoryImpl.swift
//  TOG
//
//  Created by 이상준 on 4/4/24.
//

import Firebase
import RxSwift

final class UserRepositoryImpl: UserRepository {
    static let shared = UserRepositoryImpl()
    
    func fetchUser(uid: String, completion: @escaping (Result<User, Error>) -> Void) {
        COLLECTION_USER.document(uid).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else if let dictionary = snapshot?.data() {
                let user = User(data: dictionary)
                completion(.success(user))
            } else {
                let error: MyError = .unauthorized
                completion(.failure(error))
            }
        }
    }
    
    func fetchUser() -> Observable<Result<User, Error>> {
        return .create { observer in
            guard let uid = Auth.auth().currentUser?.uid else {
                let error: MyError = .unauthorized
                observer.onNext(.failure(error))
                observer.onCompleted()
                return Disposables.create()
            }
            
            COLLECTION_USER.document(uid).getDocument { snapshot, error in
                if let error = error {
                    observer.onNext(.failure(error))
                } else if let data = snapshot?.data() {
                    let user: User = .init(data: data)
                    UserManager.shared.user = user
                    observer.onNext(.success(user))
                } else {
                    let error: MyError = .unknown
                    observer.onNext(.failure(error))
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func userExists(uid: String) -> Observable<Bool> {
        return .create { observer in
            COLLECTION_USER.document(uid).getDocument { snapshot, error in
                if let error = error {
                    observer.onError(error)
                } else if let data = snapshot?.data() {
                    observer.onNext(true)
                } else  {
                    observer.onNext(false)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    
    func createUser(displayname: String, email: String, photoUrl: String) -> Observable<Result<User, Error>> {
        return .create { observer in
            if let uid = Auth.auth().currentUser?.uid {
                let data: [String: Any] = [
                    "userId": uid,
                    "displayName": displayname,
                    "email": email,
                    "photoUrl": photoUrl,
                    "createdAt": Timestamp(date: Date()),
                ]
                COLLECTION_USER.document(uid).setData(data)
                UserManager.shared.user = User(data: data)
            } else {
                let error: MyError = .unauthorized
                observer.onNext(.failure(error))
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func logout(completion: @escaping (() -> Void)) {
        do {
            try Auth.auth().signOut()
            UserManager.shared.resetUserInfo()
            completion()
        } catch {
            print("DEBUG: logout fail")
        }
    }
    
    func leave(completion: @escaping (() -> Void)) {
        if let user = Auth.auth().currentUser, let uid = Auth.auth().currentUser?.uid {
            COLLECTION_USER.document(uid).delete()
            user.delete { error in
                if let error = error {
                    print("DEBUG: \(error.localizedDescription)")
                } else {
                    UserManager.shared.resetUserInfo()
                    completion()
                }
            }
        }
    }
}
