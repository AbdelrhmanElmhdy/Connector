//
//  UserServiceTests.swift
//  ConnectorTests
//
//  Created by Abdelrhman Elmahdy on 18/12/2022.
//

import XCTest
import CoreData
@testable import Connector

class UserServiceTests: XCTestCase {
    let coreDataManagerMock = CoreDataManagerMock()
    let userNetworkServiceMock = UserNetworkServiceMock()
    let authServiceMock = AuthServiceMock()
    
    let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    lazy var stubsFactory = StubsFactory(context: context)
        
    func createSUT() -> RealUserService {
        RealUserService(coreDataManager: coreDataManagerMock,
                        userNetworkService: userNetworkServiceMock,
                        authService: authServiceMock)
    }
    
    func testUserCreation() {
        // Given
        let sut = createSUT()
        coreDataManagerMock.context = context
        
        // When
        let user = sut.createUser()
        
        // Then
        XCTAssert(user.entity == User.entity())
    }
    
    func testUserFetchWithObjectID() throws {
        // Given
        let sut = createSUT()
        let stubbedUser = stubsFactory.createUserStub()
        coreDataManagerMock.fetchManagedObjectWithObjectIDReturnValue = stubbedUser
        
        // When
        let user = try sut.fetchUser(withObjectID: NSManagedObjectID())
        
        // Then
        XCTAssertEqual(user, stubbedUser)
    }
    
    func testUsersFetch() {
        // Given
        let sut = createSUT()
        let stubbedUsers = stubsFactory.createUserStubs(3)
        coreDataManagerMock.fetchManagedObjectsOfTypeWithObjectIDsReturnValue = stubbedUsers
        
        // When
        let users = sut.fetchUsers(withObjectIDs: stubbedUsers.map { $0.objectID })
        
        // Then
        XCTAssertEqual(users, stubbedUsers)
    }
    
    func testUserFetchWithID() {
        // Given
        let sut = createSUT()
        let stubbedUser = stubsFactory.createUserStub()
        coreDataManagerMock.fetchManagedObjectOfTypeWithIDReturnValue = stubbedUser
        
        // When
        let user = sut.fetchUser(withId: "1")
        
        // Then
        XCTAssertEqual(user, stubbedUser)
    }
    
    func testUserFetchWithUsername() {
        // Given
        let sut = createSUT()
        let stubbedUser = stubsFactory.createUserStub()
        coreDataManagerMock.fetchManagedObjectsOfTypePredicateFetchLimitReturnValue = [stubbedUser]
        
        // When
        let user = sut.fetchUser(withUsername: "u")
        
        // Then
        XCTAssertEqual(user, stubbedUser)
    }
        
    func testCurrentUserRetrievalErrorWhenNotLoggedIn() {
        let sut = createSUT()
        authServiceMock.isLoggedIn = false
        
        XCTAssertThrowsError(try sut.getCurrentUser())
    }
    
    func testCurrentUserRetrievalErrorWhenUsernameIsEmpty() {
        let sut = createSUT()
        authServiceMock.isLoggedIn = true
        authServiceMock.username = ""
        
        XCTAssertThrowsError(try sut.getCurrentUser())
    }
    
    func testSuccessfulCurrentUserRetrieval() throws {
        // Given
        let sut = createSUT()
        authServiceMock.isLoggedIn = true
        authServiceMock.username = "u"
        
        let stubbedUser = stubsFactory.createUserStub()
        coreDataManagerMock.fetchManagedObjectsOfTypePredicateFetchLimitReturnValue = [stubbedUser]
        
        // When
        let user = try sut.getCurrentUser()
        
        // Then
        XCTAssertEqual(user, stubbedUser)
    }
    
    func testUserDeletion() {
        // Given
        let sut = createSUT()
        let toBeDeletedUser = stubsFactory.createUserStub()
        coreDataManagerMock.fetchManagedObjectsOfTypePredicateFetchLimitReturnValue = [toBeDeletedUser]
        
        // When
        sut.deleteUser(username: "u")
        
        // Then
        XCTAssertEqual(coreDataManagerMock.deleteManagedObjectCallsCount, 1)
        XCTAssertEqual(coreDataManagerMock.deleteManagedObjectReceivedObject, toBeDeletedUser)
    }
    
    func testPreparationToMoveUsersToDifferentThread() throws {
        // Given
        let sut = createSUT()
        let stubbedUsers = stubsFactory.createUserStubs(3)
        let stubbedUsersObjectIDs = stubbedUsers.map { $0.objectID }
        
        coreDataManagerMock.prepareToMoveToDifferentThreadReceivedObjects = stubbedUsers
        coreDataManagerMock.prepareToMoveToDifferentThreadReturnValue = stubbedUsersObjectIDs
        
        // When
        let preparedToCrossThreadsObjectIDs = try sut.prepareToMoveUsersToDifferentThread(stubbedUsers)
        
        // Then
        XCTAssertEqual(preparedToCrossThreadsObjectIDs, stubbedUsersObjectIDs)
    }
}
