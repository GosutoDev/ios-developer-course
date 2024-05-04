import UIKit
//: EventType protocol:
protocol EventType {
    var name: String { get }
}
//: AnalyticEvent protocol:
protocol AnalyticEvent {
    associatedtype T: EventType
    var type: T { get }
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
//: AnalyticsService Protocol:
protocol AnalyticsService {
    func logEvent<E: AnalyticEvent>(_ event: E)
}
//: Analytics Service Implementations:
class ConsoleAnalyticsService: AnalyticsService {
    var eventsLog: [Date: String] = [:]
    
    func logEvent<E: AnalyticEvent>(_ event: E) {
        let logEntry = "Event: \(event.name), Parameters: \(event.parameters)\n"
        print(logEntry)
        eventsLog[Date()] = logEntry
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
        print("Every events stored:")
        consoleAnalyticsService.eventsLog.forEach({ print("Date: \($0.key), \nEvent: \($0.value)") })
    }
}




