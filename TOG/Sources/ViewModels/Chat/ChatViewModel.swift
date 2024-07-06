//
//  ChatViewModel.swift
//  TOG
//
//  Created by 이상준 on 3/27/24.
//

import RxSwift
import RxCocoa
import Firebase
import Tiktoken

final class ChatViewModel: BaseViewModel {
    
    private let chatRepository: ChatRepository
    
    var chatRoomId = BehaviorRelay<String?>(value: nil)
    let messages = BehaviorRelay<[ChatMessage]>(value: [])
    let prompt = BehaviorRelay<String>(value: "")
    let isValidSend = BehaviorRelay(value: false)
    let isEnableCreateNewChat = BehaviorRelay(value: true)
    let isAnimating = BehaviorRelay(value: false) // for send button
    
    init(chatRepository: ChatRepository) {
        self.chatRepository = chatRepository
        super.init()
        fetchLatestChatRoom()
        bind()
    }
    
    private func bind() {
        chatRoomId
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] roomId in
                self?.fetchChatList(chatRoomId: roomId)
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(prompt.distinctUntilChanged(), isAnimating)
            .map { prompt, isAnimating in
                return !isAnimating && self.isEnabledButton(prompt)
            }
            .bind(to: isValidSend)
            .disposed(by: disposeBag)
        
        messages
            .map { !$0.isEmpty }
            .bind(to: isEnableCreateNewChat)
            .disposed(by: disposeBag)
    }
    
    func fetchTogMessage(prompt: String) {
        isAnimating.accept(true)
        let userMessage = ChatMessage(sender: "You", content: prompt)
        let loadingMessage = ChatMessage(sender: "토그", content: "로딩중")
        
        messages.accept(messages.value + [userMessage, loadingMessage])
        
        if let chatRoomId = chatRoomId.value {
            sendTogMessage(prompt: prompt, chatRoomId: chatRoomId)
        } else {
            createChatRoom(prompt: prompt)
        }
    }
    
    private func createChatRoom(prompt: String) {
        chatRepository.createChatRoom(title: prompt) { [weak self] result in
            switch result {
            case .success(let chatRoom):
                self?.chatRoomId.accept(chatRoom.chatRoomId)
                self?.sendTogMessage(prompt: prompt, chatRoomId: chatRoom.chatRoomId)
            case .failure(let error):
                print("Failed to create chat room: \(error)")
                self?.error.accept(error)
            }
        }
    }
    
    private func sendTogMessage(prompt: String, chatRoomId: String) {
        var currentMessageContent = ""
        var isNewMessage = false
        
        getChatsParamsMessages(chatRoomId: chatRoomId, prompt: prompt)
            .flatMap { requestMessages -> Observable<TogResponse> in
                self.chatRepository.fetchTogMessage(messages: requestMessages)
            }
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                if let messageContent = response.choices.first?.delta.content {
                    if !isNewMessage {
                        self.clearLastTogMessage() // 로딩중을 비움
                        isNewMessage = true
                    }
                    
                    currentMessageContent += messageContent
                    self.updateTogCellContent(content: messageContent)
                }
                
                if response.choices.first?.finishReason == "stop" {
                    self.finalizeTogMessage(content: currentMessageContent, prompt: prompt, chatRoomId: chatRoomId)
                    currentMessageContent = ""
                    isNewMessage = true
                }
            }, onError: { [weak self] error in
                print("Error Send TogMessage: \(error.localizedDescription)")
                self?.error.accept(error)
            })
            .disposed(by: disposeBag)
    }
    
    private func clearLastTogMessage() {
        var messages = self.messages.value
        if let lastMessage = messages.last, lastMessage.sender == "토그" {
            var updatedMessage = lastMessage
            updatedMessage.content = ""
            messages[messages.count - 1] = updatedMessage
            self.messages.accept(messages)
        }
    }
    
    private func updateTogCellContent(content: String) {
        var messages = self.messages.value
        
        if let lastMessage = messages.last, lastMessage.sender == "토그" {
            var updatedMessage = lastMessage
            updatedMessage.content += content
            messages[messages.count - 1] = updatedMessage
            self.messages.accept(messages)
        }
    }
    
    private func finalizeTogMessage(content: String, prompt: String, chatRoomId: String) {
        updateTogCellContent(content: content)
        self.createChat(question: prompt, answer: content, roomId: chatRoomId)
        self.isAnimating.accept(false)
    }

    
    private func getChatsParamsMessages(chatRoomId: String, prompt: String) -> Observable<[Message]> {
        return chatRepository.fetchChatList(chatRoomId: chatRoomId)
            .flatMap { result -> Observable<[Message]> in
                switch result {
                case .success(let chatRecords):
                    return Observable.create { observer in
                        Task {
                            var response: [Message] = [Message(role: "system", content: TogAssistant.prompt)]
                            var totalTokens = await self.countToken(message: TogAssistant.prompt)
                            
                            for record in chatRecords {
                                let questionTokens = await self.countToken(message: record.question)
                                if totalTokens + questionTokens <= 4096 - 300 {
                                    response.append(Message(role: "user", content: record.question))
                                    totalTokens += questionTokens
                                } else {
                                    break
                                }
                                
                                if record.answer != "로딩중" {
                                    let answerTokens = await self.countToken(message: record.answer)
                                    if totalTokens + answerTokens <= 4096 - 300 {
                                        response.append(Message(role: "system", content: record.answer))
                                        totalTokens += answerTokens
                                    } else {
                                        break
                                    }
                                }
                            }
                            response.append(Message(role: "user", content: prompt))
                            observer.onNext(response)
                            observer.onCompleted()
                        }
                        return Disposables.create()
                    }
                case .failure:
                    return Observable.just([Message(role: "system", content: TogAssistant.prompt), Message(role: "user", content: prompt)])
                }
            }
    }
    
    private func countToken(message: String) async -> Int {
        do {
            let encoder = try await Tiktoken.shared.getEncoding("gpt-4")
            let tokens = encoder?.encode(value: message)
            return tokens?.count ?? 0
        } catch {
            print("Token counting error: \(error)")
            return 0
        }
    }
    
    func fetchLatestChatRoom() {
        chatRepository.fetchLatestChatRoom()
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let chatRoom):
                    self?.chatRoomId.accept(chatRoom.chatRoomId)
                case .failure(let error):
                    print("Failed to fetch latest chat room: \(error.localizedDescription)")
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func createChat(question: String, answer: String, roomId: String) {
        chatRepository.createChat(question: question, answer: answer, roomId: roomId)
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success:
                    self?.fetchChatList(chatRoomId: roomId)
                case .failure(let error):
                    print("Failed to create chat: \(error.localizedDescription)")
                    self?.error.accept(error)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func fetchChatList(chatRoomId: String) {
        chatRepository.fetchChatList(chatRoomId: chatRoomId)
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let data):
                    if !data.isEmpty {
                        let chatList = data.flatMap { record -> [ChatMessage] in
                            var messages = [ChatMessage]()
                            if !record.question.isEmpty {
                                messages.append(ChatMessage(sender: "YOU", content: record.question))
                            }
                            if !record.answer.isEmpty {
                                messages.append(ChatMessage(sender: "토그", content: record.answer))
                            }
                            return messages
                        }
                        self?.messages.accept(chatList)
                    }
                case .failure(let error):
                    print("Failed to fetch chat list: \(error.localizedDescription)")
                    self?.error.accept(error)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func isEnabledButton(_ prompt: String) -> Bool {
        return prompt != "토그에게 무엇이든 물어보세요." && prompt.count > 0
    }
}
