//
//  ContentView.swift
//  Parks SwiftUI
//
//  Created by Mubeen Asif on 23/10/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State private var parks: [Park] = []
    
    var body: some View {
        NavigationStack { // <-- Wrap the top level view in a NavigationStack
            ScrollView {
                LazyVStack {
                    ForEach(parks) { park in
                        NavigationLink(value: park) { // <-- Pass in the park associated with the park row as the value
                            ParkRow(park: park) // <-- The park row serves as the label for the NavigationLink
                        }
                    }
                }
            }
            .padding()
            .navigationDestination(for: Park.self) { park in // <-- Add a navigationDestination that reacts to any Park type sent from a Navigation Link
                    ParkDetailView(park: park) // <-- Create a ParkDetailView for the destination, passing in the park
                }
            .navigationTitle("National Parks") // <-- Add a navigation bar title
        }
        .onAppear(perform: { // <-- You can keep the onAppear you created previously attached to the top level view which is now the NavigationStack
            Task {
                await fetchParks()
            }
        })
    }
    
    private func fetchParks() async {
        // URL for the API endpoint
        // 👋👋👋 Make sure to replace {YOUR_API_KEY} in the URL with your actual NPS API Key
        let url = URL(string: "https://developer.nps.gov/api/v1/parks?stateCode=ca&api_key={API_KEY}")!
        do {
            
            // Perform an asynchronous data request
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // Decode json data into ParksResponse type
            let parksResponse = try JSONDecoder().decode(ParksResponse.self, from: data)
            
            // Get the array of parks from the response
            let parks = parksResponse.data
            
            // Print the full name of each park in the array
            for park in parks {
                print(park.fullName)
            }
            
            // Set the parks state property
            self.parks = parks
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

#Preview {
    ContentView()
}
