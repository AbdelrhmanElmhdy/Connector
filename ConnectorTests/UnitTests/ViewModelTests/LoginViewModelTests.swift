//
//  LoginViewModelTests.swift
//  ConnectorTests
//
//  Created by Abdelrhman Elmahdy on 15/12/2022.
//

import XCTest
import Combine
@testable import Connector

class LoginViewModelTests: XCTestCase {
  let authServiceMock = AuthServiceMock()
  let userServiceMock = UserServiceMock()
  var subscriptions = Set<AnyCancellable>()
  
  func createSUT() -> LoginViewModel {
      LoginViewModel(authService: authServiceMock, userService: userServiceMock)
  }
  
  func testSuccessfulLogin() {
      // Given
      authServiceMock.loginEmailPasswordReturnValue = Future() { $0(.success(())) }
      let sut = createSUT()
      let didFinishLogin = XCTestExpectation(description: #function)
      
      // When
      sut.login(email: "t@t.com", password: "t")
        .sink { completion in
            switch completion {
            case .failure:
              didFinishLogin.isInverted = true
              didFinishLogin.fulfill()
            case .finished:
              didFinishLogin.fulfill()
            }
        } receiveValue: {}
        .store(in: &subscriptions)
      
      // Then
      wait(for: [didFinishLogin], timeout: 0.1)
  }
  
  func testLoginShouldFailWhenCompletionIsFailure() {
      // Given
      authServiceMock.loginEmailPasswordReturnValue = Future() { $0(.failure(FirebaseAuthError.emailAlreadyInUse())) }
      
      let sut = createSUT()
      let didFailLogin = XCTestExpectation(description: #function)
      
      // When
      sut.login(email: "t@t.com", password: "t")
        .sink { completion in
            switch completion {
            case .failure:
              didFailLogin.fulfill()
            case .finished:
              didFailLogin.isInverted = true
              didFailLogin.fulfill()
            }
        } receiveValue: {}
        .store(in: &subscriptions)
      
      // Then
      wait(for: [didFailLogin], timeout: 0.1)
  }

}
