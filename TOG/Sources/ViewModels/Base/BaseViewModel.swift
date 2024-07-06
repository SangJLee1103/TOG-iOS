//
//  BaseViewModel.swift
//  TOG
//
//  Created by 이상준 on 5/2/24.
//

import RxSwift
import RxCocoa
import NSObject_Rx

class BaseViewModel: HasDisposeBag {
    let error = PublishRelay<Error>()
    
    init() {}
}
