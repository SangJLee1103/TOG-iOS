//
//  TermsViewModel.swift
//  TOG
//
//  Created by 이상준 on 5/2/24.
//

import RxSwift
import RxCocoa

enum TermsButtonType {
    case allAgree
    case requiredFirst
    case requiredSecond
    case notRequiredThird
    case requiredFourth
}

struct Input {
    let buttonTapped = PublishRelay<TermsButtonType>()
}

final class TermsViewModel: BaseViewModel {
    let allAgreeIsSelected = BehaviorRelay<Bool>(value: false)
    let requiredFirstIsSelected = BehaviorRelay<Bool>(value: false)
    let requiredSecondIsSelected = BehaviorRelay<Bool>(value: false)
    let notRequiredThirdIsSelected = BehaviorRelay<Bool>(value: false)
    let requiredFourthIsSelected = BehaviorRelay<Bool>(value: false)
    let nextButtonEnabled = BehaviorRelay<Bool>(value: false)
    
    let input = Input()
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
        super.init()
        bind()
    }
    
    private func bind() {
        input.buttonTapped
            .bind { [weak self] type in
                guard let self = self else { return }
                switch type {
                case .allAgree:
                    let preValue = self.allAgreeIsSelected.value
                    [self.allAgreeIsSelected,
                     self.requiredFirstIsSelected,
                     self.requiredSecondIsSelected,
                     self.notRequiredThirdIsSelected,
                     self.requiredFourthIsSelected]
                        .forEach { $0.accept(!preValue) }
                case .requiredFirst:
                    self.requiredFirstIsSelected.accept(!requiredFirstIsSelected.value)
                case .requiredSecond:
                    self.requiredSecondIsSelected.accept(!requiredSecondIsSelected.value)
                case .notRequiredThird:
                    self.notRequiredThirdIsSelected.accept(!notRequiredThirdIsSelected.value)
                case .requiredFourth:
                    self.requiredFourthIsSelected.accept(!requiredFourthIsSelected.value)
                }
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            requiredFirstIsSelected,
            requiredSecondIsSelected,
            notRequiredThirdIsSelected,
            requiredFourthIsSelected
        ) { $0 && $1 && $2 && $3 }
            .bind(to: allAgreeIsSelected)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            requiredFirstIsSelected,
            requiredSecondIsSelected,
            requiredFourthIsSelected
        ) { $0 && $1 && $2 }
            .bind(to: nextButtonEnabled)
            .disposed(by: disposeBag)
    }
}
