//
//  ContentView.swift
//  SwiftDataTutorial
//
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment (\.modelContext) private var context
    @Query(sort: \CountryModel.code, order: .forward) var countries: [CountryModel]
    
    var body: some View {
        NavigationView {
            VStack {
                List{
                    ForEach(countries){ country in
                        Text("\(country.code) - \(country.name)")
                    }
                    .onDelete(perform: { indexSet in
                        let model = countries[indexSet.first!]
                        context.delete(model)
                    })
                }
                
                .toolbar{
                    
                    Button(action: {
                        //Eliminar toda la lista
                        countries.forEach { country in
                            context.delete(country)
                        }
                    }, label: {
                        Image(systemName: "trash.fill")
                            .foregroundStyle(Color.red)
                    })
                    
                    Button(action: {
                        //Agregar elemento random
                        context.insert(CountryModel.getRandomCountry())
                    }, label: {
                        Image(systemName: "plus.square.fill")
                            .foregroundStyle(Color.blue)
                    })
                    
                }
            }
            .navigationTitle("Countries")
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: CountryModel.self, inMemory: true)
}
