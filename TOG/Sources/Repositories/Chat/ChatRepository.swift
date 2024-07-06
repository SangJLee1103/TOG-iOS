//
//  OpenAIRepository.swift
//  TOG
//
//  Created by 이상준 on 3/24/24.
//

import Foundation
import RxSwift

protocol ChatRepository {
    func fetchTogMessage(messages: [Message]) -> Observable<TogResponse> 
    func createChatRoom(title: String, completion: @escaping (Result<ChatRoom, Error>) -> Void)
    func fetchLatestChatRoom() -> Observable<Result<ChatRoom, Error>>
    func fetchChatRoomList() -> Observable<Result<[ChatRoom], Error>>
    func createChat(question: String, answer: String, roomId: String) -> Observable<Result<ChatRecord, Error>>
    func fetchChatList(chatRoomId: String) -> Observable<Result<[ChatRecord], Error>>
    func deleteChatRoom(chatRoomId: String) -> Observable<Result<Void, Error>>
}
