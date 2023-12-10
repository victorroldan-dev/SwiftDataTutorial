//
//  ContentView.swift
//  SwiftDataTutorial
//
//

import SwiftUI
import SwiftData

struct CountryListView: View{
    @Environment (\.modelContext) private var context
    @Query(sort: \CountryModel.code, order: .forward) var countries: [CountryModel]
    private var sort: SortDescriptor<CountryModel>
    
    init(search: String, sort: SortDescriptor<CountryModel>){
        if !search.isEmpty{
            self._countries = Query(filter: #Predicate{ $0.name.localizedStandardContains(search)},
                                    sort: [sort],
                                    transaction: Transaction(animation: .easeIn)
            )
        }else{
            self._countries = Query(sort: [sort],
                                    transaction: Transaction(animation: .easeIn))
        }
        self.sort = sort
        
    }
    
    var body: some View{
        List{
            ForEach(countries){ country in
                NavigationLink(destination: CityView(country: country)) {
                    VStack(alignment: .leading){
                        Text("\(country.code) - \(country.name)")
                        Text("Fecha: \(country.date, format: .dateTime.month().year().day().hour().minute().second())")
                            .foregroundStyle(Color.gray)
                    }
                }
                
            }
            .onDelete(perform: { indexSet in
                let model = countries[indexSet.first!]
                context.delete(model)
            })
        }
  
    }
}

struct ContentView: View {
    @Environment (\.modelContext) private var context
    @Query(sort: \CountryModel.code, order: .forward) var countries: [CountryModel]
    @State var searchText: String = ""
    
    @State var filteredBy = SortDescriptor(\CountryModel.name, order: .forward)
    
    var body: some View {
        NavigationView {
            VStack {
                CountryListView(search: searchText, sort: filteredBy)
            }
            .navigationTitle("Countries")
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
                
                Menu("Sort", systemImage: "slider.horizontal.3"){
                    Picker("Sort", selection: $filteredBy) {
                        Text("Name").tag(SortDescriptor(\CountryModel.name))
                        Text("Code").tag(SortDescriptor(\CountryModel.code))
                        Text("Date").tag(SortDescriptor(\CountryModel.date))
                    }
                }
                
            }
        }
        .searchable(text: $searchText,
                    placement: .navigationBarDrawer(displayMode: .automatic),
                    prompt: Text("Search countries...")
        )
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [CountryModel.self, CityModel.self], inMemory: true)
}
