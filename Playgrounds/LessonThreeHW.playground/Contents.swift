import UIKit
//: EventType protocol:
protocol EventType {
    var name: String { get }
}
//: AnalyticEvent protocol:
protocol AnalyticEvent {
    associatedtype Event: EventType
    var type: Event { get }
    var parameters: [String: Any] { get }
}

extension AnalyticEvent {
    var name: String {
        return type.name
    }
}
//: Event Implementations:
struct UserActionEventType: EventType {
    var name: String
}

struct ScreenViewEventType: EventType {
    var name: String
}

struct UserActionEvent: AnalyticEvent {
    var type: UserActionEventType
    var parameters: [String : Any]
}

struct ScreenViewEvent: AnalyticEvent {
    var type: ScreenViewEventType
    var parameters: [String : Any]
}

// Existencional type
struct AnyAnalyticEvent: AnalyticEvent {
    let type: AnyEventType
    let parameters: [String: Any]

    init<E: AnalyticEvent>(_ event: E) where E.Event: EventType {
        self.type = AnyEventType(name: event.type.name)
        self.parameters = event.parameters
    }
}

struct AnyEventType: EventType {
    var name: String
}
//: AnalyticsService Protocol:
protocol AnalyticsService {
    func logEvent<E: AnalyticEvent>(_ event: E)
}
//: Analytics Service Implementations:
class ConsoleAnalyticsService: AnalyticsService {
    var eventsLog: [Date: AnyAnalyticEvent] = [:]
    
    func logEvent<E: AnalyticEvent>(_ event: E) {
        let anyEvent = AnyAnalyticEvent(event)
        let eventTime = Date()
        print("Event: \(event.name), Parameters: \(event.parameters)\n")
        eventsLog[eventTime] = anyEvent
    }
    
    /* Opaque type
    func createUserActionEvent(_ type: UserActionEventType, _ parameters: [String: Any]) -> some AnalyticEvent {
        return UserActionEvent(type: type, parameters: parameters)
    }
    
    func createScreenViewEvent(_ type: ScreenViewEventType, _ parameters: [String: Any]) -> some AnalyticEvent {
        return ScreenViewEvent(type: type, parameters: parameters)
    }
    */
    
    func eventsLogDescription() {
        print("Every events stored:")
        eventsLog.forEach( {print("Event: \($0.value.name), Parameters: \($0.value.parameters)")} )
    }
}
//: Usage example:
let consoleAnalyticsService = ConsoleAnalyticsService()
let userID = UUID().uuidString

func sample() {
    let screenViewEvent = ScreenViewEvent(
        type: .init(name: "HomeView"),
        parameters: [
            "screenName": "HomeView",
            "userID": userID,
            "entryMethod" : "Launch"
        ])
    consoleAnalyticsService.logEvent(screenViewEvent)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        let userActionEvent = UserActionEvent(
            type: .init(name: "ButtonTap"),
            parameters: [
                "actionType": "ButtonTap",
                "userID": userID,
                "context": "Logout"
            ])
        consoleAnalyticsService.logEvent(userActionEvent)
        
        // Print all events
        consoleAnalyticsService.eventsLogDescription()
        
    }
}

sample()



