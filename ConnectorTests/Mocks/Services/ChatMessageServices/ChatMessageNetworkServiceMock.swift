// Generated using Sourcery 1.9.2 — https://github.com/krzysztofzablocki/Sourcery

import CoreData
import FirebaseCore
import FirebaseFirestore
@testable import Connector

class ChatMessageNetworkServiceMock: ChatMessageNetworkService {



    //MARK: - listenForIncomingMessages

    var listenForIncomingMessagesCompletionHandlerCurrentUserIdManagedObjectContextCallsCount = 0
    var listenForIncomingMessagesCompletionHandlerCurrentUserIdManagedObjectContextCalled: Bool {
        return listenForIncomingMessagesCompletionHandlerCurrentUserIdManagedObjectContextCallsCount > 0
    }
    var listenForIncomingMessagesCompletionHandlerCurrentUserIdManagedObjectContextReceivedArguments: (completionHandler: (_ message: [Message]) -> Void, currentUserId: String, managedObjectContext: NSManagedObjectContext)?
    var listenForIncomingMessagesCompletionHandlerCurrentUserIdManagedObjectContextReceivedInvocations: [(completionHandler: (_ message: [Message]) -> Void, currentUserId: String, managedObjectContext: NSManagedObjectContext)] = []
    var listenForIncomingMessagesCompletionHandlerCurrentUserIdManagedObjectContextClosure: ((@escaping (_ message: [Message]) -> Void, String, NSManagedObjectContext) -> Void)?

    func listenForIncomingMessages(completionHandler: @escaping (_ message: [Message]) -> Void, currentUserId: String, managedObjectContext: NSManagedObjectContext) {
        listenForIncomingMessagesCompletionHandlerCurrentUserIdManagedObjectContextCallsCount += 1
        listenForIncomingMessagesCompletionHandlerCurrentUserIdManagedObjectContextReceivedArguments = (completionHandler: completionHandler, currentUserId: currentUserId, managedObjectContext: managedObjectContext)
        listenForIncomingMessagesCompletionHandlerCurrentUserIdManagedObjectContextReceivedInvocations.append((completionHandler: completionHandler, currentUserId: currentUserId, managedObjectContext: managedObjectContext))
        listenForIncomingMessagesCompletionHandlerCurrentUserIdManagedObjectContextClosure?(completionHandler, currentUserId, managedObjectContext)
    }

    //MARK: - removeCurrentUidFromListOfMessageReceivers

    var removeCurrentUidFromListOfMessageReceiversCurrentUidDocumentsCallsCount = 0
    var removeCurrentUidFromListOfMessageReceiversCurrentUidDocumentsCalled: Bool {
        return removeCurrentUidFromListOfMessageReceiversCurrentUidDocumentsCallsCount > 0
    }
    var removeCurrentUidFromListOfMessageReceiversCurrentUidDocumentsReceivedArguments: (currentUid: String, documents: [DocumentSnapshot])?
    var removeCurrentUidFromListOfMessageReceiversCurrentUidDocumentsReceivedInvocations: [(currentUid: String, documents: [DocumentSnapshot])] = []
    var removeCurrentUidFromListOfMessageReceiversCurrentUidDocumentsClosure: ((String, [DocumentSnapshot]) -> Void)?

    func removeCurrentUidFromListOfMessageReceivers(currentUid: String, documents: [DocumentSnapshot]) {
        removeCurrentUidFromListOfMessageReceiversCurrentUidDocumentsCallsCount += 1
        removeCurrentUidFromListOfMessageReceiversCurrentUidDocumentsReceivedArguments = (currentUid: currentUid, documents: documents)
        removeCurrentUidFromListOfMessageReceiversCurrentUidDocumentsReceivedInvocations.append((currentUid: currentUid, documents: documents))
        removeCurrentUidFromListOfMessageReceiversCurrentUidDocumentsClosure?(currentUid, documents)
    }

    //MARK: - initializeChatRoom

    var initializeChatRoomWithMessageCallsCount = 0
    var initializeChatRoomWithMessageCalled: Bool {
        return initializeChatRoomWithMessageCallsCount > 0
    }
    var initializeChatRoomWithMessageReceivedArguments: (room: ChatRoom, message: Message)?
    var initializeChatRoomWithMessageReceivedInvocations: [(room: ChatRoom, message: Message)] = []
    var initializeChatRoomWithMessageClosure: ((ChatRoom, Message) -> Void)?

    func initializeChatRoom(_ room: ChatRoom, withMessage message: Message) {
        initializeChatRoomWithMessageCallsCount += 1
        initializeChatRoomWithMessageReceivedArguments = (room: room, message: message)
        initializeChatRoomWithMessageReceivedInvocations.append((room: room, message: message))
        initializeChatRoomWithMessageClosure?(room, message)
    }

    //MARK: - sendMessage

    var sendMessageMessageCallsCount = 0
    var sendMessageMessageCalled: Bool {
        return sendMessageMessageCallsCount > 0
    }
    var sendMessageMessageReceivedMessage: Message?
    var sendMessageMessageReceivedInvocations: [Message] = []
    var sendMessageMessageClosure: ((Message) -> Void)?

    func sendMessage(message: Message) {
        sendMessageMessageCallsCount += 1
        sendMessageMessageReceivedMessage = message
        sendMessageMessageReceivedInvocations.append(message)
        sendMessageMessageClosure?(message)
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

}
