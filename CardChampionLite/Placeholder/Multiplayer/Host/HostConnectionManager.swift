//
//  ConnectionManager.swift
//  Placeholder
//
//  Created by Jonas Brockmöller on 09.04.22.
//
import SwiftUI
import MultipeerConnectivity
import os

/*
 Tutorial used:
 https://www.ralfebert.de/ios-app-entwicklung/multipeer-connectivity/
 */

class HostConnectionManager: NSObject, ObservableObject, ConnectionManager{
    private let serviceType = "placeholderApp"
    private let session: MCSession
    private let myPeerId = MCPeerID(displayName: UIDevice.current.name)
    private let serviceAdvertiser: MCNearbyServiceAdvertiser
    
    @Published var showAlert: Bool = false
    @Published var opponentsCurrentValue: GameInformation? = nil
    @Published var myCurrentValue: GameInformation? = nil
    @Published var connectedPeers: [MCPeerID] = []
    @Published var receivedInvitation: InvitationContainer?
    @Published var result: String
    @Published var deck: [Card]?
    @Published var showConfetti: Int
    @Published var roundsWon: Int
    @Published var roundsLost: Int
    @Published var sessionstarted: Bool

    override init() {
        precondition(Thread.isMainThread)
        self.session = MCSession(peer: myPeerId)
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: serviceType)
        self.result = "Result: -"
        self.showConfetti = 0
        self.roundsWon = 0
        self.roundsLost = 0
        self.sessionstarted = false
        
        super.init()
        
        session.delegate = self
        serviceAdvertiser.delegate = self
    }
    
    deinit {
        self.serviceAdvertiser.stopAdvertisingPeer()
    }
    
    func reset(){
        self.roundsWon = 0
        self.roundsLost = 0
        self.sessionstarted = false
    }
    
    func startAdvertising(){
        serviceAdvertiser.startAdvertisingPeer()
    }
    
    func stopAdvertising(){
        serviceAdvertiser.stopAdvertisingPeer()
    }
    
    func acceptInvitation(invitation: InvitationContainer){
        showAlert = false
        invitation.invitationHandler(true, session)
    }
    
    func declineInvitation(invitation: InvitationContainer){
        showAlert = false
        receivedInvitation = nil
    }
    
    func disconnectFromSession(){
        session.disconnect()
    }
    
    func setDeck(deck: [Card]){
        self.deck = deck
    }
    
    func send(_ result: String){
        do {
            guard let hostValue = myCurrentValue, let hostDeck = self.deck else{return}
            let gameInformation = GameInformation(card: hostValue.card, button: hostValue.button, deckCount: hostDeck.count, result: result)
            let data = try JSONEncoder().encode(gameInformation)
            if !session.connectedPeers.isEmpty {
                try session.send(data, toPeers: session.connectedPeers, with: .reliable)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func matchup(){
        guard let opponentValue = opponentsCurrentValue, let hostValue = myCurrentValue else{
            return
        }
        
        let result = gameMechanic.compareValues(card1: hostValue.card, button1: hostValue.button, deckCount1: self.deck!.count, card2: opponentValue.card, button2: opponentValue.button, deckCount2: self.deck!.count)
        
        let card = self.deck?.remove(at: 0)
        switch result{
            //TODO: put logic in function -> different game modes
        case 1:
            self.result = "You won"
            self.roundsWon += 1
            self.showConfetti  += 1
            self.deck?.append(card!)
            self.send("You lost")
        case 2:
            self.result = "You lost"
            self.roundsLost += 1
            self.send("You won")
        case 0:
            self.result = "draw"
            self.send("draw")
        default:
            self.result = "An error occured"
        }
        //Process further
        print("Match up \(result)")
        self.opponentsCurrentValue = nil
        self.myCurrentValue = nil
    }
}

extension HostConnectionManager: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        precondition(Thread.isMainThread)
        print("ServiceAdvertiser didNotStartAdvertisingPeer: \(String(describing: error))")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        precondition(Thread.isMainThread)
        print("didReceiveInvitationFromPeer \(peerID)")
        let invitation = InvitationContainer(peerID: peerID, invitationHandler: invitationHandler)
        self.receivedInvitation = invitation
        showAlert = true
    }
}

extension HostConnectionManager: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        DispatchQueue.main.async {
            switch state{
            case .notConnected:
                self.connectedPeers = []
                self.connectedPeers = session.connectedPeers
                if self.sessionstarted == true{ self.sessionstarted = true }
            case .connecting:
                self.connectedPeers = []
                self.connectedPeers = session.connectedPeers
            case .connected:
                self.connectedPeers = []
                self.connectedPeers = session.connectedPeers
                self.sessionstarted = true
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
                self.opponentsCurrentValue = value
                self.matchup()
                //In this case the opponent has played all cards
                if value.deckCount == 0{
                    self.deck?.removeAll()
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

extension MCSessionState: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .notConnected:
            return "notConnected"
        case .connecting:
            return "connecting"
        case .connected:
            return "connected"
        @unknown default:
            return "\(rawValue)"
        }
    }
}

struct InvitationContainer{
    var peerID: MCPeerID
    var invitationHandler: (Bool, MCSession?) -> Void
}
