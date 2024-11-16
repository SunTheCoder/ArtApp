import SwiftUI
import AVKit

struct ContentView: View {
    let exhibitions = sampleExhibitions
    let sampleArtist = Artist(
        name: "Sun English Jr.",
        bio: "Sun English Jr. is a sculptor and performance artist known for immersive installations.",
        imageUrls: ["Black Front", "M1", "Poison I", "Poison II"],
        videos: ["small", "immure"]
    )
    
    @State private var isArtistDetailPresented = false

    @State private var selectedArtPiece: ArtPiece? = nil
    @State private var isAnimating = false
    @StateObject private var userManager = UserManager()
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
//                    HeaderView(isAnimating: $isAnimating)
                    CurrentExhibitionsView(exhibitions: exhibitions, colorScheme: colorScheme)
                    FeaturedArtistView(sampleArtist: sampleArtist, colorScheme: colorScheme)
                    FeaturedArtOnCampusView(colorScheme: colorScheme, selectedArtPiece: $selectedArtPiece)
                    UserAuthenticationView(userManager: userManager)
                }
                .navigationBarTitleDisplayMode(.inline) // Keeps the title inline
                .toolbar {
                    ToolbarItem(placement: .principal) { // Centers the content in the navigation bar
                        VStack(spacing: -10) { // Adds spacing between the texts
                            Text("LONGWOOD")
                                .font(.system(size: 35, weight: .bold, design: .serif))
                                .tracking(5)
                                .offset(y: isAnimating ? 50 : -10)
                                .opacity(isAnimating ? 1 : 0)
                                .animation(.easeOut(duration: 1), value: isAnimating)
                                .padding(.bottom, 10)
                            
                            Text("CENTER for the VISUAL ARTS")
                                .font(.system(size: 25, weight: .regular, design: .serif))
                                .italic()
                                .offset(y: isAnimating ? 50 : -10)
                                .opacity(isAnimating ? 1 : 0)
                                .animation(.easeOut(duration: 1).delay(0.2), value: isAnimating)
                        }
                        .frame(maxWidth: .infinity) // Ensures full width
                        .padding(.vertical, -30) // Adds vertical padding to increase space
                        .offset(y: -30)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.primary)
                        .onAppear {
                            isAnimating = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                isAnimating = true
                            }
                        }
                    }
                }
                
            }
        }
    }
}


// MARK: - Header View
struct HeaderView: View {
    @Binding var isAnimating: Bool

    var body: some View {
        VStack {
            Text("LONGWOOD")
                .font(.system(size: 35, weight: .bold, design: .serif))
                .tracking(5)
                .offset(y: isAnimating ? 0 : -100)
                .opacity(isAnimating ? 1 : 0)
                .animation(.easeOut(duration: 1), value: isAnimating)

            Text("CENTER for the VISUAL ARTS")
                .font(.system(size: 25, weight: .regular, design: .serif))
                .italic()
                .offset(y: isAnimating ? 0 : -100)
                .opacity(isAnimating ? 1 : 0)
                .animation(.easeOut(duration: 1).delay(0.2), value: isAnimating)
        }
        .multilineTextAlignment(.center)
        .foregroundColor(Color.primary)
        .padding(.bottom, 20)
        .onAppear {
            isAnimating = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isAnimating = true
            }
        }
    }
}

// MARK: - Current Exhibitions View
struct CurrentExhibitionsView: View {
    let exhibitions: [Exhibition]
    let colorScheme: ColorScheme
    
    @State private var proxyExhibition: Exhibition? = nil

    @State private var selectedExhibition: Exhibition? // Track the selected exhibition
    @State private var isExhibitionDetailPresented = false // State to control modal presentation

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Text("Current Exhibitions")
                .font(.system(size: 20, weight: .regular, design: .serif))
                .italic()
                .foregroundColor(.secondary)
                .padding(.bottom, 8)
            
            ForEach(exhibitions) { exhibition in
                Button(action: {
                    proxyExhibition = exhibition
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        selectedExhibition = proxyExhibition
                        isExhibitionDetailPresented = true
                    }
                }){
                
                

                    HStack(spacing: 16) {
                        AsyncImage(url: URL(string: exhibition.imageUrl)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(RoundedRectangle(cornerRadius: 7))
                                .shadow(radius: 3)
                        } placeholder: {
                            ProgressView()
                        }
                        
                        VStack(alignment: .center, spacing: 4) {
                            Text(exhibition.title)
                                .font(.headline)
                                .padding(.bottom, 4)
                            
                            Text(exhibition.artist.joined(separator: ", "))
                                .font(.subheadline)
                                .italic()
                            
                            Text("Reception: \(exhibition.reception)")
                                .font(.caption)
                                .padding(2)
                            
                            Text("Closing: \(exhibition.closing)")
                                .font(.caption)
                                .padding(2)
                            
                            Link("Survey Link", destination: URL(string: exhibition.surveyUrl)!)
                                .font(.caption)
                                .padding(2)
                                .padding(.horizontal, 2)
                                .background(Color.primary.opacity(0.2))
                                .foregroundColor(.white)
                                .cornerRadius(3)
                                .shadow(radius: 2)
                        }
                    }
                    .padding()
                    .frame(maxWidth: 400)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(colorScheme == .dark ? Color.gray.opacity(0.3) : Color.white)
                            .shadow(radius: 3)
                    )
                }
            }
        }
        .padding(.horizontal)
        .foregroundColor(.primary)
        .sheet(isPresented: Binding(
            get: { selectedExhibition != nil },
            set: { newValue in
                if !newValue { selectedExhibition = nil }
            }
        )) {
            if let exhibition = selectedExhibition {
                ExhibitionDetailModalView(exhibition: exhibition, isPresented: Binding(
                    get: { selectedExhibition != nil },
                    set: { newValue in
                        if !newValue { selectedExhibition = nil }
                    }
                ))
            }
        }



    }
    // MARK: - Helper Function
      private func showModalWithExhibition(_ exhibition: Exhibition) {
          selectedExhibition = nil // Clear previous selection to trigger state change
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
              selectedExhibition = exhibition
              isExhibitionDetailPresented = true
          }
      }
  }





// MARK: - Featured Artist View
struct FeaturedArtistView: View {
    let sampleArtist: Artist
    let colorScheme: ColorScheme
    
    @State private var isArtistDetailPresented = false // State to control modal presentation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            TitleView()
        }
        VStack(alignment: .center, spacing: 16) {
            ArtistInfoView(name: sampleArtist.name)
            MainImageView()
            ImageGalleryView(imageUrls: sampleArtist.imageUrls)
            LearnMoreButton(sampleArtist: sampleArtist, isArtistDetailPresented: $isArtistDetailPresented)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(colorScheme == .dark ? Color.gray.opacity(0.3) : Color.white)
                .shadow(radius: 3)
        )
        .frame(maxWidth: 370)
        // Present the modal view
        .sheet(isPresented: $isArtistDetailPresented) {
            ArtistDetailModalView(artist: sampleArtist, isPresented: $isArtistDetailPresented)
        }
    }

    private struct TitleView: View {
        var body: some View {
            Text("Local Artist Spotlight")
                .font(.system(size: 20, weight: .regular, design: .serif))
                .italic()
                .foregroundColor(.secondary)
                .padding(.top, 25)
                .padding(.bottom, 16)
        }
    }

    private struct ArtistInfoView: View {
        let name: String
        var body: some View {
            Text(name)
                .font(.system(size: 18))
                .italic()
                .padding()
        }
    }

    private struct MainImageView: View {
        var body: some View {
            Image("LCVAPhoto")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 200, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 7))
                .shadow(radius: 3)
        }
    }

    private struct ImageGalleryView: View {
        let imageUrls: [String]
        var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(imageUrls.prefix(3), id: \.self) { imageUrl in
                        Image(imageUrl)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(RoundedRectangle(cornerRadius: 7))
                            .padding(.vertical, 5)
                            .shadow(radius: 3)
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    private struct LearnMoreButton: View {
        let sampleArtist: Artist
        @Binding var isArtistDetailPresented: Bool // Binding to control modal state
        
        var body: some View {
            Button(action: {
                isArtistDetailPresented = true
            }) {
//                Text("Click here to learn more about \(sampleArtist.name.split(separator: " ").first.map(String.init) ?? sampleArtist.name)'s practice.")
                Text("More Info")
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .padding(4)
                    .padding(.horizontal, 2)
                    
                    .background(Color.primary.opacity(0.2))
                    
                    .cornerRadius(7)
                    .shadow(radius: 2)
            }
        }
    }
}

// MARK: - Featured Art on Campus View
struct FeaturedArtOnCampusView: View {
    let colorScheme: ColorScheme
    @Binding var selectedArtPiece: ArtPiece?

    var body: some View {
        
        Text("Featured Art on Campus")
            .font(.system(size: 20, weight: .regular, design: .serif))
            .italic()
            .padding(.top, 25)
            .padding(.bottom, 8)
            .foregroundColor(.secondary)

        VStack(alignment: .center, spacing: 16) {
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(featuredArtPieces) { artPiece in
                        VStack(spacing: 8) {
                            AsyncImage(url: URL(string: artPiece.imageUrl)) { image in
                                image
                                    .resizable()
                                    .frame(width: 150, height: 150)
                                    .clipShape(RoundedRectangle(cornerRadius: 7))
                                    .shadow(radius: 3)
                                    .onTapGesture {
                                        selectedArtPiece = artPiece
                                    }
                            } placeholder: {
                                ProgressView()
                            }
                            
                            Text(artPiece.title)
                                .font(.headline)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: 200)

                            Text(artPiece.description)
                                .font(.subheadline)
                                .lineLimit(3)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: 200)
                        }
                        .padding()
                    }
                }
                .padding(.horizontal)
            }
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(colorScheme == .dark ? Color.gray.opacity(0.3) : Color.white)
                    .shadow(radius: 3)
            )
            .frame(maxWidth: 370)
            .sheet(item: $selectedArtPiece) { artPiece in
                NavigationView {
                    MapModalView(artPiece: artPiece, userManager: UserManager())
                }
            }
        }
    }
}

// MARK: - User Authentication View
struct UserAuthenticationView: View {
    @ObservedObject var userManager: UserManager
    @State private var email = ""
    @State private var password = ""
    @State private var name = ""
    @State private var preferences: [String] = []

    var body: some View {
        VStack {
            if userManager.isLoggedIn {
                Text("Welcome, \(userManager.currentUser?.displayName ?? "User")!")
                
                Button("Log Out") {
                    userManager.logOut()
                }
                .font(.system(size: 16))
                .foregroundColor(.white)
                .padding(4)
                .padding(.horizontal, 2)
                
                .background(Color.primary.opacity(0.2))
                
                .cornerRadius(7)
                .shadow(radius: 2)
            } else {
                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(14)
                    .shadow(radius: 5)

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(14)
                    .shadow(radius: 5)

                TextField("Name", text: $name)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(14)
                    .shadow(radius: 5)

                HStack {
                    Button("Log In") {
                        userManager.logIn(email: email, password: password)
                    }
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .padding(4)
                    .padding(.horizontal, 2)
                    
                    .background(Color.primary.opacity(0.2))
                    
                    .cornerRadius(7)
                    .shadow(radius: 2)

                    Button("Sign Up") {
                        userManager.signUp(email: email, password: password, name: name, preferences: preferences)
                    }
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .padding(4)
                    .padding(.horizontal, 2)
                    
                    .background(Color.primary.opacity(0.2))
                    
                    .cornerRadius(7)
                    .shadow(radius: 2)
                }
            }
        }
        .padding()
        .frame(maxWidth: 400)
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


    // Separate view for VideoPlayer to manage AVPlayer setup
    struct VideoPlayerView: View {
        let videoName: String

        var body: some View {
            if let url = Bundle.main.url(forResource: videoName, withExtension: "mp4") {
                VideoPlayer(player: AVPlayer(url: url))
                    .scaledToFit()
            } else {
                Text("Video not found")
                    .foregroundColor(.red)
            }
        }
    }


