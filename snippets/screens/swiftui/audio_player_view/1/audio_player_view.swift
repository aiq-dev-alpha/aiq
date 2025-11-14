import SwiftUI
import AVFoundation
import MediaPlayer

struct AudioTrack: Identifiable {
    let id = UUID()
    let title: String
    let artist: String
    let album: String
    let coverURL: String
    let audioURL: String
    let duration: TimeInterval
    let genres: [String]
}

struct AudioPlayerView: View {
    let track: AudioTrack
    let playlist: [AudioTrack]

    @StateObject private var playerViewModel: AudioPlayerViewModel
    @State private var showPlaylist = false
    @State private var showLyrics = false

    init(track: AudioTrack, playlist: [AudioTrack] = []) {
        self.track = track
        self.playlist = playlist.isEmpty ? [track] : playlist
        self._playerViewModel = StateObject(wrappedValue: AudioPlayerViewModel(track: track, playlist: playlist.isEmpty ? [track] : playlist))
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Top Controls
                HStack {
                    Button {
                        // Dismiss
                    } label: {
                        Image(systemName: "chevron.down")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }

                    Spacer()

                    VStack {
                        Text("PLAYING FROM")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)

                        Text(playerViewModel.currentTrack.album)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }

                    Spacer()

                    Button {
                        // More options
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.title2)
                    }
                }
                .padding()

                Spacer()

                // Album Artwork
                VStack(spacing: 24) {
                    ZStack {
                        // Background blur effect
                        AsyncImage(url: URL(string: playerViewModel.currentTrack.coverURL)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width, height: geometry.size.width)
                                .clipped()
                                .blur(radius: 50)
                                .opacity(0.3)
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: geometry.size.width, height: geometry.size.width)
                        }

                        // Album Cover
                        AsyncImage(url: URL(string: playerViewModel.currentTrack.coverURL)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: min(300, geometry.size.width - 80), height: min(300, geometry.size.width - 80))
                                .clipped()
                                .cornerRadius(20)
                                .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
                                .rotationEffect(.degrees(playerViewModel.isPlaying ? 360 : 0))
                                .animation(
                                    playerViewModel.isPlaying ?
                                    .linear(duration: 10).repeatForever(autoreverses: false) :
                                    .default,
                                    value: playerViewModel.isPlaying
                                )
                        } placeholder: {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: min(300, geometry.size.width - 80), height: min(300, geometry.size.width - 80))
                                .overlay(
                                    Image(systemName: "music.note")
                                        .font(.system(size: 60))
                                        .foregroundColor(.gray)
                                )
                        }
                    }
                    .frame(height: min(300, geometry.size.width - 80))
                }

                Spacer()

                // Track Info and Controls
                VStack(spacing: 24) {
                    // Track Info
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(playerViewModel.currentTrack.title)
                                .font(.title2)
                                .fontWeight(.bold)
                                .lineLimit(1)

                            Text(playerViewModel.currentTrack.artist)
                                .font(.title3)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }

                        Spacer()

                        Button {
                            playerViewModel.toggleFavorite()
                        } label: {
                            Image(systemName: playerViewModel.isFavorite ? "heart.fill" : "heart")
                                .font(.title2)
                                .foregroundColor(playerViewModel.isFavorite ? .red : .primary)
                        }
                    }

                    // Progress Slider
                    VStack(spacing: 8) {
                        Slider(
                            value: $playerViewModel.currentTime,
                            in: 0...playerViewModel.duration,
                            onEditingChanged: { editing in
                                playerViewModel.isSeeking = editing
                            }
                        )
                        .accentColor(.primary)

                        HStack {
                            Text(playerViewModel.currentTimeString)
                                .font(.caption)
                                .foregroundColor(.secondary)

                            Spacer()

                            Text(playerViewModel.durationString)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }

                    // Main Controls
                    HStack(spacing: 40) {
                        Button {
                            playerViewModel.toggleShuffle()
                        } label: {
                            Image(systemName: playerViewModel.isShuffleEnabled ? "shuffle" : "shuffle")
                                .font(.title2)
                                .foregroundColor(playerViewModel.isShuffleEnabled ? .blue : .secondary)
                        }

                        Button {
                            playerViewModel.previousTrack()
                        } label: {
                            Image(systemName: "backward.end.fill")
                                .font(.title)
                        }

                        Button {
                            playerViewModel.togglePlayPause()
                        } label: {
                            Image(systemName: playerViewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                .font(.system(size: 64))
                        }

                        Button {
                            playerViewModel.nextTrack()
                        } label: {
                            Image(systemName: "forward.end.fill")
                                .font(.title)
                        }

                        Button {
                            playerViewModel.toggleRepeat()
                        } label: {
                            Image(systemName: playerViewModel.repeatMode == .none ? "repeat" :
                                  playerViewModel.repeatMode == .one ? "repeat.1" : "repeat")
                                .font(.title2)
                                .foregroundColor(playerViewModel.repeatMode != .none ? .blue : .secondary)
                        }
                    }

                    // Secondary Controls
                    HStack(spacing: 32) {
                        Button {
                            // AirPlay
                        } label: {
                            Image(systemName: "airplayaudio")
                                .font(.title3)
                                .foregroundColor(.secondary)
                        }

                        Button {
                            showPlaylist = true
                        } label: {
                            Image(systemName: "list.bullet")
                                .font(.title3)
                                .foregroundColor(.secondary)
                        }

                        Button {
                            showLyrics.toggle()
                        } label: {
                            Image(systemName: "quote.bubble")
                                .font(.title3)
                                .foregroundColor(showLyrics ? .blue : .secondary)
                        }
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 32)
            }
        }
        .background(.ultraThinMaterial)
        .sheet(isPresented: $showPlaylist) {
            PlaylistView(
                playlist: playlist,
                currentTrackId: playerViewModel.currentTrack.id,
                onTrackSelect: { track in
                    playerViewModel.playTrack(track)
                }
            )
        }
        .overlay(alignment: .bottom) {
            if showLyrics {
                LyricsOverlay()
                    .transition(.move(edge: .bottom))
            }
        }
    }
}

struct PlaylistView: View {
    let playlist: [AudioTrack]
    let currentTrackId: UUID
    let onTrackSelect: (AudioTrack) -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            List {
                ForEach(playlist) { track in
                    HStack {
                        AsyncImage(url: URL(string: track.coverURL)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 44, height: 44)
                                .clipped()
                                .cornerRadius(8)
                        } placeholder: {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 44, height: 44)
                        }

                        VStack(alignment: .leading, spacing: 2) {
                            Text(track.title)
                                .font(.subheadline)
                                .fontWeight(track.id == currentTrackId ? .bold : .medium)
                                .foregroundColor(track.id == currentTrackId ? .blue : .primary)

                            Text("\(track.artist) • \(track.album)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        Spacer()

                        if track.id == currentTrackId {
                            Image(systemName: "speaker.wave.2.fill")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        onTrackSelect(track)
                        dismiss()
                    }
                }
            }
            .navigationTitle("Now Playing")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct LyricsOverlay: View {
    private let sampleLyrics = [
        "Welcome to this amazing song",
        "The melody flows so beautifully",
        "With every note and every beat",
        "Music brings us together",
        "In harmony we find our peace",
        "Let the rhythm take control",
        "Feel the music in your soul",
        "This is where we belong"
    ]

    var body: some View {
        VStack {
            Spacer()

            VStack(alignment: .leading, spacing: 0) {
                // Handle
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.secondary)
                    .frame(width: 40, height: 6)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 12)

                // Header
                Text("Lyrics")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.top, 16)
                    .padding(.horizontal, 20)

                // Lyrics
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(Array(sampleLyrics.enumerated()), id: \.offset) { index, lyric in
                            Text(lyric)
                                .font(.body)
                                .foregroundColor(index == 2 ? .primary : .secondary)
                                .fontWeight(index == 2 ? .semibold : .regular)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                }
            }
            .frame(height: 300)
            .background(.regularMaterial)
            .cornerRadius(20, corners: [.topLeft, .topRight])
        }
    }
}

enum RepeatMode {
    case none, one, all
}

@MainActor
class AudioPlayerViewModel: ObservableObject {
    @Published var currentTrack: AudioTrack
    @Published var isPlaying = false
    @Published var currentTime: Double = 0
    @Published var duration: Double = 0
    @Published var isShuffleEnabled = false
    @Published var repeatMode: RepeatMode = .none
    @Published var isFavorite = false
    @Published var isSeeking = false

    private var player: AVAudioPlayer?
    private var playlist: [AudioTrack]
    private var currentIndex = 0

    var currentTimeString: String {
        formatTime(currentTime)
    }

    var durationString: String {
        formatTime(duration)
    }

    init(track: AudioTrack, playlist: [AudioTrack]) {
        self.currentTrack = track
        self.playlist = playlist
        self.currentIndex = playlist.firstIndex(where: { $0.id == track.id }) ?? 0

        setupAudio()
        setupRemoteTransportControls()
    }

    private func setupAudio() {
        // In a real app, you would load and play the actual audio file
        duration = currentTrack.duration

        // Simulate playback progress
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            if self.isPlaying && !self.isSeeking {
                self.currentTime += 0.5
                if self.currentTime >= self.duration {
                    self.currentTime = 0
                    self.nextTrack()
                }
            }
        }
    }

    private func setupRemoteTransportControls() {
        let commandCenter = MPRemoteCommandCenter.shared()

        commandCenter.playCommand.addTarget { _ in
            self.play()
            return .success
        }

        commandCenter.pauseCommand.addTarget { _ in
            self.pause()
            return .success
        }

        commandCenter.nextTrackCommand.addTarget { _ in
            self.nextTrack()
            return .success
        }

        commandCenter.previousTrackCommand.addTarget { _ in
            self.previousTrack()
            return .success
        }

        updateNowPlayingInfo()
    }

    private func updateNowPlayingInfo() {
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = currentTrack.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = currentTrack.artist
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = currentTrack.album
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = duration
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTime

        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }

    func togglePlayPause() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }

    func play() {
        isPlaying = true
        updateNowPlayingInfo()
    }

    func pause() {
        isPlaying = false
        updateNowPlayingInfo()
    }

    func nextTrack() {
        if isShuffleEnabled {
            currentIndex = Int.random(in: 0..<playlist.count)
        } else {
            currentIndex = (currentIndex + 1) % playlist.count
        }
        playTrack(playlist[currentIndex])
    }

    func previousTrack() {
        if currentTime > 3.0 {
            currentTime = 0
        } else {
            currentIndex = currentIndex > 0 ? currentIndex - 1 : playlist.count - 1
            playTrack(playlist[currentIndex])
        }
    }

    func playTrack(_ track: AudioTrack) {
        currentTrack = track
        currentTime = 0
        duration = track.duration
        if let index = playlist.firstIndex(where: { $0.id == track.id }) {
            currentIndex = index
        }
        updateNowPlayingInfo()
    }

    func toggleShuffle() {
        isShuffleEnabled.toggle()
    }

    func toggleRepeat() {
        switch repeatMode {
        case .none:
            repeatMode = .all
        case .all:
            repeatMode = .one
        case .one:
            repeatMode = .none
        }
    }

    func toggleFavorite() {
        isFavorite.toggle()
    }

    private func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}