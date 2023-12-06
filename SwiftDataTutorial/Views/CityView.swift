//
//  CityView.swift
//  SwiftDataTutorial
//
//

import SwiftUI
import SwiftData

struct CityView: View {
    @Environment (\.modelContext) private var context
    @Query var cities: [CityModel]
    let country: CountryModel
    @State var countryName = ""
    
    init(country: CountryModel){
        let countryId = country.id
        
        self._cities = Query(filter: #Predicate { $0.country?.id == countryId},
                             sort: \CityModel.name, 
                             order: .forward,
                             transaction: Transaction(animation: .easeIn)
        )
        
        self.country = country
        
    }
    var body: some View {
        VStack{
            Form{
                Section("Pais Seleccionado") {
                    HStack{
                        TextField("Country Name", text: $countryName)
                            
                        Rectangle()
                            .fill(Color.gray.opacity(0.5))
                            .frame(width: 1)
                        
                        Button(action: {
                            //update country
                            country.name = countryName
                            do{
                                try context.save()
                            }catch{
                                print(error)
                            }
  
                        }, label: {
                            Image(systemName: "tray.and.arrow.down.fill")
                                .foregroundStyle(Color.blue)
                            
                        })
                    }
                }
                Section("Ciudades") {
                    List{
                        ForEach(cities) { city in
                            VStack(alignment: .leading){
                                Text("\(city.name)")
                            }
                        }.onDelete { indexSet in
                            //Delete Cities
                            guard let index = indexSet.first else { return }
                            let city = cities[index]
                            context.delete(city)
                        }
                    }
                }
            }
            .navigationTitle("Cities")
        }
        .toolbar{
            Button(action: {
                let city = CityModel.getRandomCity()
                city.country = country
                context.insert(city)
                /*
                 En caso que autoSave=false, se debe usar así
                do{
                    try context.save()
                }catch{
                    print("\(error.localizedDescription)")
                }
                */
                
            }, label: {
                Image(systemName: "plus.square.fill")
                    .foregroundStyle(Color.blue)
                
            })
        }
        .onAppear{
            self.countryName = self.country.name
        }
        
    }
}

#Preview {
    let example = CountryModel.getRandomCountry()
    return CityView(country: example)
}
