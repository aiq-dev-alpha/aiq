import SwiftUI

struct ArticleContent {
    let type: ContentType
    let text: String
    let imageURL: String?
    let caption: String?

    enum ContentType {
        case text, image, quote, heading
    }
}

struct ArticleDetailView: View {
    let article: Article
    @State private var isBookmarked: Bool
    @State private var isLiked = false
    @State private var showShareSheet = false
    @State private var fontSize: CGFloat = 16
    @State private var showFontSizeSlider = false
    @State private var readingProgress: Double = 0
    @State private var showComments = false

    private let content: [ArticleContent] = [
        ArticleContent(type: .heading, text: "Introduction", imageURL: nil, caption: nil),
        ArticleContent(type: .text, text: "In today's rapidly evolving digital landscape, technology continues to reshape how we live, work, and interact with the world around us. This comprehensive analysis explores the latest trends and their implications for our future.", imageURL: nil, caption: nil),
        ArticleContent(type: .image, text: "", imageURL: "https://picsum.photos/600/400?random=1", caption: "The future of technology is here, transforming every aspect of our daily lives."),
        ArticleContent(type: .text, text: "As we delve deeper into the 21st century, the pace of technological advancement shows no signs of slowing down. From artificial intelligence to quantum computing, breakthrough innovations are emerging at an unprecedented rate.", imageURL: nil, caption: nil),
        ArticleContent(type: .quote, text: "The best way to predict the future is to create it. Technology gives us the tools to build the world we want to see.", imageURL: nil, caption: nil),
        ArticleContent(type: .text, text: "These developments bring both opportunities and challenges. While technology offers solutions to complex global problems, it also raises important questions about privacy, ethics, and the future of human employment.", imageURL: nil, caption: nil),
        ArticleContent(type: .image, text: "", imageURL: "https://picsum.photos/600/400?random=2", caption: "Innovation hubs around the world are driving technological progress."),
        ArticleContent(type: .text, text: "Looking ahead, the integration of emerging technologies will likely accelerate, creating new possibilities we can barely imagine today. The key is to approach these changes thoughtfully, ensuring that progress serves humanity's best interests.", imageURL: nil, caption: nil)
    ]

    init(article: Article) {
        self.article = article
        self._isBookmarked = State(initialValue: article.isBookmarked)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Hero Image
                AsyncImage(url: URL(string: article.imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 300)
                        .clipped()
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 300)
                        .overlay(
                            ProgressView()
                        )
                }

                VStack(alignment: .leading, spacing: 16) {
                    // Tags
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(article.tags, id: \.self) { tag in
                                Text(tag.capitalized)
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.blue.opacity(0.1))
                                    .foregroundColor(.blue)
                                    .cornerRadius(8)
                            }
                        }
                        .padding(.horizontal)
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        // Title
                        Text(article.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .lineSpacing(4)

                        // Author and Metadata
                        HStack {
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        Text(String(article.author.prefix(1)))
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                    )

                                VStack(alignment: .leading) {
                                    Text(article.author)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)

                                    Text("\(article.publishDate.formatted(date: .abbreviated, time: .omitted)) • \(article.readTime) min read")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }

                            Spacer()

                            Button {
                                showFontSizeSlider.toggle()
                            } label: {
                                Image(systemName: "textformat.size")
                                    .font(.title3)
                                    .foregroundColor(.gray)
                            }
                        }

                        // Font Size Slider
                        if showFontSizeSlider {
                            VStack {
                                HStack {
                                    Text("Aa")
                                        .font(.caption)
                                    Slider(value: $fontSize, in: 12...24, step: 1)
                                    Text("Aa")
                                        .font(.title3)
                                }
                                .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 8)
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(8)
                            .transition(.opacity)
                        }

                        Divider()

                        // Article Summary
                        Text(article.summary)
                            .font(.title3)
                            .fontWeight(.medium)
                            .lineSpacing(6)
                            .foregroundColor(.secondary)
                            .padding(.vertical, 8)

                        Divider()

                        // Article Content
                        VStack(alignment: .leading, spacing: 20) {
                            ForEach(Array(content.enumerated()), id: \.offset) { index, item in
                                ArticleContentView(
                                    content: item,
                                    fontSize: fontSize
                                )
                            }
                        }

                        Divider()
                            .padding(.vertical)

                        // Action Buttons
                        HStack(spacing: 20) {
                            ActionButton(
                                icon: isLiked ? "heart.fill" : "heart",
                                label: "Like",
                                isActive: isLiked,
                                color: .red
                            ) {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    isLiked.toggle()
                                }
                            }

                            ActionButton(
                                icon: "bubble.left",
                                label: "Comment",
                                isActive: false,
                                color: .blue
                            ) {
                                showComments = true
                            }

                            ActionButton(
                                icon: "square.and.arrow.up",
                                label: "Share",
                                isActive: false,
                                color: .green
                            ) {
                                showShareSheet = true
                            }

                            ActionButton(
                                icon: isBookmarked ? "bookmark.fill" : "bookmark",
                                label: "Save",
                                isActive: isBookmarked,
                                color: .blue
                            ) {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    isBookmarked.toggle()
                                }
                            }
                        }
                        .padding(.vertical)

                        Divider()

                        // Related Articles
                        RelatedArticlesView()
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button {
                        showShareSheet = true
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }

                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isBookmarked.toggle()
                        }
                    } label: {
                        Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                            .foregroundColor(isBookmarked ? .blue : .primary)
                    }
                }
            }
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(activityItems: [article.title, URL(string: "https://example.com/article/\(article.id)")!])
        }
        .sheet(isPresented: $showComments) {
            CommentsView()
        }
    }
}

struct ArticleContentView: View {
    let content: ArticleContent
    let fontSize: CGFloat

    var body: some View {
        switch content.type {
        case .text:
            Text(content.text)
                .font(.system(size: fontSize))
                .lineSpacing(6)
                .fixedSize(horizontal: false, vertical: true)

        case .heading:
            Text(content.text)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 8)

        case .image:
            VStack(alignment: .leading, spacing: 8) {
                AsyncImage(url: URL(string: content.imageURL ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(12)
                } placeholder: {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.2))
                        .aspectRatio(3/2, contentMode: .fit)
                        .overlay(
                            ProgressView()
                        )
                }

                if let caption = content.caption {
                    Text(caption)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .italic()
                }
            }

        case .quote:
            HStack(alignment: .top, spacing: 12) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.blue)
                    .frame(width: 4)

                Text(content.text)
                    .font(.system(size: fontSize + 2))
                    .italic()
                    .lineSpacing(6)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 8)
        }
    }
}

struct ActionButton: View {
    let icon: String
    let label: String
    let isActive: Bool
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(isActive ? color : .gray)

                Text(label)
                    .font(.caption)
                    .foregroundColor(isActive ? color : .gray)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct RelatedArticlesView: View {
    private let relatedArticles = [
        ("The Impact of AI on Modern Society", "https://picsum.photos/120/80?random=10"),
        ("Understanding Climate Technology", "https://picsum.photos/120/80?random=11"),
        ("Future of Remote Work", "https://picsum.photos/120/80?random=12"),
        ("Digital Health Revolution", "https://picsum.photos/120/80?random=13")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Related Articles")
                .font(.title2)
                .fontWeight(.bold)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(Array(relatedArticles.enumerated()), id: \.offset) { index, article in
                        RelatedArticleCard(
                            title: article.0,
                            imageURL: article.1
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct RelatedArticleCard: View {
    let title: String
    let imageURL: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: URL(string: imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 160, height: 100)
                    .clipped()
                    .cornerRadius(8)
            } placeholder: {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 160, height: 100)
            }

            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .lineLimit(2)
                .frame(width: 160, alignment: .leading)
        }
        .padding(.vertical, 4)
    }
}

struct CommentsView: View {
    @Environment(\.dismiss) private var dismiss

    private let comments = [
        ("Alice Johnson", "2 hours ago", "Great article! Really insightful analysis of the current tech landscape."),
        ("Bob Smith", "4 hours ago", "I particularly enjoyed the section about emerging technologies. Very well written!"),
        ("Carol Davis", "1 day ago", "This gives me a lot to think about. Thanks for sharing your perspective."),
        ("David Wilson", "2 days ago", "Excellent research and presentation. Looking forward to more articles like this.")
    ]

    var body: some View {
        NavigationView {
            VStack {
                // Comments Header
                HStack {
                    Text("Comments")
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                    Button("Done") {
                        dismiss()
                    }
                }
                .padding()

                // Comments List
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(Array(comments.enumerated()), id: \.offset) { index, comment in
                            CommentRow(
                                name: comment.0,
                                timestamp: comment.1,
                                text: comment.2
                            )
                        }
                    }
                    .padding(.horizontal)
                }

                // Comment Input
                HStack {
                    TextField("Write a comment...", text: .constant(""))
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button("Post") {
                        // Post comment
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                }
                .padding()
                .background(Color(UIColor.systemBackground))
            }
        }
    }
}

struct CommentRow: View {
    let name: String
    let timestamp: String
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(Color.blue)
                .frame(width: 36, height: 36)
                .overlay(
                    Text(String(name.prefix(1)))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                )

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(name)
                        .font(.subheadline)
                        .fontWeight(.semibold)

                    Text(timestamp)
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Spacer()
                }

                Text(text)
                    .font(.body)
                    .lineSpacing(4)
            }
        }
        .padding(.vertical, 4)
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}