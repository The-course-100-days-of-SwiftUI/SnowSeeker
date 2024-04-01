//
//  Favorites.swift
//  SnowSeeker
//
//  Created by Margarita Mayer on 01/04/24.
//

import SwiftUI

@Observable
class Favorites {
	private var resorts: Set<String>
	private let key = "Favorites"
	
	let savePath = URL.documentsDirectory.appending(path: "Favorites")
	  
	init() {
		do {
			let data = try Data(contentsOf: savePath)
			let decoder = JSONDecoder()
			resorts = try decoder.decode(Set<String>.self, from: data)
		} catch {
			resorts = []
		}
		
	}
	
	func contains(_ resort: Resort) -> Bool {
		resorts.contains(resort.id)
	}
	
	func add(_ resort: Resort) {
		   resorts.insert(resort.id)
		   save()
	   }

	  
	   func remove(_ resort: Resort) {
		   resorts.remove(resort.id)
		   save()
	   }

	   func save() {
		   do {
			   let encoder = JSONEncoder()
			   let data = try encoder.encode(resorts)
			   try data.write(to: savePath, options: [.atomic, .completeFileProtection])
		   } catch {
			   print("Unable to save data")
		   }
		  
	   }
}
