//
//  AddContactFeature.swift
//  TCA_Simple_Tests
//
//  Created by 최동호 on 1/14/24.
//

import ComposableArchitecture

@Reducer
struct AddContactFeature {
    @ObservableState
    struct State: Equatable {
        var contact: Contact
    }
    enum Action {
        case cancelButtonTapped
        case delegate(Delegate)
        case saveButtonTapped
        case setName(String)
        @CasePathable
        enum Delegate: Equatable {
            case saveContact(Contact)
        }
    }
    
    @Dependency(\.dismiss) var dismiss

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .cancelButtonTapped:
                return .run { _ in await self.dismiss() }
                
            case .delegate:
                return .none
                
            case .saveButtonTapped:
                return .run { [contact = state.contact] send in
                    await send(.delegate(.saveContact(contact)))
                    await self.dismiss()
                }

            case let .setName(name):
                state.contact.name = name
                return .none
            }
        }
    }
}
