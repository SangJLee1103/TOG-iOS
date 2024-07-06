//
//  OpenAiRepositoryImpl.swift
//  TOG
//
//  Created by 이상준 on 3/24/24.
//

import Alamofire
import RxSwift
import Firebase
import FirebaseFirestore

struct ChatRepositoryImpl: ChatRepository {
    
    static let shared = ChatRepositoryImpl()
    
    func fetchTogMessage(messages: [Message]) -> Observable<TogResponse> {
        return Observable.create { observer in
            let request = AF.streamRequest(ChatRouter.fetchTogMessage(messages: messages)).responseStreamString { stream in
                switch stream.event {
                case .stream(let result):
                    switch result {
                    case .success(let data):
                        let streamResponse = self.parseStreamData(data)
                        streamResponse.forEach { newMessageResponse in
                            observer.onNext(newMessageResponse)
                        }
                    case .failure(let error):
                        print(error)
                        observer.onError(error)
                    }
                case .complete:
                    observer.onCompleted()
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    private func parseStreamData(_ data: String) -> [TogResponse] {
        let responseString = data.split(separator: "data:").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
        let jsonDecoder = JSONDecoder()
        
        return responseString.compactMap { jsonString in
            guard let jsonData = jsonString.data(using: .utf8),
                  let streamResponse = try? jsonDecoder.decode(TogResponse.self, from: jsonData) else { return nil }
            return streamResponse
        }
    }
    
    func createChatRoom(title: String, completion: @escaping (Result<ChatRoom, Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            let error: MyError = .unauthorized
            completion(.failure(error))
            return
        }
        
        let chatRoomId = COLLECTION_CHAT_ROOM.document().documentID
        let data: [String: Any] = [
            "userId": uid,
            "title": title,
            "chatRoomId": chatRoomId,
            "createdAt": Timestamp(date: Date())
        ]
        
        COLLECTION_CHAT_ROOM.addDocument(data: data) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                let chatRoom = ChatRoom(data: data)
                completion(.success(chatRoom))
            }
        }
    }
    
    func fetchLatestChatRoom() -> Observable<Result<ChatRoom, Error>> {
        return .create { observer in
            guard let uid = Auth.auth().currentUser?.uid else {
                let error: MyError = .unauthorized
                observer.onNext(.failure(error))
                observer.onCompleted()
                return Disposables.create()
            }
            
            let query = COLLECTION_CHAT_ROOM.whereField("userId", isEqualTo: uid)
                .order(by: "createdAt", descending: true)
            
            query.getDocuments { snapshot, error in
                if let error = error {
                    observer.onNext(.failure(error))
                } else if let data = snapshot?.documents.first {
                    observer.onNext(.success(ChatRoom(data: data.data())))
                } else {
                    let error: MyError = .unknown
                    observer.onNext(.failure(error))
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func fetchChatRoomList() -> Observable<Result<[ChatRoom], Error>> {
        return .create { observer in
            guard let uid = Auth.auth().currentUser?.uid else {
                let error: MyError = .unauthorized
                observer.onNext(.failure(error))
                observer.onCompleted()
                return Disposables.create()
            }
            
            let query = COLLECTION_CHAT_ROOM.whereField("userId", isEqualTo: uid)
                .order(by: "createdAt", descending: true)
            
            query.getDocuments { snapshot, error in
                if let error = error {
                    observer.onNext(.failure(error))
                } else if let data = snapshot?.documents {
                    let chatRoomList = data.map { ChatRoom(data: $0.data()) }
                    observer.onNext(.success(chatRoomList))
                } else {
                    let error: MyError = .unknown
                    observer.onNext(.failure(error))
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func createChat(question: String, answer: String, roomId: String) -> Observable<Result<ChatRecord, Error>> {
        return .create { observer in
            let data: [String: Any] = [
                "chatId": COLLECTION_CHAT.document().documentID,
                "chatRoomId": roomId,
                "question": question,
                "answer": answer,
                "createdAt": Timestamp(date: Date())
            ]
            COLLECTION_CHAT.addDocument(data: data)
            return Disposables.create()
        }
    }
    
    func fetchChatList(chatRoomId: String) -> Observable<Result<[ChatRecord], Error>> {
        return .create { observer in
            let query = COLLECTION_CHAT.whereField("chatRoomId", isEqualTo: chatRoomId)
                .order(by: "createdAt", descending: false)
            
            query.getDocuments { snapshot, error in
                if let error = error {
                    observer.onNext(.failure(error))
                } else if let data = snapshot?.documents {
                    let chatList = data.map { ChatRecord(data: $0.data()) }
                    observer.onNext(.success(chatList))
                } else {
                    let error: MyError = .unknown
                    observer.onNext(.failure(error))
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func deleteChatRoom(chatRoomId: String) -> Observable<Result<Void, Error>> {
        return .create { observer in
            let chatRoomQuery = COLLECTION_CHAT_ROOM.whereField("chatRoomId", isEqualTo: chatRoomId)
            chatRoomQuery.getDocuments { (snapshot, error) in
                if let error = error {
                    observer.onNext(.failure(error))
                    observer.onCompleted()
                } else if let documents = snapshot?.documents, !documents.isEmpty {
                    let dispatchGroup = DispatchGroup()
                    
                    for document in documents {
                        dispatchGroup.enter()
                        document.reference.delete { error in
                            if let error = error {
                                observer.onNext(.failure(error))
                            }
                            dispatchGroup.leave()
                        }
                    }
                    
                    dispatchGroup.notify(queue: .main) {
                        let chatQuery = COLLECTION_CHAT.whereField("chatRoomId", isEqualTo: chatRoomId)
                        chatQuery.getDocuments { (snapshot, error) in
                            if let error = error {
                                observer.onNext(.failure(error))
                                observer.onCompleted()
                            } else if let documents = snapshot?.documents, !documents.isEmpty {
                                for document in documents {
                                    dispatchGroup.enter()
                                    document.reference.delete { error in
                                        if let error = error {
                                            observer.onNext(.failure(error))
                                        }
                                        dispatchGroup.leave()
                                    }
                                }
                                
                                dispatchGroup.notify(queue: .main) {
                                    observer.onNext(.success(()))
                                    observer.onCompleted()
                                }
                            } else {
                                observer.onNext(.success(()))
                                observer.onCompleted()
                            }
                        }
                    }
                } else {
                    observer.onNext(.failure(MyError.notFound))
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}
