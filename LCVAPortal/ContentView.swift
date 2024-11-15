import SwiftUI
import AVKit


struct ContentView: View {
    let exhibitions = sampleExhibitions // Sample data array
 
    let sampleArtist = Artist(
        name: "Sun English Jr.",
        bio: "Sun English Jr. is a sculptor and performance artist known for immersive installations.",
        imageUrls: [
            "Black Front",
            "M1",
            "Poison I",
            "Poison II"
        ],
        videos: ["small", "immure"]
    )
    
    
    @State private var selectedArtPiece: ArtPiece? = nil
    @State private var showMapModal = false
    @State private var isAnimating = false // Control both animations with a single state
    
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject private var userManager = UserManager() // Observable instance of UserManager
       @State private var email = ""
       @State private var password = ""
       @State private var name = ""
//       @State private var avatarUrl = ""
       @State private var preferences: [String] = []


    var body: some View {
        NavigationView {
            ScrollView {
                VStack() {
                    // Main title at the top
                    VStack {
                        Text("LONGWOOD")
                            .font(.system(size: 35, weight: .bold, design: .serif))
                            .tracking(5) // Adds spacing between letters for a formal look
                            .offset(y: isAnimating ? 0 : -100) // Start off-screen
                                            .opacity(isAnimating ? 1 : 0) // Fade in with the drop-down
                                            .animation(.easeOut(duration: 1), value: isAnimating)

                        Text("CENTER for the VISUAL ARTS")
                            .font(.system(size: 25, weight: .regular, design: .serif))
                            .italic() // Italics for 'for the' to create emphasis
                            .offset(y: isAnimating ? 0 : -100)
                                           .opacity(isAnimating ? 1 : 0)
                                           .animation(.easeOut(duration: 1).delay(0.2), value: isAnimating)
                    }
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.primary)
                    .padding(.top, 0)
                    .padding(.bottom, 20)
                    .onAppear {
                        isAnimating = false // Reset before starting
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            isAnimating = true // Trigger the animation slightly after the view appears
                        }
                    }
                    
                    
                        }
                    
                    // Current Exhibitions Section
                    VStack(alignment: .center, spacing: 16) {
                        Text("Current Exhibitions")
                            .font(.system(size: 20, weight: .regular, design: .serif))
                            .italic() // Italics for 'for the' to create emphasis

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
                                            
                                        // Dynamically display "Artist:" or "Artists:" based on the count
                                        Text((exhibition.artist.count > 1 ? "Artists:" : "Artist:"))
                                            .font(.system(size: 13, weight: .semibold))
                                        
                                            
                                        Text((exhibition.artist.joined(separator: ", ")))
                                            .font(.subheadline)
                                            .padding(1)
                                            .bold()
                                            .italic()
                                        Text("Reception:\n\(exhibition.reception)")
                                            .font(.caption)
                                            .padding(2)
                                            .bold()
                                        Text("Closing:\n\(exhibition.closing)")
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
                    
                    
                    
                    // Featured Artist Section
                    Text("Local Artist Spotlight")
                        .font(.system(size: 20, weight: .regular, design: .serif))
                        .italic() // Italics for 'for the' to create emphasis
                        .foregroundColor(.secondary)
                        .padding(.top, 25)
                        .padding(.bottom, 16)
                    VStack(alignment: .center, spacing: 16) {
                       
                        
                        Text(sampleArtist.name)
                            .font(.system(size: 16))
                            .italic()
                            .padding()
                        
                        Image("LCVAPhoto")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 250, height: 250)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                            .shadow(radius: 3)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(sampleArtist.imageUrls.prefix(3), id: \.self) { imageUrl in
                                    Image(imageUrl)
                                        .resizable()
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 120, height: 120)
                                        .clipShape(RoundedRectangle(cornerRadius: 4))
                                        .frame(width: 100, height: 100)
                                        .clipShape(RoundedRectangle(cornerRadius: 4))
                                        .padding(.vertical, 5)
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        NavigationLink(destination: ArtistDetailView(artist: sampleArtist)) {
                            Text("Click here to learn more about \(sampleArtist.name.components(separatedBy: " ").first ?? sampleArtist.name)'s practice.")
                                .font(.system(size: 14))
                                .foregroundColor(.blue)
                                .padding(.vertical)
                        }
                        
                        
                    }
                    .padding(.horizontal)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(colorScheme == .dark ? Color.gray.opacity(0.3) : Color.white)
                                            .shadow(radius: 3)
                    )
                    .frame(maxWidth: 360)
                    
                    
                    // Featured Art on Campus Section
                    VStack(alignment: .center, spacing: 16) {
                        Text("Featured Art on Campus")
                            .font(.system(size: 20, weight: .regular, design: .serif))
                            .italic() // Italics for 'for the' to create emphasis
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
//                                                .aspectRatio(contentMode: .fill)

                                                .frame(width: 150, height: 150)
//                                                .padding()
                                                .clipShape(RoundedRectangle(cornerRadius:4))
                                                .onTapGesture {
                                                    selectedArtPiece = artPiece
                                                    showMapModal = true
                                                        
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
                        .clipShape(RoundedRectangle(cornerRadius: 3))
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(colorScheme == .dark ? Color.gray.opacity(0.3) : Color.white)
                                                .shadow(radius: 3)
                        )
                        .frame(maxWidth: 360)
                        .sheet(item: $selectedArtPiece) { artPiece in
                            NavigationView {
                                MapModalView(artPiece: artPiece)
                            }
                        }
                    }
                
                VStack {
                            if userManager.isLoggedIn {
                                    Text("Welcome, \(userManager.currentUser?.email ?? "User")!")
                                    
                                    
                                    // Log Out Button
                                    Button("Log Out") {
                                        userManager.logOut()
                                    }
                                    .padding()
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(3)
                            } else {
                                // Signup UI
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

//                                    TextField("Avatar URL", text: $avatarUrl)
//                                        .autocapitalization(.none)
//                                        .padding()
//                                        .background(Color.gray.opacity(0.1))
//                                        .cornerRadius(5)
                                HStack {
                                    Button("Log In") {
                                        userManager.logIn(email: email, password: password)
                                    }
                                    .padding(3)
                                    .padding(.horizontal, 2)
                                    .background(Color.primary.opacity(0.2))
                                    .foregroundColor(.white)
                                    .cornerRadius(3)
                                    .shadow(radius: 2)

                                    Button("Sign Up") {
                                        userManager.signUp(email: email, password: password, name: name, preferences: preferences)
                                    }
                                    .padding(3)
                                    .padding(.horizontal, 2)
                                    .background(Color.primary.opacity(0.2))
                                    .foregroundColor(.white)
                                    .cornerRadius(3)
                                    .shadow(radius: 2)
                                }
                                
                            }
                        }
                        .padding()
                    
                }
//                .padding(.vertical)
            }
            .navigationBarHidden(true)
        
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


