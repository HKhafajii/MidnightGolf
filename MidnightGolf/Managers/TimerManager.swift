//
//  TimerManager.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 1/13/25.
//

import SwiftUI
import Combine

final class TimerManager: ObservableObject {
    
    @Published var currentTime: String = ""
    
    private var timerSubscription: AnyCancellable?
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        // Set your desired format here
        df.dateFormat = "LLLL dd, hh:mm a"
        return df
    }()
    
    init() {
        // Publish every second
        let publisher = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        
        // Keep a reference so it's not canceled automatically
        timerSubscription = publisher
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.currentTime = self.dateFormatter.string(from: Date())
            }
    }
}

