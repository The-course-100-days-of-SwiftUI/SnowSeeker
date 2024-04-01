//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Margarita Mayer on 31/03/24.
//

import SwiftUI

struct ContentView: View {
	let resorts: [Resort] = Bundle.main.decode("resorts.json")
	@State private var searchText = ""
	@State private var favorites = Favorites()
	
	var filteredResorts: [Resort] {
		if searchText.isEmpty {
			resorts
		} else {
			resorts.filter { $0.name.localizedStandardContains(searchText) }
		}
	}
	@State private var sortOption = "Name"
	let sortOrder = ["Country", "Name", "Price"]
	
	
	var body: some View {
		NavigationSplitView {
			List(filteredResorts.sorted(by: makeSort)) { resort in
				NavigationLink(value: resort) {
					HStack {
						Image(resort.country)
							.resizable()
							.scaledToFill()
							.frame(width: 40, height: 25)
							.clipShape(
								.rect(cornerRadius: 5)
							)
							.overlay(
								RoundedRectangle(cornerRadius: 5)
									.stroke(.black, lineWidth: 1)
							)
						
						VStack(alignment: .leading) {
							Text(resort.name)
								.font(.headline)
							Text("\(resort.runs) runs")
								.foregroundStyle(.secondary)
						}
						
						if favorites.contains(resort) {
							Spacer()
							Image(systemName: "heart.fill")
								.accessibilityLabel("This is a favorite resort")
								.foregroundStyle(.red)
						}
					}
				}
			}
			.navigationTitle("Resorts")
			.navigationDestination(for: Resort.self) { resort in
				ResortView(resort: resort )
			}
			.searchable(text: $searchText, prompt: "Search for a resort")
			.toolbar {
				Menu("Sort", systemImage: "arrow.up.arrow.down") {
					Picker("Sort", selection: $sortOption) {
						ForEach(sortOrder, id: \.self) { order in
							Text(order)
						}
					}
				}
			}
		} detail: {
			WelcomeView()
		}
		.environment(favorites)
	}
	
	func makeSort(_ resort1: Resort, _ resort2: Resort) -> Bool {
		if sortOption == "Name" {
			return resort1.name < resort2.name
		} else if sortOption == "Country" {
			return resort1.country < resort2.country
		} else if sortOption == "Price" {
			return resort1.price < resort2.price
		}
		return false
	}
}
    
#Preview {
    ContentView()
}
