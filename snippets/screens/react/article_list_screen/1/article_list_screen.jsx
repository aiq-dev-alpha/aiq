import React, { useState, useEffect, useCallback, useMemo } from 'react';
import {
  Box,
  Card,
  CardContent,
  CardMedia,
  Typography,
  TextField,
  InputAdornment,
  IconButton,
  Chip,
  Avatar,
  Menu,
  MenuItem,
  CircularProgress,
  Fab,
  AppBar,
  Toolbar,
  Container,
  Grid,
  Paper,
  Divider,
  Button
} from '@mui/material';
import {
  Search as SearchIcon,
  BookmarkBorder,
  Bookmark,
  MoreVert,
  Schedule,
  Refresh,
  Sort,
  Add,
  Clear
} from '@mui/icons-material';
import { formatDistanceToNow } from 'date-fns';
import InfiniteScroll from 'react-infinite-scroll-component';

const ArticleListScreen = () => {
  const [articles, setArticles] = useState([]);
  const [filteredArticles, setFilteredArticles] = useState([]);
  const [loading, setLoading] = useState(true);
  const [hasMore, setHasMore] = useState(true);
  const [page, setPage] = useState(1);
  const [searchText, setSearchText] = useState('');
  const [selectedCategory, setSelectedCategory] = useState('All');
  const [sortMenuAnchor, setSortMenuAnchor] = useState(null);

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
    const loadInitialArticles = async () => {
      setLoading(true);
      // Simulate API call
      await new Promise(resolve => setTimeout(resolve, 1000));

      const newArticles = generateArticles(1);
      setArticles(newArticles);
      setPage(2);
      setLoading(false);
    };

    loadInitialArticles();
  }, [generateArticles]);

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
    if (loading) return;

    setLoading(true);
    await new Promise(resolve => setTimeout(resolve, 500));

    const newArticles = generateArticles(page);
    setArticles(prev => [...prev, ...newArticles]);
    setPage(prev => prev + 1);

    if (page > 5) {
      setHasMore(false);
    }
    setLoading(false);
  };

  // Refresh articles
  const refreshArticles = async () => {
    setLoading(true);
    setPage(1);
    setHasMore(true);

    await new Promise(resolve => setTimeout(resolve, 1000));

    const newArticles = generateArticles(1);
    setArticles(newArticles);
    setPage(2);
    setLoading(false);
  };

  // Toggle bookmark
  const toggleBookmark = (articleId) => {
    setArticles(prev =>
      prev.map(article =>
        article.id === articleId
          ? { ...article, isBookmarked: !article.isBookmarked }
          : article
      )
    );
  };

  // Sort articles
  const sortArticles = (sortType) => {
    const sorted = [...articles];

    switch (sortType) {
      case 'date':
        sorted.sort((a, b) => new Date(b.publishDate) - new Date(a.publishDate));
        break;
      case 'readTime':
        sorted.sort((a, b) => a.readTime - b.readTime);
        break;
      case 'title':
        sorted.sort((a, b) => a.title.localeCompare(b.title));
        break;
      default:
        break;
    }

    setArticles(sorted);
    setSortMenuAnchor(null);
  };

  const ArticleCard = ({ article }) => (
    <Card
      sx={{
        mb: 3,
        cursor: 'pointer',
        '&:hover': {
          boxShadow: 6,
          transform: 'translateY(-2px)',
          transition: 'all 0.3s ease'
        }
      }}
      onClick={() => console.log('Navigate to article:', article.id)}
    >
      <CardMedia
        component="img"
        height="200"
        image={article.imageUrl}
        alt={article.title}
        sx={{ objectFit: 'cover' }}
      />
      <CardContent>
        {/* Tags */}
        <Box sx={{ mb: 2 }}>
          {article.tags.map((tag, index) => (
            <Chip
              key={index}
              label={tag}
              size="small"
              sx={{ mr: 1, mb: 1 }}
              color="primary"
              variant="outlined"
            />
          ))}
        </Box>

        {/* Title */}
        <Typography
          variant="h5"
          component="h2"
          gutterBottom
          sx={{
            fontWeight: 'bold',
            lineHeight: 1.3,
            overflow: 'hidden',
            textOverflow: 'ellipsis',
            display: '-webkit-box',
            WebkitLineClamp: 2,
            WebkitBoxOrient: 'vertical'
          }}
        >
          {article.title}
        </Typography>

        {/* Summary */}
        <Typography
          variant="body1"
          color="text.secondary"
          paragraph
          sx={{
            overflow: 'hidden',
            textOverflow: 'ellipsis',
            display: '-webkit-box',
            WebkitLineClamp: 3,
            WebkitBoxOrient: 'vertical'
          }}
        >
          {article.summary}
        </Typography>

        {/* Author and Metadata */}
        <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
          <Box sx={{ display: 'flex', alignItems: 'center' }}>
            <Avatar
              sx={{
                width: 32,
                height: 32,
                mr: 1,
                bgcolor: 'primary.main',
                fontSize: '0.9rem'
              }}
            >
              {article.author.charAt(0)}
            </Avatar>
            <Box>
              <Typography variant="body2" sx={{ fontWeight: 500 }}>
                {article.author}
              </Typography>
              <Box sx={{ display: 'flex', alignItems: 'center', gap: 2 }}>
                <Box sx={{ display: 'flex', alignItems: 'center', gap: 0.5 }}>
                  <Schedule fontSize="small" color="action" />
                  <Typography variant="caption" color="text.secondary">
                    {article.readTime} min read
                  </Typography>
                </Box>
                <Typography variant="caption" color="text.secondary">
                  {formatDistanceToNow(new Date(article.publishDate), { addSuffix: true })}
                </Typography>
              </Box>
            </Box>
          </Box>

          <IconButton
            onClick={(e) => {
              e.stopPropagation();
              toggleBookmark(article.id);
            }}
            color={article.isBookmarked ? 'primary' : 'default'}
          >
            {article.isBookmarked ? <Bookmark /> : <BookmarkBorder />}
          </IconButton>
        </Box>
      </CardContent>
    </Card>
  );

  const EmptyState = () => (
    <Paper
      sx={{
        p: 8,
        textAlign: 'center',
        bgcolor: 'background.paper',
        borderRadius: 2
      }}
    >
      <Typography variant="h5" gutterBottom color="text.secondary">
        No articles found
      </Typography>
      <Typography variant="body1" color="text.secondary" paragraph>
        Try adjusting your search or filters
      </Typography>
      <Button
        variant="outlined"
        onClick={() => {
          setSearchText('');
          setSelectedCategory('All');
        }}
        startIcon={<Clear />}
      >
        Clear Filters
      </Button>
    </Paper>
  );

  if (loading && articles.length === 0) {
    return (
      <Box sx={{
        display: 'flex',
        flexDirection: 'column',
        justifyContent: 'center',
        alignItems: 'center',
        minHeight: '100vh',
        gap: 2
      }}>
        <CircularProgress size={48} />
        <Typography variant="h6" color="text.secondary">
          Loading articles...
        </Typography>
      </Box>
    );
  }

  return (
    <Box sx={{ flexGrow: 1 }}>
      <AppBar position="static" elevation={0} sx={{ bgcolor: 'background.paper', color: 'text.primary' }}>
        <Toolbar>
          <Typography variant="h4" component="h1" sx={{ flexGrow: 1, fontWeight: 'bold' }}>
            Articles
          </Typography>

          <IconButton onClick={refreshArticles} disabled={loading}>
            <Refresh />
          </IconButton>

          <IconButton onClick={(e) => setSortMenuAnchor(e.currentTarget)}>
            <Sort />
          </IconButton>

          <IconButton onClick={() => console.log('Navigate to bookmarks')}>
            <BookmarkBorder />
          </IconButton>
        </Toolbar>
      </AppBar>

      <Container maxWidth="lg" sx={{ py: 3 }}>
        {/* Search Bar */}
        <Paper sx={{ p: 2, mb: 3 }}>
          <TextField
            fullWidth
            placeholder="Search articles..."
            value={searchText}
            onChange={(e) => setSearchText(e.target.value)}
            InputProps={{
              startAdornment: (
                <InputAdornment position="start">
                  <SearchIcon />
                </InputAdornment>
              ),
              endAdornment: searchText && (
                <InputAdornment position="end">
                  <IconButton onClick={() => setSearchText('')} size="small">
                    <Clear />
                  </IconButton>
                </InputAdornment>
              ),
            }}
            sx={{
              '& .MuiOutlinedInput-root': {
                borderRadius: 2
              }
            }}
          />
        </Paper>

        {/* Category Filters */}
        <Paper sx={{ p: 2, mb: 3 }}>
          <Box sx={{ display: 'flex', gap: 1, flexWrap: 'wrap' }}>
            {categories.map((category) => (
              <Chip
                key={category}
                label={category}
                onClick={() => setSelectedCategory(category)}
                color={selectedCategory === category ? 'primary' : 'default'}
                variant={selectedCategory === category ? 'filled' : 'outlined'}
                sx={{ mb: 1 }}
              />
            ))}
          </Box>
        </Paper>

        {/* Articles List */}
        {filteredArticles.length === 0 ? (
          <EmptyState />
        ) : (
          <InfiniteScroll
            dataLength={filteredArticles.length}
            next={loadMoreArticles}
            hasMore={hasMore}
            loader={
              <Box sx={{ textAlign: 'center', py: 3 }}>
                <CircularProgress />
                <Typography variant="body2" sx={{ mt: 1 }}>
                  Loading more articles...
                </Typography>
              </Box>
            }
            endMessage={
              <Box sx={{ textAlign: 'center', py: 3 }}>
                <Divider sx={{ mb: 2 }} />
                <Typography variant="body2" color="text.secondary">
                  You've reached the end of the articles
                </Typography>
              </Box>
            }
          >
            <Grid container spacing={3}>
              {filteredArticles.map((article) => (
                <Grid item xs={12} md={6} lg={4} key={article.id}>
                  <ArticleCard article={article} />
                </Grid>
              ))}
            </Grid>
          </InfiniteScroll>
        )}
      </Container>

      {/* Sort Menu */}
      <Menu
        anchorEl={sortMenuAnchor}
        open={Boolean(sortMenuAnchor)}
        onClose={() => setSortMenuAnchor(null)}
        transformOrigin={{ horizontal: 'right', vertical: 'top' }}
        anchorOrigin={{ horizontal: 'right', vertical: 'bottom' }}
      >
        <MenuItem onClick={() => sortArticles('date')}>
          Sort by Date
        </MenuItem>
        <MenuItem onClick={() => sortArticles('readTime')}>
          Sort by Read Time
        </MenuItem>
        <MenuItem onClick={() => sortArticles('title')}>
          Sort by Title
        </MenuItem>
      </Menu>

      {/* Floating Action Button */}
      <Fab
        color="primary"
        aria-label="add"
        sx={{
          position: 'fixed',
          bottom: 24,
          right: 24,
        }}
        onClick={() => console.log('Create new article')}
      >
        <Add />
      </Fab>
    </Box>
  );
};

export default ArticleListScreen;