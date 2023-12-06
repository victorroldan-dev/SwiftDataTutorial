//
//  SwiftDataTutorialApp.swift
//  SwiftDataTutorial
//
//

import SwiftUI
import SwiftData

@main
struct SwiftDataTutorialApp: App {
    let container: ModelContainer = {
        let container : ModelContainer!
        
        let schema = Schema([CountryModel.self, CityModel.self])
        
        let config = ModelConfiguration("CountryModelSchema",
                                        schema: schema,
                                        isStoredInMemoryOnly: false,
                                        allowsSave: true)
        
        do{
            container = try ModelContainer(for: schema, configurations: config)
        }catch{
            fatalError("falló")
        }

        return container
    }()
    /*
    let container: ModelContainer = {
        let container : ModelContainer!
        
        let config = ModelConfiguration(url: URL.downloadsDirectory.appending(path: "CountryModel.store"))
        
        do{
            container = try ModelContainer(for: CountryModel.self, configurations: config)
        }catch{
            fatalError("falló")
        }

        return container
    }()
    */
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
    
    init(){
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}
