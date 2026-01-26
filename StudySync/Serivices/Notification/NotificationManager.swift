//
//  NotificationManager.swift
//  StudySync
//
//  Created by Martin Reich on 16.01.2026.
//

import Foundation
import UserNotifications
import SwiftData

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    // 1. Žádost o povolení notifikací
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notifikace povoleny")
                self.scheduleMorningNotification() // Jakmile povolí, naplánujeme ráno
            } else if let error = error {
                print("Chyba notifikací: \(error.localizedDescription)")
            }
        }
    }
    
    // 2. Ranní notifikace (Každý den v 9:00)
    func scheduleMorningNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Dobré ráno! ☀️"
        content.body = "Je čas na tvou denní dávku vědomostí. Připraven?"
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 12
        dateComponents.minute = 8
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "morning_reminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    // 3. Večerní notifikace (Jen pro dnešek v 20:00)
    func scheduleEveningNotification(ifNotStudied context: ModelContext) {
        // Nejprve zkontrolujeme, zda už dnes studoval
        if hasStudiedToday(context: context) {
            // Pokud studoval, zrušíme případnou čekající notifikaci
            cancelEveningNotification()
            print("Dnes splněno, večerní notifikace zrušena.")
            return
        }
        
        // Pokud nestudoval, naplánujeme na 20:00
        let content = UNMutableNotificationContent()
        content.title = "Udrž si Streak!"
        content.body = "Dnes jsi ještě nestudoval. Dokonči lekci před půlnocí!"
        content.sound = .default
        
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        dateComponents.hour = 20
        dateComponents.minute = 0
        
        // Pokud už je po 20:00, notifikace by se spustila hned, což asi nechceme,
        // nebo ji můžeme nechat na zítra. Tady předpokládáme trigger pro dnešek.
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: "evening_reminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
        print("Naplánována večerní záchranná notifikace.")
    }
    
    func cancelEveningNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["evening_reminder"])
    }
    
    // Pomocná metoda pro kontrolu SwiftData
    private func hasStudiedToday(context: ModelContext) -> Bool {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        // FetchDescriptor pro dnešní sessions
        let descriptor = FetchDescriptor<StudySession>(
            predicate: #Predicate { session in
                session.date >= startOfDay && session.date < endOfDay
            }
        )
        
        do {
            let count = try context.fetchCount(descriptor)
            return count > 0
        } catch {
            print("Chyba při kontrole studia: \(error)")
            return false
        }
    }
}
