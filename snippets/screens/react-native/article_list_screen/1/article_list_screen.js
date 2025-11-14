import React, { useState, useEffect, useCallback, useMemo } from 'react';
import {
  View,
  Text,
  StyleSheet,
  FlatList,
  Image,
  TouchableOpacity,
  TextInput,
  RefreshControl,
  ActivityIndicator,
  Alert,
  Dimensions,
  StatusBar,
  SafeAreaView
} from 'react-native';
import Icon from 'react-native-vector-icons/MaterialIcons';
import { formatDistanceToNow } from 'date-fns';

const { width } = Dimensions.get('window');

const ArticleListScreen = ({ navigation }) => {
  const [articles, setArticles] = useState([]);
  const [filteredArticles, setFilteredArticles] = useState([]);
  const [loading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);
  const [loadingMore, setLoadingMore] = useState(false);
  const [hasMore, setHasMore] = useState(true);
  const [page, setPage] = useState(1);
  const [searchText, setSearchText] = useState('');
  const [selectedCategory, setSelectedCategory] = useState('All');

  const categories = ['All', 'Technology', 'Business', 'Sports', 'Health', 'Entertainment'];

  // Generate sample articles
  const generateArticles = useCallback((pageNum) => {
    const titles = [
      'The Future of Artificial Intelligence in Healthcare',
      'Climate Change: What We Can Do Today',
      'Breaking: Major Tech Company Announces Revolutionary Product',
      'The Rise of Remote Work: Challenges and Opportunities',
      'Space Exploration: Humanity\'s Next Frontier',
      'Sustainable Energy Solutions for Tomorrow',
      'The Impact of Social Media on Mental Health',
      'Cryptocurrency: Understanding the Digital Economy',
      'Machine Learning Transforms Medical Diagnosis',
      'The Evolution of Electric Vehicles'
    ];

    const authors = ['Dr. Sarah Johnson', 'Michael Chen', 'Emma Rodriguez', 'Prof. David Kim', 'Lisa Thompson'];
    const tags = [
      ['technology', 'ai', 'healthcare'],
      ['environment', 'climate', 'sustainability'],
      ['business', 'technology', 'innovation'],
      ['workplace', 'productivity', 'lifestyle'],
      ['space', 'exploration', 'science'],
      ['energy', 'environment', 'technology'],
      ['health', 'social media', 'psychology'],
      ['finance', 'cryptocurrency', 'technology'],
      ['healthcare', 'ai', 'innovation'],
      ['automotive', 'technology', 'environment']
    ];

    return Array.from({ length: 20 }, (_, index) => {
      const globalIndex = (pageNum - 1) * 20 + index;
      const titleIndex = globalIndex % titles.length;

      return {
        id: `article_${globalIndex}`,
        title: titles[titleIndex],
        summary: `This comprehensive article explores the latest developments and insights in ${titles[titleIndex].toLowerCase()}, providing readers with expert analysis and actionable information.`,
        imageUrl: `https://picsum.photos/400/250?random=${globalIndex}`,
        author: authors[globalIndex % authors.length],
        publishDate: new Date(Date.now() - globalIndex * 24 * 60 * 60 * 1000),
        readTime: 3 + (globalIndex % 8),
        tags: tags[titleIndex],
        isBookmarked: false
      };
    });
  }, []);

  // Load initial articles
  useEffect(() => {
    loadArticles();
  }, []);

  const loadArticles = async (isRefresh = false) => {
    if (isRefresh) {
      setRefreshing(true);
      setPage(1);
      setHasMore(true);
    } else {
      setLoading(true);
    }

    try {
      // Simulate API call
      await new Promise(resolve => setTimeout(resolve, 1000));

      const newArticles = generateArticles(1);
      setArticles(newArticles);
      setPage(2);
    } catch (error) {
      Alert.alert('Error', 'Failed to load articles');
    } finally {
      setLoading(false);
      setRefreshing(false);
    }
  };

  // Filter articles
  const filterArticles = useMemo(() => {
    return articles.filter(article => {
      const matchesSearch = searchText === '' ||
        article.title.toLowerCase().includes(searchText.toLowerCase()) ||
        article.summary.toLowerCase().includes(searchText.toLowerCase());

      const matchesCategory = selectedCategory === 'All' ||
        article.tags.some(tag => tag.toLowerCase() === selectedCategory.toLowerCase());

      return matchesSearch && matchesCategory;
    });
  }, [articles, searchText, selectedCategory]);

  useEffect(() => {
    setFilteredArticles(filterArticles);
  }, [filterArticles]);

  // Load more articles
  const loadMoreArticles = async () => {
    if (loadingMore || !hasMore) return;

    setLoadingMore(true);

    try {
      await new Promise(resolve => setTimeout(resolve, 500));

      const newArticles = generateArticles(page);
      setArticles(prev => [...prev, ...newArticles]);
      setPage(prev => prev + 1);

      if (page > 5) {
        setHasMore(false);
      }
    } catch (error) {
      Alert.alert('Error', 'Failed to load more articles');
    } finally {
      setLoadingMore(false);
    }
  };

  // Toggle bookmark
  const toggleBookmark = useCallback((articleId) => {
    setArticles(prev =>
      prev.map(article =>
        article.id === articleId
          ? { ...article, isBookmarked: !article.isBookmarked }
          : article
      )
    );
  }, []);

  const renderHeader = () => (
    <View style={styles.header}>
      {/* Search Bar */}
      <View style={styles.searchContainer}>
        <Icon name="search" size={20} color="#666" style={styles.searchIcon} />
        <TextInput
          style={styles.searchInput}
          placeholder="Search articles..."
          placeholderTextColor="#666"
          value={searchText}
          onChangeText={setSearchText}
        />
        {searchText ? (
          <TouchableOpacity onPress={() => setSearchText('')}>
            <Icon name="clear" size={20} color="#666" />
          </TouchableOpacity>
        ) : null}
      </View>

      {/* Category Filters */}
      <FlatList
        horizontal
        showsHorizontalScrollIndicator={false}
        data={categories}
        keyExtractor={(item) => item}
        contentContainerStyle={styles.categoriesContainer}
        renderItem={({ item }) => (
          <TouchableOpacity
            style={[
              styles.categoryChip,
              selectedCategory === item && styles.selectedCategoryChip
            ]}
            onPress={() => setSelectedCategory(item)}
          >
            <Text
              style={[
                styles.categoryText,
                selectedCategory === item && styles.selectedCategoryText
              ]}
            >
              {item}
            </Text>
          </TouchableOpacity>
        )}
      />
    </View>
  );

  const renderArticleCard = ({ item }) => (
    <TouchableOpacity
      style={styles.articleCard}
      onPress={() => navigation.navigate('ArticleDetail', { article: item })}
      activeOpacity={0.7}
    >
      <Image
        source={{ uri: item.imageUrl }}
        style={styles.articleImage}
        resizeMode="cover"
      />

      <View style={styles.articleContent}>
        {/* Tags */}
        <View style={styles.tagsContainer}>
          {item.tags.slice(0, 2).map((tag, index) => (
            <View key={index} style={styles.tag}>
              <Text style={styles.tagText}>{tag}</Text>
            </View>
          ))}
        </View>

        {/* Title */}
        <Text style={styles.articleTitle} numberOfLines={2}>
          {item.title}
        </Text>

        {/* Summary */}
        <Text style={styles.articleSummary} numberOfLines={3}>
          {item.summary}
        </Text>

        {/* Author and Metadata */}
        <View style={styles.metadataContainer}>
          <View style={styles.authorContainer}>
            <View style={styles.authorAvatar}>
              <Text style={styles.authorAvatarText}>
                {item.author.charAt(0)}
              </Text>
            </View>
            <View style={styles.authorInfo}>
              <Text style={styles.authorName}>{item.author}</Text>
              <View style={styles.metadataRow}>
                <Icon name="schedule" size={14} color="#666" />
                <Text style={styles.metadataText}>
                  {item.readTime} min read
                </Text>
                <Text style={styles.metadataDot}>•</Text>
                <Text style={styles.metadataText}>
                  {formatDistanceToNow(new Date(item.publishDate), { addSuffix: true })}
                </Text>
              </View>
            </View>
          </View>

          <TouchableOpacity
            onPress={() => toggleBookmark(item.id)}
            style={styles.bookmarkButton}
          >
            <Icon
              name={item.isBookmarked ? 'bookmark' : 'bookmark-border'}
              size={24}
              color={item.isBookmarked ? '#2196F3' : '#666'}
            />
          </TouchableOpacity>
        </View>
      </View>
    </TouchableOpacity>
  );

  const renderLoadingMore = () => (
    loadingMore ? (
      <View style={styles.loadingMore}>
        <ActivityIndicator size="small" color="#2196F3" />
        <Text style={styles.loadingMoreText}>Loading more articles...</Text>
      </View>
    ) : null
  );

  const renderEmptyState = () => (
    <View style={styles.emptyState}>
      <Icon name="article" size={64} color="#ccc" />
      <Text style={styles.emptyTitle}>No articles found</Text>
      <Text style={styles.emptySubtitle}>
        Try adjusting your search or filters
      </Text>
      <TouchableOpacity
        style={styles.clearButton}
        onPress={() => {
          setSearchText('');
          setSelectedCategory('All');
        }}
      >
        <Text style={styles.clearButtonText}>Clear Filters</Text>
      </TouchableOpacity>
    </View>
  );

  if (loading) {
    return (
      <View style={styles.loadingContainer}>
        <ActivityIndicator size="large" color="#2196F3" />
        <Text style={styles.loadingText}>Loading articles...</Text>
      </View>
    );
  }

  return (
    <SafeAreaView style={styles.container}>
      <StatusBar barStyle="dark-content" backgroundColor="#fff" />

      {/* Header */}
      <View style={styles.appHeader}>
        <Text style={styles.appTitle}>Articles</Text>
        <View style={styles.headerActions}>
          <TouchableOpacity
            style={styles.headerButton}
            onPress={() => loadArticles(true)}
          >
            <Icon name="refresh" size={24} color="#333" />
          </TouchableOpacity>
          <TouchableOpacity
            style={styles.headerButton}
            onPress={() => navigation.navigate('Bookmarks')}
          >
            <Icon name="bookmark-border" size={24} color="#333" />
          </TouchableOpacity>
        </View>
      </View>

      <FlatList
        data={filteredArticles}
        keyExtractor={(item) => item.id}
        renderItem={renderArticleCard}
        ListHeaderComponent={renderHeader}
        ListEmptyComponent={renderEmptyState}
        ListFooterComponent={renderLoadingMore}
        refreshControl={
          <RefreshControl
            refreshing={refreshing}
            onRefresh={() => loadArticles(true)}
            colors={['#2196F3']}
          />
        }
        onEndReached={loadMoreArticles}
        onEndReachedThreshold={0.1}
        showsVerticalScrollIndicator={false}
        contentContainerStyle={filteredArticles.length === 0 ? styles.emptyContainer : null}
      />
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f5f5f5',
  },
  appHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 16,
    paddingVertical: 12,
    backgroundColor: '#fff',
    borderBottomWidth: 1,
    borderBottomColor: '#e0e0e0',
  },
  appTitle: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#333',
  },
  headerActions: {
    flexDirection: 'row',
    gap: 8,
  },
  headerButton: {
    padding: 8,
  },
  header: {
    backgroundColor: '#fff',
    paddingHorizontal: 16,
    paddingBottom: 16,
  },
  searchContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#f0f0f0',
    borderRadius: 12,
    paddingHorizontal: 12,
    marginVertical: 16,
    height: 44,
  },
  searchIcon: {
    marginRight: 8,
  },
  searchInput: {
    flex: 1,
    fontSize: 16,
    color: '#333',
  },
  categoriesContainer: {
    paddingHorizontal: 0,
  },
  categoryChip: {
    backgroundColor: '#f0f0f0',
    paddingHorizontal: 16,
    paddingVertical: 8,
    borderRadius: 20,
    marginRight: 8,
  },
  selectedCategoryChip: {
    backgroundColor: '#2196F3',
  },
  categoryText: {
    fontSize: 14,
    fontWeight: '500',
    color: '#333',
  },
  selectedCategoryText: {
    color: '#fff',
  },
  articleCard: {
    backgroundColor: '#fff',
    marginHorizontal: 16,
    marginBottom: 16,
    borderRadius: 12,
    overflow: 'hidden',
    elevation: 3,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
  },
  articleImage: {
    width: '100%',
    height: 200,
  },
  articleContent: {
    padding: 16,
  },
  tagsContainer: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    marginBottom: 8,
  },
  tag: {
    backgroundColor: '#e3f2fd',
    paddingHorizontal: 8,
    paddingVertical: 4,
    borderRadius: 12,
    marginRight: 8,
    marginBottom: 4,
  },
  tagText: {
    fontSize: 12,
    color: '#1976d2',
    fontWeight: '500',
  },
  articleTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    color: '#333',
    lineHeight: 24,
    marginBottom: 8,
  },
  articleSummary: {
    fontSize: 14,
    color: '#666',
    lineHeight: 20,
    marginBottom: 16,
  },
  metadataContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  authorContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    flex: 1,
  },
  authorAvatar: {
    width: 32,
    height: 32,
    borderRadius: 16,
    backgroundColor: '#2196F3',
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: 8,
  },
  authorAvatarText: {
    color: '#fff',
    fontWeight: 'bold',
    fontSize: 14,
  },
  authorInfo: {
    flex: 1,
  },
  authorName: {
    fontSize: 14,
    fontWeight: '600',
    color: '#333',
  },
  metadataRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginTop: 2,
  },
  metadataText: {
    fontSize: 12,
    color: '#666',
    marginLeft: 4,
  },
  metadataDot: {
    fontSize: 12,
    color: '#666',
    marginHorizontal: 8,
  },
  bookmarkButton: {
    padding: 4,
  },
  loadingContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#f5f5f5',
  },
  loadingText: {
    marginTop: 12,
    fontSize: 16,
    color: '#666',
  },
  loadingMore: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    padding: 16,
  },
  loadingMoreText: {
    marginLeft: 8,
    fontSize: 14,
    color: '#666',
  },
  emptyContainer: {
    flexGrow: 1,
  },
  emptyState: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    paddingHorizontal: 32,
  },
  emptyTitle: {
    fontSize: 20,
    fontWeight: 'bold',
    color: '#666',
    marginTop: 16,
    marginBottom: 8,
  },
  emptySubtitle: {
    fontSize: 14,
    color: '#999',
    textAlign: 'center',
    marginBottom: 24,
  },
  clearButton: {
    backgroundColor: '#2196F3',
    paddingHorizontal: 24,
    paddingVertical: 12,
    borderRadius: 8,
  },
  clearButtonText: {
    color: '#fff',
    fontSize: 14,
    fontWeight: '600',
  },
});

export default ArticleListScreen;