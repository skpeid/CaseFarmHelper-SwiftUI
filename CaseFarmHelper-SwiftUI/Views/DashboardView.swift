//
//  DashboardView.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 21.08.2025.
//

import SwiftUI

struct DashboardView: View {
    
    @State private var isPresentedAddDrop: Bool = false
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    
                }
                Spacer()
                HStack {
                    Button {
                        
                    } label: {
                        Text("Trade")
                    }
                    Button {
                        
                    } label: {
                        Text("Add Drop")
                    }
                    
                }
            }
            .navigationTitle("Dashboard")
            .navigationDestination(isPresented: $isPresentedAddDrop) {
                
            }
        }
    }
}

#Preview {
    DashboardView()
}
