//
//  SideViewModel.swift
//  TOG
//
//  Created by 이상준 on 4/8/24.
//

import RxSwift
import RxCocoa

final class SideViewModel: BaseViewModel {
    
    private let chatRepository: ChatRepository
    
    var chatRoomList: BehaviorRelay<[ChatRoom]> = BehaviorRelay(value: [])
    
    init(chatRepository: ChatRepository) {
        self.chatRepository = chatRepository
        
        super.init()
        fetchChatRoomList()
    }
    
    private func fetchChatRoomList() {
        chatRepository.fetchChatRoomList()
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let data):
                    self?.chatRoomList.accept(data)
                case .failure(let error):
                    print("DEBUG: fetchChatRoom List fail", error.localizedDescription)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func deleteChatRoom(chatRoomId: String) -> Observable<Result<Void, Error>> {
        return chatRepository.deleteChatRoom(chatRoomId: chatRoomId)
            .do(onNext: { [weak self] result in
                switch result {
                case .success(_):
                    self?.fetchChatRoomList()
                case .failure(let error):
                    print("DEBUG: delete ChatRoom fail", error.localizedDescription)
                }
            })
    }
}
