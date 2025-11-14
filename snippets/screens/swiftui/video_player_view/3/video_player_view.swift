import SwiftUI
import AVKit
import AVFoundation

struct VideoData: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let videoURL: String
    let thumbnailURL: String
    let duration: TimeInterval
    let author: String
    let views: Int
    let uploadDate: Date
    var isLiked: Bool = false
    var isBookmarked: Bool = false
}

struct VideoPlayerView: View {
    let video: VideoData
    @StateObject private var playerViewModel: VideoPlayerViewModel
    @State private var showControls = true
    @State private var isFullScreen = false
    @State private var showMoreOptions = false
    @State private var showComments = false
    @State private var showDescription = false

    init(video: VideoData) {
        self.video = video
        self._playerViewModel = StateObject(wrappedValue: VideoPlayerViewModel(video: video))
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Video Player
                ZStack {
                    VideoPlayerRepresentable(
                        player: playerViewModel.player,
                        showControls: $showControls
                    )
                    .aspectRatio(16/9, contentMode: .fit)
                    .background(Color.black)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showControls.toggle()
                        }
                    }

                    // Custom Controls Overlay
                    if showControls {
                        VideoControlsOverlay(
                            viewModel: playerViewModel,
                            onFullScreenTap: {
                                isFullScreen.toggle()
                            }
                        )
                        .transition(.opacity)
                    }

                    // Loading Indicator
                    if playerViewModel.isLoading {
                        ProgressView()
                            .scaleEffect(1.5)
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    }
                }

                // Video Information
                if !isFullScreen {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            // Video Title and Actions
                            VStack(alignment: .leading, spacing: 12) {
                                Text(video.title)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .lineLimit(2)

                                Text("\(video.views.formatted()) views • \(video.uploadDate.formatted(date: .abbreviated, time: .omitted))")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)

                                // Action Buttons
                                HStack(spacing: 24) {
                                    VideoActionButton(
                                        icon: playerViewModel.isLiked ? "hand.thumbsup.fill" : "hand.thumbsup",
                                        label: "Like",
                                        isActive: playerViewModel.isLiked
                                    ) {
                                        playerViewModel.toggleLike()
                                    }

                                    VideoActionButton(
                                        icon: "hand.thumbsdown",
                                        label: "Dislike",
                                        isActive: false
                                    ) {
                                        // Handle dislike
                                    }

                                    VideoActionButton(
                                        icon: "square.and.arrow.up",
                                        label: "Share",
                                        isActive: false
                                    ) {
                                        // Handle share
                                    }

                                    VideoActionButton(
                                        icon: "arrow.down.circle",
                                        label: "Download",
                                        isActive: false
                                    ) {
                                        playerViewModel.downloadVideo()
                                    }

                                    Spacer()

                                    Button {
                                        showMoreOptions = true
                                    } label: {
                                        Image(systemName: "ellipsis")
                                            .font(.title2)
                                            .foregroundColor(.primary)
                                    }
                                }
                            }

                            Divider()

                            // Channel Info
                            HStack {
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        Text(String(video.author.prefix(1)))
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                    )

                                VStack(alignment: .leading) {
                                    Text(video.author)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)

                                    Text("1.2M subscribers")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }

                                Spacer()

                                Button {
                                    // Subscribe action
                                } label: {
                                    Text("Subscribe")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(Color.red)
                                        .cornerRadius(20)
                                }
                            }

                            // Description
                            VStack(alignment: .leading, spacing: 8) {
                                Button {
                                    withAnimation {
                                        showDescription.toggle()
                                    }
                                } label: {
                                    HStack {
                                        Text("Description")
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.primary)

                                        Spacer()

                                        Image(systemName: showDescription ? "chevron.up" : "chevron.down")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }

                                if showDescription {
                                    Text(video.description)
                                        .font(.body)
                                        .lineSpacing(4)
                                        .transition(.opacity)
                                }
                            }
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(12)

                            // Comments Section
                            Button {
                                showComments = true
                            } label: {
                                HStack {
                                    Text("Comments")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.primary)

                                    Spacer()

                                    Text("View all")
                                        .font(.caption)
                                        .foregroundColor(.secondary)

                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(12)
                            }

                            // Related Videos
                            RelatedVideosView()
                        }
                        .padding()
                    }
                }
            }
        }
        .navigationBarHidden(isFullScreen)
        .onDisappear {
            playerViewModel.pause()
        }
        .sheet(isPresented: $showMoreOptions) {
            VideoOptionsSheet(video: video, viewModel: playerViewModel)
        }
        .sheet(isPresented: $showComments) {
            VideoCommentsView()
        }
    }
}

struct VideoPlayerRepresentable: UIViewRepresentable {
    let player: AVPlayer
    @Binding var showControls: Bool

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspect
        view.layer.addSublayer(playerLayer)

        // Add tap gesture
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap))
        view.addGestureRecognizer(tapGesture)

        context.coordinator.playerLayer = playerLayer
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        if let playerLayer = context.coordinator.playerLayer {
            playerLayer.frame = uiView.bounds
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        let parent: VideoPlayerRepresentable
        var playerLayer: AVPlayerLayer?

        init(_ parent: VideoPlayerRepresentable) {
            self.parent = parent
        }

        @objc func handleTap() {
            parent.showControls.toggle()
        }
    }
}

struct VideoControlsOverlay: View {
    @ObservedObject var viewModel: VideoPlayerViewModel
    let onFullScreenTap: () -> Void

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color.black.opacity(0.7),
                    Color.clear,
                    Color.clear,
                    Color.black.opacity(0.7)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            VStack {
                // Top Controls
                HStack {
                    Button {
                        // Back action
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                    }

                    Spacer()

                    Button {
                        viewModel.toggleSettings()
                    } label: {
                        Image(systemName: "gearshape")
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                }
                .padding()

                Spacer()

                // Center Play/Pause Button
                Button {
                    viewModel.togglePlayPause()
                } label: {
                    Image(systemName: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.3))
                        .clipShape(Circle())
                }

                Spacer()

                // Bottom Controls
                VStack(spacing: 8) {
                    // Progress Bar
                    HStack {
                        Text(viewModel.currentTimeString)
                            .font(.caption)
                            .foregroundColor(.white)

                        Slider(
                            value: $viewModel.currentTime,
                            in: 0...viewModel.duration,
                            onEditingChanged: { editing in
                                viewModel.isSeeking = editing
                            }
                        )
                        .accentColor(.red)

                        Text(viewModel.durationString)
                            .font(.caption)
                            .foregroundColor(.white)
                    }

                    // Control Buttons
                    HStack {
                        Button {
                            viewModel.skipBackward()
                        } label: {
                            Image(systemName: "gobackward.10")
                                .font(.title2)
                                .foregroundColor(.white)
                        }

                        Spacer()

                        Button {
                            viewModel.togglePlayPause()
                        } label: {
                            Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                        }

                        Spacer()

                        Button {
                            viewModel.skipForward()
                        } label: {
                            Image(systemName: "goforward.10")
                                .font(.title2)
                                .foregroundColor(.white)
                        }

                        Spacer()

                        Button {
                            onFullScreenTap()
                        } label: {
                            Image(systemName: "arrow.up.left.and.arrow.down.right")
                                .font(.title3)
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding()
            }
        }
    }
}

struct VideoActionButton: View {
    let icon: String
    let label: String
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(isActive ? .blue : .primary)

                Text(label)
                    .font(.caption)
                    .foregroundColor(isActive ? .blue : .secondary)
            }
        }
    }
}

struct VideoOptionsSheet: View {
    let video: VideoData
    @ObservedObject var viewModel: VideoPlayerViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                List {
                    Section {
                        HStack {
                            Image(systemName: "speedometer")
                            Text("Playback Speed")
                            Spacer()
                            Text("\(viewModel.playbackSpeed, specifier: "%.1f")x")
                                .foregroundColor(.secondary)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.showSpeedOptions = true
                        }

                        HStack {
                            Image(systemName: "video.badge.waveform")
                            Text("Quality")
                            Spacer()
                            Text(viewModel.selectedQuality)
                                .foregroundColor(.secondary)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.showQualityOptions = true
                        }

                        HStack {
                            Image(systemName: "captions.bubble")
                            Text("Subtitles")
                            Spacer()
                            Text("English")
                                .foregroundColor(.secondary)
                        }
                    }

                    Section {
                        Button {
                            viewModel.saveToPlaylist()
                        } label: {
                            HStack {
                                Image(systemName: "plus.rectangle.on.folder")
                                Text("Save to Playlist")
                                    .foregroundColor(.primary)
                            }
                        }

                        Button {
                            viewModel.downloadVideo()
                        } label: {
                            HStack {
                                Image(systemName: "arrow.down.circle")
                                Text("Download")
                                    .foregroundColor(.primary)
                            }
                        }

                        Button {
                            // Report functionality
                        } label: {
                            HStack {
                                Image(systemName: "flag")
                                Text("Report")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Video Options")
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

struct RelatedVideosView: View {
    private let relatedVideos = [
        ("Amazing Technology Demo Part 2", "https://picsum.photos/160/90?random=20", "10:45"),
        ("The Future of AI Development", "https://picsum.photos/160/90?random=21", "8:32"),
        ("Mobile App Design Principles", "https://picsum.photos/160/90?random=22", "15:20"),
        ("Advanced Flutter Techniques", "https://picsum.photos/160/90?random=23", "12:15")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Up Next")
                .font(.headline)
                .fontWeight(.bold)

            VStack(spacing: 12) {
                ForEach(Array(relatedVideos.enumerated()), id: \.offset) { index, video in
                    RelatedVideoRow(
                        title: video.0,
                        thumbnailURL: video.1,
                        duration: video.2
                    )
                }
            }
        }
    }
}

struct RelatedVideoRow: View {
    let title: String
    let thumbnailURL: String
    let duration: String

    var body: some View {
        HStack(spacing: 12) {
            ZStack(alignment: .bottomTrailing) {
                AsyncImage(url: URL(string: thumbnailURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 68)
                        .clipped()
                        .cornerRadius(8)
                } placeholder: {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 120, height: 68)
                }

                Text(duration)
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                    .background(Color.black.opacity(0.8))
                    .cornerRadius(4)
                    .padding(4)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(2)

                Text("TechChannel • 1.2M views • 2 days ago")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            Button {
                // More options
            } label: {
                Image(systemName: "ellipsis")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

struct VideoCommentsView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack {
                Text("Video Comments")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()

                // Comments would go here
                Spacer()

                Text("Comments feature coming soon")
                    .foregroundColor(.secondary)

                Spacer()
            }
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

@MainActor
class VideoPlayerViewModel: ObservableObject {
    @Published var player: AVPlayer
    @Published var isPlaying = false
    @Published var isLoading = true
    @Published var currentTime: Double = 0
    @Published var duration: Double = 0
    @Published var isLiked = false
    @Published var playbackSpeed: Double = 1.0
    @Published var selectedQuality = "Auto"
    @Published var isSeeking = false
    @Published var showSpeedOptions = false
    @Published var showQualityOptions = false

    private var timeObserver: Any?
    private let video: VideoData

    var currentTimeString: String {
        formatTime(currentTime)
    }

    var durationString: String {
        formatTime(duration)
    }

    init(video: VideoData) {
        self.video = video
        self.isLiked = video.isLiked

        guard let url = URL(string: video.videoURL) else {
            self.player = AVPlayer()
            return
        }

        self.player = AVPlayer(url: url)
        setupPlayerObservers()
        loadVideoData()
    }

    deinit {
        if let timeObserver = timeObserver {
            player.removeTimeObserver(timeObserver)
        }
    }

    private func setupPlayerObservers() {
        // Time observer
        timeObserver = player.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 0.5, preferredTimescale: 1000),
            queue: .main
        ) { [weak self] time in
            guard let self = self, !self.isSeeking else { return }
            self.currentTime = time.seconds
        }

        // Player status observer
        player.publisher(for: \.status)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                self?.isLoading = status == .unknown
            }
            .store(in: &cancellables)

        // Duration observer
        player.publisher(for: \.currentItem?.duration)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] duration in
                self?.duration = duration?.seconds ?? 0
            }
            .store(in: &cancellables)
    }

    private var cancellables = Set<AnyCancellable>()

    private func loadVideoData() {
        duration = video.duration
    }

    func togglePlayPause() {
        if isPlaying {
            player.pause()
        } else {
            player.play()
        }
        isPlaying.toggle()
    }

    func pause() {
        player.pause()
        isPlaying = false
    }

    func skipForward() {
        let newTime = min(currentTime + 10, duration)
        player.seek(to: CMTime(seconds: newTime, preferredTimescale: 1000))
    }

    func skipBackward() {
        let newTime = max(currentTime - 10, 0)
        player.seek(to: CMTime(seconds: newTime, preferredTimescale: 1000))
    }

    func toggleLike() {
        isLiked.toggle()
    }

    func downloadVideo() {
        // Download implementation
    }

    func saveToPlaylist() {
        // Save to playlist implementation
    }

    func toggleSettings() {
        // Settings implementation
    }

    private func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}