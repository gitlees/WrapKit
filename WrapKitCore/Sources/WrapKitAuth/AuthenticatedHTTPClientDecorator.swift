//
//  AuthenticatedHTTPClientDecorator.swift
//  WrapKitAuth
//
//  Created by Stas Lee on 25/7/23.
//

import Foundation

public class AuthenticatedHTTPClientDecorator: HTTPClient {
    public typealias EnrichRequestWithToken = ((URLRequest, String) -> URLRequest)
    public typealias AuthenticationPolicy = (((Data, HTTPURLResponse)) -> Bool)
    
    private let decoratee: HTTPClient
    private let accessTokenStorage: any Storage<String>
    private let tokenRefresher: TokenRefresher?
    private let onNotAuthenticated: (() -> Void)?
    private let enrichRequestWithToken: EnrichRequestWithToken
    private let isAuthenticated: AuthenticationPolicy
    
    public init(
        decoratee: HTTPClient,
        accessTokenStorage: any Storage<String>,
        tokenRefresher: TokenRefresher?,
        onNotAuthenticated: (() -> Void)? = nil,
        enrichRequestWithToken: @escaping EnrichRequestWithToken,
        isAuthenticated: @escaping AuthenticationPolicy
    ) {
        self.decoratee = decoratee
        self.accessTokenStorage = accessTokenStorage
        self.tokenRefresher = tokenRefresher
        self.onNotAuthenticated = onNotAuthenticated
        self.enrichRequestWithToken = enrichRequestWithToken
        self.isAuthenticated = isAuthenticated
    }

    public func dispatch(_ request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        return dispatch(request, completion: completion, isRetryNeeded: true)
    }
    
    private func dispatch(_ request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void, isRetryNeeded: Bool) -> HTTPClientTask {
        let compositeTask = CompositeHTTPClientTask()

        guard let token = accessTokenStorage.get() else {
            onNotAuthenticated?()
            completion(.failure(ServiceError.notAuthorized))
            return compositeTask
        }

        let enrichedRequest = enrichRequestWithToken(request, token)
        let firstTask = decoratee.dispatch(enrichedRequest) { [weak self] result in
            switch result {
            case .success(let (data, response)):
                if self?.isAuthenticated((data, response)) ?? false {
                    completion(.success((data, response)))
                } else if let tokenRefresher = self?.tokenRefresher, isRetryNeeded {
                    tokenRefresher.refresh { refreshResult in
                        switch refreshResult {
                        case .success(let newToken):
                            self?.accessTokenStorage.set(model: newToken, completion: nil)
                            let newTask = self?.dispatch(request, completion: completion, isRetryNeeded: false)
                            if let newTask = newTask {
                                compositeTask.add(newTask)
                                newTask.resume()
                            }
                        case .failure:
                            self?.accessTokenStorage.clear(completion: nil)
                            self?.onNotAuthenticated?()
                            completion(.failure(ServiceError.notAuthorized))
                        }
                    }
                } else {
                    self?.accessTokenStorage.clear(completion: nil)
                    self?.onNotAuthenticated?()
                    completion(.failure(ServiceError.notAuthorized))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }

        compositeTask.add(firstTask)
        firstTask.resume()
        return compositeTask
    }
}
