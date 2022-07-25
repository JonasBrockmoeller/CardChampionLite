import SwiftUI

struct MainView: View {
    @State private var currentlyActiveTabTag = 2
    
    var body: some View {
        TabView(selection: $currentlyActiveTabTag){
            CardDeckView()
                .tabItem {
                    Label("Deck", systemImage: "square.stack.fill")
                }
                .tag(1)
            
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(2)
            
            MapView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
                .tag(3)
        }
        .onAppear {
            // Disables IOS15 new transparent TabView
            if #available(iOS 15.0, *) {
                let appearance = UITabBarAppearance()
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        }
    }
}
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

