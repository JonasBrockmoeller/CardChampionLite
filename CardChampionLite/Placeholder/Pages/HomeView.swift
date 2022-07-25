import SwiftUI

struct HomeView: View {
    @State private var showShop = false
    @State private var disableLeftButton = true
    @State private var disableRightButton = false
    
    @State private var profileSheetIsPresented = false
    @State private var showingMultiplayer = false
    @State private var showPackOpening = false
    @State private var pack: String = "common"
    @State private var showAlert: Bool = false
    
    @State private var lowerBorderAllCardsArray = 0
    @State private var upperBorderAllCardsArray = 9
    @State private var filter: Filter = .ALL
    
    @State var benchwarmers = [
        Card(id: 1, cardName: "Steve", imagePath: "Steve", atkValue: 10, defValue: 20, intValue: 30, rarity: "Common"),
        Card(id: 2, cardName: "Rocket", imagePath: "Rocket", atkValue: 30, defValue: 40, intValue: 50, rarity: "Rare"),
        Card(id: 3, cardName: "Professor X", imagePath: "ProfessorX", atkValue: 50, defValue: 60, intValue: 70, rarity: "Epic"),
        Card(id: 4, cardName: "Link", imagePath: "Link", atkValue: 70, defValue: 80, intValue: 90, rarity: "Legendary"),
        Card(id: 5, cardName: "Joker", imagePath: "Joker", atkValue: 10, defValue: 20, intValue: 20, rarity: "Common"),
    ]
    
    var packs = [
        "Common", "Rare", "Epic", "Legendary"
    ]
    
    private var filteredCardsArray: [Card]{
        switch filter{
        case .ALL: return benchwarmers.sorted{$0.cardName < $1.cardName}
        case .BRONZE: return benchwarmers.filter{$0.rarity == "Common"}.sorted{$0.cardName < $1.cardName}
        case .SILVER: return benchwarmers.filter{$0.rarity == "Rare"}.sorted{$0.cardName < $1.cardName}
        case .GOLD: return benchwarmers.filter{$0.rarity == "Epic"}.sorted{$0.cardName < $1.cardName}
        case .PINK: return benchwarmers.filter{$0.rarity == "Legendary"}.sorted{$0.cardName < $1.cardName}
        }
    }
    
    var body: some View {
        VStack{
            ZStack{
                Image("Banner")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.leading, 15)
                
                HStack{
                    Spacer()
                    getProfileButton()
                        .padding(.trailing, 15)
                }
            }
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading){
                    HStack{
                        Spacer()
                        getStartButton()
                            .padding([.bottom,.top], 20)
                        
                        Button(action: {showShop.toggle()}) {
                            Text("Shop")
                                .font(.title)
                                .frame(width: 130, height: 70)
                                .foregroundColor(CustomColors.textColor)
                                .background(.blue)
                                .cornerRadius(10)
                                .padding([.bottom,.top], 20)
                        }
                        .sheet(isPresented: $showShop){
                            ShopView(isPresented: $showShop)
                        }
                        Spacer()
                    }
                    
                    HStack {
                        Image(systemName: "square.stack.fill")
                            .foregroundColor(CustomColors.buttonColor)
                            .padding(1)
                        Text("My Packs:")
                            .font(.title)
                    }
                    .padding(.leading, 15)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack() {
                            ForEach(packs, id: \.self){ pack in
                                Image("\(pack.lowercased())-pack")
                                    .frame(width: 155, height: 230)
                                    .scaleEffect(0.1, anchor: .center)
                                    .onTapGesture {
                                        showPackOpening.toggle()
                                    }
                            }
                            
                            //Needed something to attach the sheet to
                            //Rectangle is invisible by design
                            Rectangle()
                                .background(.clear)
                                .foregroundColor(.clear)
                                .fullScreenCover(isPresented: $showPackOpening) {
                                    PackOpeningView(isPresented: $showPackOpening,
                                                    card: Card(id: 1, cardName: "Darth Vader", imagePath: "DarthVader", atkValue: 50, defValue: 50, intValue: 50, rarity: "Legendary"))
                                }
                        }
                    }
                           .padding(.bottom, 30)
                    
                    HStack {
                        Image(systemName: "square.stack.fill")
                            .foregroundColor(CustomColors.buttonColor)
                            .padding(1)
                        Text("My Cards:")
                            .font(.title)
                        
                        Spacer()
                        
                        getFilterButton(color: Color(CustomColors.common), action: {
                            lowerBorderAllCardsArray = 0
                            self.upperBorderAllCardsArray = 9
                            self.filter = .BRONZE
                        })
                        
                        getFilterButton(color: Color(CustomColors.rare), action: {
                            lowerBorderAllCardsArray = 0
                            self.upperBorderAllCardsArray = 9
                            self.filter = .SILVER
                        })
                        
                        getFilterButton(color: Color(CustomColors.epic), action: {
                            lowerBorderAllCardsArray = 0
                            self.upperBorderAllCardsArray = 9
                            self.filter = .GOLD
                        })
                        
                        getFilterButton(color: Color(CustomColors.legendary), action: {
                            lowerBorderAllCardsArray = 0
                            self.upperBorderAllCardsArray = 9
                            self.filter = .PINK
                        })
                        
                        Spacer()
                        
                        getFilterButton(color: .blue, action: {
                            lowerBorderAllCardsArray = 0
                            self.upperBorderAllCardsArray = 9
                            self.filter = .ALL
                        })
                    }
                    .padding([.leading, .trailing], 15)
                    
                    let upperBound = filteredCardsArray.count < 9 ? filteredCardsArray.count : upperBorderAllCardsArray
                    
                    getAllCardsScrollView(cardArray:Array(filteredCardsArray[lowerBorderAllCardsArray..<upperBound]))
                        .onAppear{
                            self.upperBorderAllCardsArray = filteredCardsArray.count < 9 ? filteredCardsArray.count:upperBorderAllCardsArray
                        }
                        .padding(.bottom, 30)
                }
                .padding([.bottom,.top], 20)
            }
        }
    }
    
    func getProfileButton() -> some View{
        Button(action:{
            profileSheetIsPresented.toggle()
        }) {
            ZStack{
                Circle()
                    .foregroundColor(CustomColors.textColor)
                    .frame(width: 53, height: 53, alignment: .center)
                
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.blue)
                    .background(CustomColors.textColor)
                    .clipShape(Circle())
                    .frame(width: 45, height: 45, alignment: .center)
            }
        }
        .frame(width: 50, height: 50)
        .sheet(isPresented: $profileSheetIsPresented){
            SettingsView(isPresented: $profileSheetIsPresented)
        }
        
    }
    
    func getStartButton() -> some View{
        Button{
            showingMultiplayer.toggle()
        } label: {
            Text("Play")
                .font(.title)
                .frame(width: 130, height: 70)
                .foregroundColor(CustomColors.textColor)
                .background(.blue)
                .cornerRadius(10)
        }
        .sheet(isPresented: $showingMultiplayer){
            GameSelectionView()
            //GameView() //only for testing without multiplayer
        }
        .clipped()
    }
    
    func getFilterButton(color: Color, action: @escaping () -> Void) -> some View{
        Button(action: action){
            Circle()
                .foregroundColor(color)
                .frame(width: 20, height: 20)
        }
    }

    
    func getAllCardsScrollView(cardArray: [Card]) -> some View{
        return ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 20) {
                //Button is only displayed when disableLeftButton == false
                //Button is used to show the next 50 cards to be effienct with memory usage
                Button(action:{
                    disableRightButton = false
                    
                    if lowerBorderAllCardsArray > 0{
                        self.upperBorderAllCardsArray = self.lowerBorderAllCardsArray
                        
                        if lowerBorderAllCardsArray-50 < 0{
                            self.lowerBorderAllCardsArray = 0
                            disableLeftButton = true
                        } else {
                            self.lowerBorderAllCardsArray -= 50
                        }
                    }
                }){
                    Image(systemName: "arrow.left")
                        .resizable()
                        .scaledToFit()
                        .padding(5)
                        .frame(width: self.lowerBorderAllCardsArray == 0 ? 1 : 45, height: 45)
                        .foregroundColor(.blue)
                }
                .disabled(self.lowerBorderAllCardsArray == 0 ? true : false)
                
                ForEach(cardArray) { card in
                    card
                        .scaleEffect(0.37, anchor: .center)
                        .frame(width: 155, height: 230)
                }
                
                //Button is only displayed when disableRightButton == false
                //Button is used to show the previous 50 cards to be effienct with memory usage
                Button(action:{
                    disableLeftButton = false
                    
                    if upperBorderAllCardsArray < filteredCardsArray.count{
                        self.lowerBorderAllCardsArray = self.upperBorderAllCardsArray
                        
                        if upperBorderAllCardsArray+50 > filteredCardsArray.count{
                            self.upperBorderAllCardsArray = filteredCardsArray.count-1
                            disableRightButton = true
                        } else {
                            self.upperBorderAllCardsArray += 50
                        }
                    }
                }){
                    Image(systemName: "arrow.right")
                        .resizable()
                        .scaledToFit()
                        .padding(5)
                        .frame(width: upperBorderAllCardsArray < filteredCardsArray.count-1 ? 45 : 1, height: 45)
                        .foregroundColor(.blue)
                }
                .disabled(upperBorderAllCardsArray < filteredCardsArray.count-1 ? false : true)
            }
            .frame(height: 230)
        }
    }
}

enum Filter {
    case ALL, BRONZE, SILVER, GOLD, PINK
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

