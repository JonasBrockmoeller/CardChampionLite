//
//  ConnectionManager.swift
//  Placeholder
//
//  Created by Jonas Brockmöller on 09.04.22.
//
import MultipeerConnectivity
import os

/*
 Tutorial used:
 https://www.ralfebert.de/ios-app-entwicklung/multipeer-connectivity/
 */
class PlayerConnectionManager: NSObject, ObservableObject, ConnectionManager{
    private let serviceType = "placeholderApp"
    private let session: MCSession
    private let myPeerId = MCPeerID(displayName: UIDevice.current.name)
    private let serviceBrowser: MCNearbyServiceBrowser
    
    @Published var connectedPeers: [MCPeerID] = []
    @Published var nearbyOpponents: [NearbyOpponentsContainer] = []
    @Published var deck: [Card] = []
    @Published var result: String
    @Published var showConfetti: Int
    @Published var roundsWon: Int
    @Published var roundsLost: Int
    @Published var hostAcceptedInvitation: Bool
    
    override init() {
        precondition(Thread.isMainThread)
        self.session = MCSession(peer: myPeerId)
        self.result = "Result: -"
        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)
        self.showConfetti = 0
        self.roundsWon = 0
        self.roundsLost = 0
        self.hostAcceptedInvitation = false
        
        super.init()
        
        session.delegate = self
        serviceBrowser.delegate = self
    }
    
    deinit {
        self.serviceBrowser.stopBrowsingForPeers()
    }
    
    func reset(){
        self.showConfetti = 0
        self.roundsWon = 0
        self.roundsLost = 0
        self.hostAcceptedInvitation = false
        self.result = "Result: -"
    }
    
    func startBrowsing(){
        serviceBrowser.startBrowsingForPeers()
    }
    
    func stopBrowsing(){
        serviceBrowser.stopBrowsingForPeers()
    }
    
    func inviteOpponent(browser: MCNearbyServiceBrowser, peerID: MCPeerID){
        print("invitation sent")
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
    }
    
    func disconnectFromSession(){
        session.disconnect()
    }
    
    func setDeck(deck: [Card]){
        self.deck = deck
    }
    
    func send(info: GameInformation) {
        precondition(Thread.isMainThread)
        print("sendValue: \(String(describing: info)) to \(self.session.connectedPeers.count) peers")
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do{
            let data = try encoder.encode(info)
            if !session.connectedPeers.isEmpty {
                do {
                    try session.send(data, toPeers: session.connectedPeers, with: .reliable)
                } catch {
                    print("Error for sending: \(String(describing: error))")
                }
            } else{
                print("Session is empty. Cannot sent value!")
            }
        }catch{
            debugPrint("Error Could not be encoded: \(String(describing: error))")
        }
    }
}

extension PlayerConnectionManager: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("ServiceBrowser didNotStartBrowsingForPeers: \(String(describing: error))")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
        let newOpponent = NearbyOpponentsContainer(browser: browser, foundPeer: peerID)
        nearbyOpponents.append(newOpponent)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        nearbyOpponents.removeAll { value in
            return value.foundPeer == peerID
        }
    }
}

extension PlayerConnectionManager: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        DispatchQueue.main.async {
            switch state{
            case .notConnected:
                self.connectedPeers = []
                self.connectedPeers = session.connectedPeers
                if self.hostAcceptedInvitation == true{
                    //Host disconnected from the session
                    self.hostAcceptedInvitation = false
                }
            case .connecting:
                self.connectedPeers = []
                self.connectedPeers = session.connectedPeers
            case .connected:
                self.connectedPeers = []
                self.connectedPeers = session.connectedPeers
                self.hostAcceptedInvitation = true
            @unknown default:
                return
            }
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        do{
            let value = try JSONDecoder().decode(GameInformation.self, from: data)
            print("didReceive value \(value)")
            DispatchQueue.main.async {
                if let receivedResult = value.result {
                    self.result = receivedResult
                } else {
                    print("Result could not be decoded")
                }
                if value.deckCount == 0{
                    //This is executed when the opponent has no cards left
                    self.deck.removeAll()
                } else {
                    //TODO: put logic in function -> different game modes
                    let card = self.deck.remove(at: 0)
                    switch self.result {
                    case "You won":
                        self.roundsWon += 1
                        self.showConfetti  += 1
                        self.deck.append(card)
                        return
                    case "draw":
                        self.deck.append(card)
                        return
                    default:
                        self.roundsLost += 1
                        return
                    }
                }
            }
        }catch{
            debugPrint("Error decoding: \(String(describing: error))")
        }
    }
    
    public func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("Receiving streams is not supported")
    }
    
    public func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("Receiving resources is not supported")
    }
    
    public func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        print("Receiving resources is not supported")
    }
}

struct NearbyOpponentsContainer: Identifiable{
    let id = UUID()
    let browser: MCNearbyServiceBrowser
    let foundPeer: MCPeerID
}
