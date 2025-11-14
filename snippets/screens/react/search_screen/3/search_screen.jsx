import React, { useState, useEffect, useRef } from 'react';
import {
  Box,
  TextField,
  InputAdornment,
  IconButton,
  Chip,
  Typography,
  List,
  ListItem,
  ListItemIcon,
  ListItemText,
  ListItemButton,
  Paper,
  Button,
  CircularProgress,
  Stack,
  Divider,
  AppBar,
  Toolbar
} from '@mui/material';
import {
  Search as SearchIcon,
  Clear as ClearIcon,
  History as HistoryIcon,
  TrendingUp as TrendingUpIcon,
  Tune as TuneIcon,
  Image as ImageIcon,
  VideoLibrary as VideoIcon,
  Description as DocumentIcon,
  AudioFile as AudioIcon,
  NorthWest as FillIcon
} from '@mui/icons-material';

const quickFilters = [
  { label: 'All', value: 'all', icon: SearchIcon },
  { label: 'Images', value: 'images', icon: ImageIcon },
  { label: 'Videos', value: 'videos', icon: VideoIcon },
  { label: 'Documents', value: 'documents', icon: DocumentIcon },
  { label: 'Audio', value: 'audio', icon: AudioIcon }
];

const SearchScreen = ({
  onNavigateToAdvanced,
  onNavigateToResults,
  onNavigateBack
}) => {
  const [searchText, setSearchText] = useState('');
  const [recentSearches, setRecentSearches] = useState([]);
  const [suggestions, setSuggestions] = useState([]);
  const [isLoading, setIsLoading] = useState(false);
  const [selectedFilters, setSelectedFilters] = useState(new Set(['all']));

  const searchInputRef = useRef(null);
  const suggestionsTimeoutRef = useRef(null);

  useEffect(() => {
    // Load recent searches from localStorage
    const saved = localStorage.getItem('recentSearches');
    if (saved) {
      try {
        setRecentSearches(JSON.parse(saved));
      } catch (e) {
        console.error('Failed to parse recent searches:', e);
      }
    } else {
      // Set mock data
      setRecentSearches([
        'React components',
        'JavaScript tutorials',
        'Web development',
        'Material UI examples'
      ]);
    }

    // Auto-focus search input
    if (searchInputRef.current) {
      searchInputRef.current.focus();
    }
  }, []);

  useEffect(() => {
    // Clear previous timeout
    if (suggestionsTimeoutRef.current) {
      clearTimeout(suggestionsTimeoutRef.current);
    }

    if (searchText.trim() === '') {
      setSuggestions([]);
      setIsLoading(false);
      return;
    }

    setIsLoading(true);

    // Simulate API call with debouncing
    suggestionsTimeoutRef.current = setTimeout(() => {
      const mockSuggestions = [
        `${searchText} tutorial`,
        `${searchText} examples`,
        `${searchText} best practices`,
        `${searchText} documentation`
      ];
      setSuggestions(mockSuggestions);
      setIsLoading(false);
    }, 300);

    return () => {
      if (suggestionsTimeoutRef.current) {
        clearTimeout(suggestionsTimeoutRef.current);
      }
    };
  }, [searchText]);

  const performSearch = (query) => {
    const trimmedQuery = query.trim();
    if (!trimmedQuery) return;

    // Add to recent searches
    const updatedRecent = [trimmedQuery, ...recentSearches.filter(s => s !== trimmedQuery)].slice(0, 10);
    setRecentSearches(updatedRecent);

    // Save to localStorage
    try {
      localStorage.setItem('recentSearches', JSON.stringify(updatedRecent));
    } catch (e) {
      console.error('Failed to save recent searches:', e);
    }

    onNavigateToResults?.(trimmedQuery);
  };

  const handleSearchSubmit = (e) => {
    e.preventDefault();
    performSearch(searchText);
  };

  const handleClearSearch = () => {
    setSearchText('');
    setSuggestions([]);
    if (searchInputRef.current) {
      searchInputRef.current.focus();
    }
  };

  const handleFilterToggle = (filterValue) => {
    const newFilters = new Set(selectedFilters);
    if (filterValue === 'all') {
      newFilters.clear();
      newFilters.add('all');
    } else {
      newFilters.delete('all');
      if (newFilters.has(filterValue)) {
        newFilters.delete(filterValue);
      } else {
        newFilters.add(filterValue);
      }
      if (newFilters.size === 0) {
        newFilters.add('all');
      }
    }
    setSelectedFilters(newFilters);
  };

  const handleClearAllRecent = () => {
    setRecentSearches([]);
    try {
      localStorage.removeItem('recentSearches');
    } catch (e) {
      console.error('Failed to clear recent searches:', e);
    }
  };

  const handleFillSearch = (text) => {
    setSearchText(text);
    if (searchInputRef.current) {
      searchInputRef.current.focus();
    }
  };

  return (
    <Box sx={{ height: '100vh', display: 'flex', flexDirection: 'column' }}>
      {/* App Bar */}
      <AppBar position="static" elevation={0} color="default">
        <Toolbar>
          <Typography variant="h6" component="div" sx={{ flexGrow: 1 }}>
            Search
          </Typography>
          <IconButton onClick={onNavigateToAdvanced} color="primary">
            <TuneIcon />
          </IconButton>
        </Toolbar>
      </AppBar>

      <Box sx={{ flex: 1, p: 2, overflow: 'hidden', display: 'flex', flexDirection: 'column' }}>
        {/* Search Bar */}
        <Paper elevation={1} sx={{ mb: 2 }}>
          <Box component="form" onSubmit={handleSearchSubmit} sx={{ p: 1 }}>
            <TextField
              ref={searchInputRef}
              fullWidth
              placeholder="Search for anything..."
              value={searchText}
              onChange={(e) => setSearchText(e.target.value)}
              InputProps={{
                startAdornment: (
                  <InputAdornment position="start">
                    <SearchIcon color="action" />
                  </InputAdornment>
                ),
                endAdornment: searchText && (
                  <InputAdornment position="end">
                    <IconButton onClick={handleClearSearch} edge="end">
                      <ClearIcon />
                    </IconButton>
                  </InputAdornment>
                )
              }}
              variant="outlined"
              size="medium"
            />
          </Box>
        </Paper>

        {/* Quick Filters */}
        <Stack direction="row" spacing={1} sx={{ mb: 3, overflow: 'auto' }}>
          {quickFilters.map((filter) => (
            <Chip
              key={filter.value}
              label={filter.label}
              icon={<filter.icon />}
              onClick={() => handleFilterToggle(filter.value)}
              variant={selectedFilters.has(filter.value) ? 'filled' : 'outlined'}
              color={selectedFilters.has(filter.value) ? 'primary' : 'default'}
            />
          ))}
        </Stack>

        {/* Content Area */}
        <Box sx={{ flex: 1, overflow: 'hidden' }}>
          {searchText.trim() === '' ? (
            <RecentSearchesContent
              recentSearches={recentSearches}
              onSearchClick={performSearch}
              onFillSearch={handleFillSearch}
              onClearAll={handleClearAllRecent}
            />
          ) : (
            <SuggestionsContent
              suggestions={suggestions}
              isLoading={isLoading}
              onSuggestionClick={performSearch}
              onFillSuggestion={handleFillSearch}
            />
          )}
        </Box>
      </Box>
    </Box>
  );
};

const RecentSearchesContent = ({ recentSearches, onSearchClick, onFillSearch, onClearAll }) => {
  if (recentSearches.length === 0) {
    return (
      <Box
        sx={{
          display: 'flex',
          flexDirection: 'column',
          alignItems: 'center',
          justifyContent: 'center',
          height: '100%',
          textAlign: 'center'
        }}
      >
        <SearchIcon sx={{ fontSize: 64, color: 'text.disabled', mb: 2 }} />
        <Typography variant="h6" color="text.secondary">
          Start typing to search
        </Typography>
      </Box>
    );
  }

  return (
    <Box>
      <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 2 }}>
        <Typography variant="h6">Recent Searches</Typography>
        <Button onClick={onClearAll} size="small" color="primary">
          Clear All
        </Button>
      </Box>

      <Paper elevation={0}>
        <List>
          {recentSearches.map((search, index) => (
            <React.Fragment key={search}>
              <ListItemButton onClick={() => onSearchClick(search)}>
                <ListItemIcon>
                  <HistoryIcon color="action" />
                </ListItemIcon>
                <ListItemText primary={search} />
                <IconButton
                  edge="end"
                  onClick={(e) => {
                    e.stopPropagation();
                    onFillSearch(search);
                  }}
                >
                  <FillIcon />
                </IconButton>
              </ListItemButton>
              {index < recentSearches.length - 1 && <Divider />}
            </React.Fragment>
          ))}
        </List>
      </Paper>
    </Box>
  );
};

const SuggestionsContent = ({ suggestions, isLoading, onSuggestionClick, onFillSuggestion }) => {
  if (isLoading) {
    return (
      <Box sx={{ display: 'flex', justifyContent: 'center', py: 4 }}>
        <CircularProgress />
      </Box>
    );
  }

  return (
    <Paper elevation={0}>
      <List>
        {suggestions.map((suggestion, index) => (
          <React.Fragment key={suggestion}>
            <ListItemButton onClick={() => onSuggestionClick(suggestion)}>
              <ListItemIcon>
                <SearchIcon color="action" />
              </ListItemIcon>
              <ListItemText primary={suggestion} />
              <IconButton
                edge="end"
                onClick={(e) => {
                  e.stopPropagation();
                  onFillSuggestion(suggestion);
                }}
              >
                <FillIcon />
              </IconButton>
            </ListItemButton>
            {index < suggestions.length - 1 && <Divider />}
          </React.Fragment>
        ))}
      </List>
    </Paper>
  );
};

export default SearchScreen;