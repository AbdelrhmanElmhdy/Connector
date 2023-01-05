// Generated using Sourcery 1.9.2 — https://github.com/krzysztofzablocki/Sourcery

import CoreData
@testable import Connector

class ChatMessageServiceMock: ChatMessageService {



  //MARK: - createMessage

  var createMessageSenderIdRoomIdRepliedAtMessageIdTypeTextMediaOrFileURLLocationContactCallsCount = 0
  var createMessageSenderIdRoomIdRepliedAtMessageIdTypeTextMediaOrFileURLLocationContactCalled: Bool {
      return createMessageSenderIdRoomIdRepliedAtMessageIdTypeTextMediaOrFileURLLocationContactCallsCount > 0
  }
  var createMessageSenderIdRoomIdRepliedAtMessageIdTypeTextMediaOrFileURLLocationContactReceivedArguments: (senderId: String, roomId: String, repliedAtMessageId: String?, type: Message.MessageType, text: String?, mediaOrFileURL: URL?, location: Location?, contact: Contact?)?
  var createMessageSenderIdRoomIdRepliedAtMessageIdTypeTextMediaOrFileURLLocationContactReceivedInvocations: [(senderId: String, roomId: String, repliedAtMessageId: String?, type: Message.MessageType, text: String?, mediaOrFileURL: URL?, location: Location?, contact: Contact?)] = []
  var createMessageSenderIdRoomIdRepliedAtMessageIdTypeTextMediaOrFileURLLocationContactReturnValue: Message!
  var createMessageSenderIdRoomIdRepliedAtMessageIdTypeTextMediaOrFileURLLocationContactClosure: ((String, String, String?, Message.MessageType, String?, URL?, Location?, Contact?) -> Message)?

  func createMessage(senderId: String, roomId: String, repliedAtMessageId: String?, type: Message.MessageType, text: String?, mediaOrFileURL: URL?, location: Location?, contact: Contact?) -> Message {
      createMessageSenderIdRoomIdRepliedAtMessageIdTypeTextMediaOrFileURLLocationContactCallsCount += 1
      createMessageSenderIdRoomIdRepliedAtMessageIdTypeTextMediaOrFileURLLocationContactReceivedArguments = (senderId: senderId, roomId: roomId, repliedAtMessageId: repliedAtMessageId, type: type, text: text, mediaOrFileURL: mediaOrFileURL, location: location, contact: contact)
      createMessageSenderIdRoomIdRepliedAtMessageIdTypeTextMediaOrFileURLLocationContactReceivedInvocations.append((senderId: senderId, roomId: roomId, repliedAtMessageId: repliedAtMessageId, type: type, text: text, mediaOrFileURL: mediaOrFileURL, location: location, contact: contact))
      if let createMessageSenderIdRoomIdRepliedAtMessageIdTypeTextMediaOrFileURLLocationContactClosure = createMessageSenderIdRoomIdRepliedAtMessageIdTypeTextMediaOrFileURLLocationContactClosure {
        return createMessageSenderIdRoomIdRepliedAtMessageIdTypeTextMediaOrFileURLLocationContactClosure(senderId, roomId, repliedAtMessageId, type, text, mediaOrFileURL, location, contact)
      } else {
        return createMessageSenderIdRoomIdRepliedAtMessageIdTypeTextMediaOrFileURLLocationContactReturnValue
      }
  }

  //MARK: - fetchMessage

  var fetchMessageWithObjectIDThrowableError: Error?
  var fetchMessageWithObjectIDCallsCount = 0
  var fetchMessageWithObjectIDCalled: Bool {
      return fetchMessageWithObjectIDCallsCount > 0
  }
  var fetchMessageWithObjectIDReceivedObjectID: NSManagedObjectID?
  var fetchMessageWithObjectIDReceivedInvocations: [NSManagedObjectID] = []
  var fetchMessageWithObjectIDReturnValue: Message?
  var fetchMessageWithObjectIDClosure: ((NSManagedObjectID) throws -> Message?)?

  func fetchMessage(withObjectID objectID: NSManagedObjectID) throws -> Message? {
      if let error = fetchMessageWithObjectIDThrowableError {
        throw error
      }
      fetchMessageWithObjectIDCallsCount += 1
      fetchMessageWithObjectIDReceivedObjectID = objectID
      fetchMessageWithObjectIDReceivedInvocations.append(objectID)
      if let fetchMessageWithObjectIDClosure = fetchMessageWithObjectIDClosure {
        return try fetchMessageWithObjectIDClosure(objectID)
      } else {
        return fetchMessageWithObjectIDReturnValue
      }
  }

  //MARK: - fetchMessages

  var fetchMessagesWithObjectIDsCallsCount = 0
  var fetchMessagesWithObjectIDsCalled: Bool {
      return fetchMessagesWithObjectIDsCallsCount > 0
  }
  var fetchMessagesWithObjectIDsReceivedObjectIDs: [NSManagedObjectID]?
  var fetchMessagesWithObjectIDsReceivedInvocations: [[NSManagedObjectID]] = []
  var fetchMessagesWithObjectIDsReturnValue: [Message]?
  var fetchMessagesWithObjectIDsClosure: (([NSManagedObjectID]) -> [Message]?)?

  func fetchMessages(withObjectIDs objectIDs: [NSManagedObjectID]) -> [Message]? {
      fetchMessagesWithObjectIDsCallsCount += 1
      fetchMessagesWithObjectIDsReceivedObjectIDs = objectIDs
      fetchMessagesWithObjectIDsReceivedInvocations.append(objectIDs)
      if let fetchMessagesWithObjectIDsClosure = fetchMessagesWithObjectIDsClosure {
        return fetchMessagesWithObjectIDsClosure(objectIDs)
      } else {
        return fetchMessagesWithObjectIDsReturnValue
      }
  }

  //MARK: - startListeningForIncomingMessages

  var startListeningForIncomingMessagesThrowableError: Error?
  var startListeningForIncomingMessagesCallsCount = 0
  var startListeningForIncomingMessagesCalled: Bool {
      return startListeningForIncomingMessagesCallsCount > 0
  }
  var startListeningForIncomingMessagesClosure: (() throws -> Void)?

  func startListeningForIncomingMessages() throws {
      if let error = startListeningForIncomingMessagesThrowableError {
        throw error
      }
      startListeningForIncomingMessagesCallsCount += 1
      try startListeningForIncomingMessagesClosure?()
  }

  //MARK: - stopListeningForIncomingMessages

  var stopListeningForIncomingMessagesCallsCount = 0
  var stopListeningForIncomingMessagesCalled: Bool {
      return stopListeningForIncomingMessagesCallsCount > 0
  }
  var stopListeningForIncomingMessagesClosure: (() -> Void)?

  func stopListeningForIncomingMessages() {
      stopListeningForIncomingMessagesCallsCount += 1
      stopListeningForIncomingMessagesClosure?()
  }

  //MARK: - incomingMessagesHandler

  var incomingMessagesHandlerMessagesCallsCount = 0
  var incomingMessagesHandlerMessagesCalled: Bool {
      return incomingMessagesHandlerMessagesCallsCount > 0
  }
  var incomingMessagesHandlerMessagesReceivedMessages: [Message]?
  var incomingMessagesHandlerMessagesReceivedInvocations: [[Message]] = []
  var incomingMessagesHandlerMessagesClosure: (([Message]) -> Void)?

  func incomingMessagesHandler(messages: [Message]) {
      incomingMessagesHandlerMessagesCallsCount += 1
      incomingMessagesHandlerMessagesReceivedMessages = messages
      incomingMessagesHandlerMessagesReceivedInvocations.append(messages)
      incomingMessagesHandlerMessagesClosure?(messages)
  }

  //MARK: - sendMessage

  var sendMessageThrowableError: Error?
  var sendMessageCallsCount = 0
  var sendMessageCalled: Bool {
      return sendMessageCallsCount > 0
  }
  var sendMessageReceivedMessage: Message?
  var sendMessageReceivedInvocations: [Message] = []
  var sendMessageClosure: ((Message) throws -> Void)?

  func sendMessage(_ message: Message) throws {
      if let error = sendMessageThrowableError {
        throw error
      }
      sendMessageCallsCount += 1
      sendMessageReceivedMessage = message
      sendMessageReceivedInvocations.append(message)
      try sendMessageClosure?(message)
  }

  //MARK: - deleteMessage

  var deleteMessageCallsCount = 0
  var deleteMessageCalled: Bool {
      return deleteMessageCallsCount > 0
  }
  var deleteMessageReceivedMessage: Message?
  var deleteMessageReceivedInvocations: [Message] = []
  var deleteMessageClosure: ((Message) -> Void)?

  func deleteMessage(_ message: Message) {
      deleteMessageCallsCount += 1
      deleteMessageReceivedMessage = message
      deleteMessageReceivedInvocations.append(message)
      deleteMessageClosure?(message)
  }

  //MARK: - deleteMessageAndAmendChatRoom

  var deleteMessageAndAmendChatRoomPreviousMessageCallsCount = 0
  var deleteMessageAndAmendChatRoomPreviousMessageCalled: Bool {
      return deleteMessageAndAmendChatRoomPreviousMessageCallsCount > 0
  }
  var deleteMessageAndAmendChatRoomPreviousMessageReceivedArguments: (message: Message, previousMessage: Message?)?
  var deleteMessageAndAmendChatRoomPreviousMessageReceivedInvocations: [(message: Message, previousMessage: Message?)] = []
  var deleteMessageAndAmendChatRoomPreviousMessageClosure: ((Message, Message?) -> Void)?

  func deleteMessageAndAmendChatRoom(_ message: Message, previousMessage: Message?) {
      deleteMessageAndAmendChatRoomPreviousMessageCallsCount += 1
      deleteMessageAndAmendChatRoomPreviousMessageReceivedArguments = (message: message, previousMessage: previousMessage)
      deleteMessageAndAmendChatRoomPreviousMessageReceivedInvocations.append((message: message, previousMessage: previousMessage))
      deleteMessageAndAmendChatRoomPreviousMessageClosure?(message, previousMessage)
  }

  //MARK: - createMessagesFetchController

  var createMessagesFetchControllerFetchRequestCallsCount = 0
  var createMessagesFetchControllerFetchRequestCalled: Bool {
      return createMessagesFetchControllerFetchRequestCallsCount > 0
  }
  var createMessagesFetchControllerFetchRequestReceivedFetchRequest: NSFetchRequest<Message>?
  var createMessagesFetchControllerFetchRequestReceivedInvocations: [NSFetchRequest<Message>] = []
  var createMessagesFetchControllerFetchRequestReturnValue: NSFetchedResultsController<Message>!
  var createMessagesFetchControllerFetchRequestClosure: ((NSFetchRequest<Message>) -> NSFetchedResultsController<Message>)?

  func createMessagesFetchController(fetchRequest: NSFetchRequest<Message>) -> NSFetchedResultsController<Message> {
      createMessagesFetchControllerFetchRequestCallsCount += 1
      createMessagesFetchControllerFetchRequestReceivedFetchRequest = fetchRequest
      createMessagesFetchControllerFetchRequestReceivedInvocations.append(fetchRequest)
      if let createMessagesFetchControllerFetchRequestClosure = createMessagesFetchControllerFetchRequestClosure {
        return createMessagesFetchControllerFetchRequestClosure(fetchRequest)
      } else {
        return createMessagesFetchControllerFetchRequestReturnValue
      }
  }

  //MARK: - prepareToMoveMessagesToDifferentThread

  var prepareToMoveMessagesToDifferentThreadThrowableError: Error?
  var prepareToMoveMessagesToDifferentThreadCallsCount = 0
  var prepareToMoveMessagesToDifferentThreadCalled: Bool {
      return prepareToMoveMessagesToDifferentThreadCallsCount > 0
  }
  var prepareToMoveMessagesToDifferentThreadReceivedObjects: [Message]?
  var prepareToMoveMessagesToDifferentThreadReceivedInvocations: [[Message]] = []
  var prepareToMoveMessagesToDifferentThreadReturnValue: [NSManagedObjectID]!
  var prepareToMoveMessagesToDifferentThreadClosure: (([Message]) throws -> [NSManagedObjectID])?

  func prepareToMoveMessagesToDifferentThread(_ objects: [Message]) throws -> [NSManagedObjectID] {
      if let error = prepareToMoveMessagesToDifferentThreadThrowableError {
        throw error
      }
      prepareToMoveMessagesToDifferentThreadCallsCount += 1
      prepareToMoveMessagesToDifferentThreadReceivedObjects = objects
      prepareToMoveMessagesToDifferentThreadReceivedInvocations.append(objects)
      if let prepareToMoveMessagesToDifferentThreadClosure = prepareToMoveMessagesToDifferentThreadClosure {
        return try prepareToMoveMessagesToDifferentThreadClosure(objects)
      } else {
        return prepareToMoveMessagesToDifferentThreadReturnValue
      }
  }

}
