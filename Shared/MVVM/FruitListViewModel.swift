//
//  FruitListViewModel.swift
//  Shopfront
//
//  Created by denpazakura on 27/08/2021.
//

import Foundation
import Combine

final class FruitListViewModel: ObservableObject {
    @Published private(set) var state = State.idle
    
    private var bag = Set<AnyCancellable>()
    private let input = PassthroughSubject<Event, Never>()
        
    init() {
        Publishers.system(
            initial: state,
            reduce: Self.reduce,
            scheduler: RunLoop.main,
            feedbacks: [
                Self.whenLoading(),
                Self.userInput(input: input.eraseToAnyPublisher())
            ]
        )
        .assign(to: \.state, on: self)
        .store(in: &bag)
    }
    
    deinit {
        bag.removeAll()
    }
    
    func send(event: Event) {
        input.send(event)
    }
}

// MARK: - Inner Types

extension FruitListViewModel {
    enum State {
        case idle
        case loading
        case loaded([FruitListItem])
        case error(Error)
    }
    
    enum Event {
        case onAppear
        case onSelectItem(Int)
        case onItemsLoaded([FruitListItem])
        case onFailedToLoadItems(Error)
    }
    
    struct FruitListItem: Identifiable {        
        let id = UUID()
        let title: String
        let url: URL?
        let filename: String
        
        init(image: UnsplashImage) {
            title = image.creator
            url = URL(string: image.unsplash_url)
            filename = image.filename
        }
    }
}

// MARK: - State Machine

extension FruitListViewModel {
    static func reduce(_ state: State, _ event: Event) -> State {
        switch state {
        case .idle:
            switch event {
            case .onAppear:
                return .loading
            default:
                return state
            }
        case .loading:
            switch event {
            case .onFailedToLoadItems(let error):
                return .error(error)
            case .onItemsLoaded(let items):
                return .loaded(items)
            default:
                return state
            }
        case .loaded:
            return state
        case .error:
            return state
        }
    }
    
    static func whenLoading() -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard case .loading = state else { return Empty().eraseToAnyPublisher() }
            
            return FruitshopAPI.trending()
                .map { $0.map(FruitListItem.init(image: )) }
                .map(Event.onItemsLoaded)
                .catch { Just(Event.onFailedToLoadItems($0)) }
                .eraseToAnyPublisher()
        }
    }
    
    static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback { _ in input }
    }
}
