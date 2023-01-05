// Generated using Sourcery 1.9.2 — https://github.com/krzysztofzablocki/Sourcery

import Foundation
import CoreData
@testable import Connector


class ChatRoomServiceMock: ChatRoomService {



  //MARK: - createChatRoom

  var createChatRoomWithParticipantsCallsCount = 0
  var createChatRoomWithParticipantsCalled: Bool {
      return createChatRoomWithParticipantsCallsCount > 0
  }
  var createChatRoomWithParticipantsReceivedParticipants: [User]?
  var createChatRoomWithParticipantsReceivedInvocations: [[User]] = []
  var createChatRoomWithParticipantsReturnValue: ChatRoom?
  var createChatRoomWithParticipantsClosure: (([User]) -> ChatRoom?)?

  func createChatRoom(withParticipants participants: [User]) -> ChatRoom? {
      createChatRoomWithParticipantsCallsCount += 1
      createChatRoomWithParticipantsReceivedParticipants = participants
      createChatRoomWithParticipantsReceivedInvocations.append(participants)
      if let createChatRoomWithParticipantsClosure = createChatRoomWithParticipantsClosure {
        return createChatRoomWithParticipantsClosure(participants)
      } else {
        return createChatRoomWithParticipantsReturnValue
      }
  }

  //MARK: - fetchChatRoom

  var fetchChatRoomWithObjectIDThrowableError: Error?
  var fetchChatRoomWithObjectIDCallsCount = 0
  var fetchChatRoomWithObjectIDCalled: Bool {
      return fetchChatRoomWithObjectIDCallsCount > 0
  }
  var fetchChatRoomWithObjectIDReceivedObjectID: NSManagedObjectID?
  var fetchChatRoomWithObjectIDReceivedInvocations: [NSManagedObjectID] = []
  var fetchChatRoomWithObjectIDReturnValue: ChatRoom?
  var fetchChatRoomWithObjectIDClosure: ((NSManagedObjectID) throws -> ChatRoom?)?

  func fetchChatRoom(withObjectID objectID: NSManagedObjectID) throws -> ChatRoom? {
      if let error = fetchChatRoomWithObjectIDThrowableError {
        throw error
      }
      fetchChatRoomWithObjectIDCallsCount += 1
      fetchChatRoomWithObjectIDReceivedObjectID = objectID
      fetchChatRoomWithObjectIDReceivedInvocations.append(objectID)
      if let fetchChatRoomWithObjectIDClosure = fetchChatRoomWithObjectIDClosure {
        return try fetchChatRoomWithObjectIDClosure(objectID)
      } else {
        return fetchChatRoomWithObjectIDReturnValue
      }
  }

  //MARK: - fetchChatRooms

  var fetchChatRoomsWithObjectIDsCallsCount = 0
  var fetchChatRoomsWithObjectIDsCalled: Bool {
      return fetchChatRoomsWithObjectIDsCallsCount > 0
  }
  var fetchChatRoomsWithObjectIDsReceivedObjectIDs: [NSManagedObjectID]?
  var fetchChatRoomsWithObjectIDsReceivedInvocations: [[NSManagedObjectID]] = []
  var fetchChatRoomsWithObjectIDsReturnValue: [ChatRoom]?
  var fetchChatRoomsWithObjectIDsClosure: (([NSManagedObjectID]) -> [ChatRoom]?)?

  func fetchChatRooms(withObjectIDs objectIDs: [NSManagedObjectID]) -> [ChatRoom]? {
      fetchChatRoomsWithObjectIDsCallsCount += 1
      fetchChatRoomsWithObjectIDsReceivedObjectIDs = objectIDs
      fetchChatRoomsWithObjectIDsReceivedInvocations.append(objectIDs)
      if let fetchChatRoomsWithObjectIDsClosure = fetchChatRoomsWithObjectIDsClosure {
        return fetchChatRoomsWithObjectIDsClosure(objectIDs)
      } else {
        return fetchChatRoomsWithObjectIDsReturnValue
      }
  }

  //MARK: - fetchChatRoom

  var fetchChatRoomWithParticipantsIDsCallsCount = 0
  var fetchChatRoomWithParticipantsIDsCalled: Bool {
      return fetchChatRoomWithParticipantsIDsCallsCount > 0
  }
  var fetchChatRoomWithParticipantsIDsReceivedParticipantsIDs: [String]?
  var fetchChatRoomWithParticipantsIDsReceivedInvocations: [[String]] = []
  var fetchChatRoomWithParticipantsIDsReturnValue: ChatRoom?
  var fetchChatRoomWithParticipantsIDsClosure: (([String]) -> ChatRoom?)?

  func fetchChatRoom(withParticipantsIDs participantsIDs: [String]) -> ChatRoom? {
      fetchChatRoomWithParticipantsIDsCallsCount += 1
      fetchChatRoomWithParticipantsIDsReceivedParticipantsIDs = participantsIDs
      fetchChatRoomWithParticipantsIDsReceivedInvocations.append(participantsIDs)
      if let fetchChatRoomWithParticipantsIDsClosure = fetchChatRoomWithParticipantsIDsClosure {
        return fetchChatRoomWithParticipantsIDsClosure(participantsIDs)
      } else {
        return fetchChatRoomWithParticipantsIDsReturnValue
      }
  }

  //MARK: - createChatRoomsFetchController

  var createChatRoomsFetchControllerFetchRequestCallsCount = 0
  var createChatRoomsFetchControllerFetchRequestCalled: Bool {
      return createChatRoomsFetchControllerFetchRequestCallsCount > 0
  }
  var createChatRoomsFetchControllerFetchRequestReceivedFetchRequest: NSFetchRequest<ChatRoom>?
  var createChatRoomsFetchControllerFetchRequestReceivedInvocations: [NSFetchRequest<ChatRoom>] = []
  var createChatRoomsFetchControllerFetchRequestReturnValue: NSFetchedResultsController<ChatRoom>!
  var createChatRoomsFetchControllerFetchRequestClosure: ((NSFetchRequest<ChatRoom>) -> NSFetchedResultsController<ChatRoom>)?

  func createChatRoomsFetchController(fetchRequest: NSFetchRequest<ChatRoom>) -> NSFetchedResultsController<ChatRoom> {
      createChatRoomsFetchControllerFetchRequestCallsCount += 1
      createChatRoomsFetchControllerFetchRequestReceivedFetchRequest = fetchRequest
      createChatRoomsFetchControllerFetchRequestReceivedInvocations.append(fetchRequest)
      if let createChatRoomsFetchControllerFetchRequestClosure = createChatRoomsFetchControllerFetchRequestClosure {
        return createChatRoomsFetchControllerFetchRequestClosure(fetchRequest)
      } else {
        return createChatRoomsFetchControllerFetchRequestReturnValue
      }
  }

  //MARK: - prepareToMoveChatRoomsToDifferentThread

  var prepareToMoveChatRoomsToDifferentThreadThrowableError: Error?
  var prepareToMoveChatRoomsToDifferentThreadCallsCount = 0
  var prepareToMoveChatRoomsToDifferentThreadCalled: Bool {
      return prepareToMoveChatRoomsToDifferentThreadCallsCount > 0
  }
  var prepareToMoveChatRoomsToDifferentThreadReceivedObjects: [ChatRoom]?
  var prepareToMoveChatRoomsToDifferentThreadReceivedInvocations: [[ChatRoom]] = []
  var prepareToMoveChatRoomsToDifferentThreadReturnValue: [NSManagedObjectID]!
  var prepareToMoveChatRoomsToDifferentThreadClosure: (([ChatRoom]) throws -> [NSManagedObjectID])?

  func prepareToMoveChatRoomsToDifferentThread(_ objects: [ChatRoom]) throws -> [NSManagedObjectID] {
      if let error = prepareToMoveChatRoomsToDifferentThreadThrowableError {
        throw error
      }
      prepareToMoveChatRoomsToDifferentThreadCallsCount += 1
      prepareToMoveChatRoomsToDifferentThreadReceivedObjects = objects
      prepareToMoveChatRoomsToDifferentThreadReceivedInvocations.append(objects)
      if let prepareToMoveChatRoomsToDifferentThreadClosure = prepareToMoveChatRoomsToDifferentThreadClosure {
        return try prepareToMoveChatRoomsToDifferentThreadClosure(objects)
      } else {
        return prepareToMoveChatRoomsToDifferentThreadReturnValue
      }
  }

}
