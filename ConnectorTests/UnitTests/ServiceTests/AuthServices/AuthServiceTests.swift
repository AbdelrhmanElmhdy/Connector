//
//  AuthServiceTests.swift
//  ConnectorTests
//
//  Created by Abdelrhman Elmahdy on 18/12/2022.
//

import XCTest
import Combine
import CoreData
@testable import Connector

class AuthServiceTests: XCTestCase {
  let userDefaultsManagerMock = UserDefaultsManagerMock()
  let keychainManagerMock = KeychainManagerMock()
  let coreDataManagerMock = CoreDataManagerMock()
  let authNetworkServiceMock = AuthNetworkServiceMock()
  let userServiceMock = UserServiceMock()
  
  var subscriptions = Set<AnyCancellable>()
  let stubsFactory = StubsFactory(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
  
  func createSUT() -> MainAuthService {
      let authService = MainAuthService(userDefaultsManager: userDefaultsManagerMock,
                                keychainManager: keychainManagerMock,
                                coreDataManager: coreDataManagerMock,
                                authNetworkService: authNetworkServiceMock)
      authService.userService = userServiceMock
      return authService
  }
  
  func testSuccessfulLogin() {
      // Given
      let sut = createSUT()
      authNetworkServiceMock.loginEmailPasswordCompletionClosure = { _, _, completion in
        completion("t", nil)
      }
      
      userServiceMock.fetchRemoteUserWithIdCompletionClosure = { _, completion in
        completion(self.stubsFactory.makeUserStub(), nil)
      }
      
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
  
  func testStateAfterSuccessfulLogin() {
      // Given
      let sut = createSUT()
      let stubbedUserID = "1"
      let stubbedUsername = "u"
      authNetworkServiceMock.loginEmailPasswordCompletionClosure = { _, _, completion in
        completion(stubbedUserID, nil)
      }
      
      userServiceMock.fetchRemoteUserWithIdCompletionClosure = { _, completion in
        let user = self.stubsFactory.makeUserStub()
        user.username = stubbedUsername
        completion(user, nil)
      }
            
      // When
      sut.login(email: "t@t.com", password: "t")
        .sink(receiveCompletion: {_ in }, receiveValue: {})
        .store(in: &subscriptions)
      
      // Then
      XCTAssertEqual(sut.isLoggedIn, true)
      XCTAssertEqual(sut.username, stubbedUsername)
      XCTAssertEqual(sut.userId, stubbedUserID)
  }
  
  func testLoginShouldFailWhenAnErrorIsReturned() {
      // Given
      let sut = createSUT()
      authNetworkServiceMock.loginEmailPasswordCompletionClosure = { _, _, completion in
        completion(nil, FirebaseAuthError.userNotFound())
      }
      
      userServiceMock.fetchRemoteUserWithIdCompletionClosure = { _, completion in
        completion(nil, nil)
      }
      
      let didFailLogin = XCTestExpectation(description: #function)
      
      // When
      sut.login(email: "t@t.com", password: "t")
        .sink { completion in
            switch completion {
            case .failure(let error):
              if (error as? FirebaseAuthError)?.userFriendlyDescription == FirebaseAuthError.userNotFound().userFriendlyDescription {
                  didFailLogin.fulfill()
              }
            case .finished:
              didFailLogin.isInverted = true
              didFailLogin.fulfill()
            }
        } receiveValue: {}
        .store(in: &subscriptions)
      
      // Then
      wait(for: [didFailLogin], timeout: 0.1)
  }
  
  func testLoginShouldFailWhenUserServiceFailsToRetrieveUser() {
      // Given
      let sut = createSUT()
      authNetworkServiceMock.loginEmailPasswordCompletionClosure = { _, _, completion in
        completion("1", nil)
      }
      
      userServiceMock.fetchRemoteUserWithIdCompletionClosure = { _, completion in
        completion(nil, nil)
      }
      
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
      
  func testSuccessfulSignup() {
      // Given
      let sut = createSUT()
      authNetworkServiceMock.signupUserPasswordCompletionClosure = { _, _, completion in
        completion("1", nil)
      }
      
      let didFinishSignup = XCTestExpectation(description: #function)
      
      // When
      sut.signup(user: stubsFactory.makeUserStub(), password: "t")
        .sink { completion in
            switch completion {
            case .failure:
              didFinishSignup.isInverted = true
              didFinishSignup.fulfill()
            case .finished:
              didFinishSignup.fulfill()
            }
        } receiveValue: {}
        .store(in: &subscriptions)
      
      // Then
      wait(for: [didFinishSignup], timeout: 0.1)
  }
  
  func testStateAfterSuccessfulSignup() {
      // Given
      let sut = createSUT()
      let stubbedUser = stubsFactory.makeUserStub()
      stubbedUser.username = "u"
      let stubbedUserID = "1"
      
      authNetworkServiceMock.signupUserPasswordCompletionClosure = { _, _, completion in
        completion(stubbedUserID, nil)
      }
            
      // When
      sut.signup(user: stubbedUser, password: "t")
        .sink(receiveCompletion: {_ in }, receiveValue: {})
        .store(in: &subscriptions)
      
      // Then
      XCTAssertEqual(sut.isLoggedIn, true)
      XCTAssertEqual(sut.username, stubbedUser.username)
      XCTAssertEqual(sut.userId, stubbedUserID)
  }
  
  func testSignupShouldSetUserDataWithCorrectArgument() {
      // Given
      let sut = createSUT()
      let stubbedUser = stubsFactory.makeUserStub()
      authNetworkServiceMock.signupUserPasswordCompletionClosure = { _, _, completion in
        completion("1", nil)
      }
            
      // When
      sut.signup(user: stubbedUser, password: "t")
        .sink(receiveCompletion: {_ in }, receiveValue: {})
        .store(in: &subscriptions)
      
      // Then
      XCTAssertEqual(userServiceMock.setRemoteUserDataUserCallsCount, 1)
      XCTAssertEqual(userServiceMock.setRemoteUserDataUserReceivedUser, stubbedUser)
  }
  
  func testSignupShouldFailWhenAnErrorIsReturned() {
      // Given
      let sut = createSUT()
      let stubbedUser = stubsFactory.makeUserStub()
      let stubbedError = FirebaseAuthError.emailAlreadyInUse()
      authNetworkServiceMock.signupUserPasswordCompletionClosure = { _, _, completion in
        completion(nil, stubbedError)
      }
      
      let didFailSignup = XCTestExpectation(description: #function)
      
      // When
      sut.signup(user: stubbedUser, password: "t")
        .sink { completion in
            switch completion {
            case .failure(let error):
              if (error as? FirebaseAuthError)?.userFriendlyDescription == stubbedError.userFriendlyDescription {
                  didFailSignup.fulfill()
              }
            case .finished:
              didFailSignup.isInverted = true
              didFailSignup.fulfill()
            }
        } receiveValue: {}
        .store(in: &subscriptions)
      
      // Then
      wait(for: [didFailSignup], timeout: 0.1)
  }
  
  func testSignOutCallsAuthNetworkServiceSignOutMethodOnce() throws {
      // Given
      let sut = createSUT()
      // When
      try sut.signOut()
      // Then
      XCTAssertEqual(authNetworkServiceMock.signOutCallsCount, 1)
  }
  
  func testSignOutDeletesCurrentUser() throws {
      // Given
      let sut = createSUT()
      sut.username = "u"
      
      // When
      try sut.signOut()
      
      // Then
      XCTAssertEqual(userServiceMock.deleteUserUsernameReceivedUsername, "u")
  }
  
  func testSignOutResetsState() throws {
      // Given
      let sut = createSUT()
      
      // When
      try sut.signOut()
      
      // Then
      XCTAssertEqual(sut.isLoggedIn, false)
      XCTAssertEqual(sut.username, "")
      XCTAssertEqual(sut.userId, "")
  }
}
