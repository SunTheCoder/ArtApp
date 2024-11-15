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

    @State private var selectedArtPiece: ArtPiece? = nil
    @State private var isAnimating = false
    @StateObject private var userManager = UserManager()
    
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HeaderView(isAnimating: $isAnimating)
                    CurrentExhibitionsView(exhibitions: exhibitions, colorScheme: colorScheme)
                    FeaturedArtistView(sampleArtist: sampleArtist, colorScheme: colorScheme)
                    FeaturedArtOnCampusView(selectedArtPiece: $selectedArtPiece)
                    UserAuthenticationView(userManager: userManager)
                }
                .navigationTitle("Exhibitions")
                .navigationBarHidden(true)
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

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Text("Current Exhibitions")
                .font(.system(size: 20, weight: .regular, design: .serif))
                .italic()
                .foregroundColor(.secondary)
                .padding(.bottom, 8)
            
            ForEach(exhibitions) { exhibition in
                NavigationLink(destination: ExhibitionDetailView(exhibition: exhibition)) {
                    HStack(spacing: 16) {
                        AsyncImage(url: URL(string: exhibition.imageUrl)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                        } placeholder: {
                            ProgressView()
                        }
                        
                        VStack(alignment: .center, spacing: 4) {
                            Text(exhibition.title)
                                .font(.headline)
                                .padding(.bottom, 4)
                                
                            Text(exhibition.artist.joined(separator: ", "))
                                .font(.subheadline)
                                .padding(1)
                                .bold()
                                .italic()
                            Text("Reception: \(exhibition.reception)")
                                .font(.caption)
                                .padding(2)
                                .bold()
                            Text("Closing: \(exhibition.closing)")
                                .font(.caption)
                                .padding(2)
                                .bold()

                            Link("Survey Link", destination: URL(string: exhibition.surveyUrl)!)
                                .font(.caption)
                                .padding(4)
                                .foregroundColor(.blue)
                                .background(Color.teal.opacity(0.1))
                                .cornerRadius(4)
                                .accessibilityLabel("Open Survey Link")
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(colorScheme == .dark ? Color.gray.opacity(0.3) : Color.white)
                            .shadow(radius: 3)
                    )
                }
            }
        }
        .padding(.horizontal)
        .foregroundColor(.primary)
    }
}

// MARK: - Featured Artist View
struct FeaturedArtistView: View {
    let sampleArtist: Artist
    let colorScheme: ColorScheme

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            TitleView()
            ArtistInfoView(name: sampleArtist.name)
            MainImageView()
            ImageGalleryView(imageUrls: sampleArtist.imageUrls)
            LearnMoreLinkView(sampleArtist: sampleArtist)
        }
        .padding(.horizontal)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(colorScheme == .dark ? Color.gray.opacity(0.3) : Color.white)
                .shadow(radius: 3)
        )
        .frame(maxWidth: 360)
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
                .font(.system(size: 16))
                .italic()
                .padding()
        }
    }

    private struct MainImageView: View {
        var body: some View {
            Image("LCVAPhoto")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 250, height: 250)
                .clipShape(RoundedRectangle(cornerRadius: 4))
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
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                            .padding(.vertical, 5)
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    private struct LearnMoreLinkView: View {
        let sampleArtist: Artist
        var body: some View {
            NavigationLink(destination: ArtistDetailView(artist: sampleArtist)) {
                Text("Click here to learn more about \(sampleArtist.name.split(separator: " ").first.map(String.init) ?? sampleArtist.name)'s practice.")
                    .font(.system(size: 14))
                    .foregroundColor(.blue)
                    .padding(.vertical)

            }
        }
    }
}

// MARK: - Featured Art on Campus View
struct FeaturedArtOnCampusView: View {
    @Binding var selectedArtPiece: ArtPiece?

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Text("Featured Art on Campus")
                .font(.system(size: 20, weight: .regular, design: .serif))
                .italic()
                .padding(.top, 25)
                .padding(.bottom, 8)
                .foregroundColor(.secondary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(featuredArtPieces) { artPiece in
                        VStack(spacing: 8) {
                            AsyncImage(url: URL(string: artPiece.imageUrl)) { image in
                                image
                                    .resizable()
                                    .frame(width: 150, height: 150)
                                    .clipShape(RoundedRectangle(cornerRadius: 4))
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
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.white)
                    .shadow(radius: 3)
            )
            .frame(maxWidth: 360)
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
                Text("Welcome, \(userManager.currentUser?.email ?? "User")!")
                
                Button("Log Out") {
                    userManager.logOut()
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(3)
            } else {
                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(3)

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(3)

                TextField("Name", text: $name)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(3)

                HStack {
                    Button("Log In") {
                        userManager.logIn(email: email, password: password)
                    }
                    .padding()
                    .background(Color.primary.opacity(0.2))
                    .foregroundColor(.white)
                    .cornerRadius(3)
                    .shadow(radius: 2)

                    Button("Sign Up") {
                        userManager.signUp(email: email, password: password, name: name, preferences: preferences)
                    }
                    .padding()
                    .background(Color.primary.opacity(0.2))
                    .foregroundColor(.white)
                    .cornerRadius(3)
                    .shadow(radius: 2)
                }
            }
        }
        .padding()
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


