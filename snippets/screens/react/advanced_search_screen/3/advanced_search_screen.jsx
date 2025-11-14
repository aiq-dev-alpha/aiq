import React, { useState } from 'react';
import {
  Box,
  TextField,
  FormControl,
  InputLabel,
  Select,
  MenuItem,
  FormControlLabel,
  Switch,
  Chip,
  Typography,
  Button,
  Paper,
  Grid,
  Slider,
  AppBar,
  Toolbar,
  IconButton,
  Card,
  CardContent,
  Stack,
  Autocomplete
} from '@mui/material';
import {
  ArrowBack as ArrowBackIcon,
  DateRange as DateRangeIcon
} from '@mui/icons-material';
import { DatePicker } from '@mui/x-date-pickers/DatePicker';
import { LocalizationProvider } from '@mui/x-date-pickers/LocalizationProvider';
import { AdapterDateFns } from '@mui/x-date-pickers/AdapterDateFns';

const fileTypes = [
  { value: 'any', label: 'Any' },
  { value: 'pdf', label: 'PDF' },
  { value: 'doc', label: 'Document' },
  { value: 'image', label: 'Image' },
  { value: 'video', label: 'Video' },
  { value: 'audio', label: 'Audio' }
];

const timeRanges = [
  { value: 'any', label: 'Any time' },
  { value: 'hour', label: 'Past hour' },
  { value: 'day', label: 'Past 24 hours' },
  { value: 'week', label: 'Past week' },
  { value: 'month', label: 'Past month' },
  { value: 'year', label: 'Past year' },
  { value: 'custom', label: 'Custom range' }
];

const sortOptions = [
  { value: 'relevance', label: 'Relevance' },
  { value: 'date', label: 'Date' },
  { value: 'popularity', label: 'Popularity' },
  { value: 'rating', label: 'Rating' }
];

const categories = [
  'Technology', 'Science', 'Business', 'Health',
  'Entertainment', 'Sports', 'Politics', 'Education'
];

const languages = [
  'English', 'Spanish', 'French', 'German',
  'Chinese', 'Japanese', 'Arabic', 'Portuguese'
];

const AdvancedSearchScreen = ({ onNavigateBack, onPerformSearch }) => {
  const [filters, setFilters] = useState({
    keywords: '',
    exactPhrase: '',
    excludeWords: '',
    author: '',
    domain: '',
    fileType: 'any',
    timeRange: 'any',
    sortBy: 'relevance',
    safeSearch: true,
    customFromDate: null,
    customToDate: null,
    sizeRange: [0, 100],
    selectedCategories: [],
    selectedLanguages: []
  });

  const handleInputChange = (field) => (event) => {
    setFilters(prev => ({
      ...prev,
      [field]: event.target.value
    }));
  };

  const handleSwitchChange = (field) => (event) => {
    setFilters(prev => ({
      ...prev,
      [field]: event.target.checked
    }));
  };

  const handleSliderChange = (field) => (event, newValue) => {
    setFilters(prev => ({
      ...prev,
      [field]: newValue
    }));
  };

  const handleDateChange = (field) => (newValue) => {
    setFilters(prev => ({
      ...prev,
      [field]: newValue
    }));
  };

  const handleMultiSelectChange = (field) => (event, newValue) => {
    setFilters(prev => ({
      ...prev,
      [field]: newValue
    }));
  };

  const handleReset = () => {
    setFilters({
      keywords: '',
      exactPhrase: '',
      excludeWords: '',
      author: '',
      domain: '',
      fileType: 'any',
      timeRange: 'any',
      sortBy: 'relevance',
      safeSearch: true,
      customFromDate: null,
      customToDate: null,
      sizeRange: [0, 100],
      selectedCategories: [],
      selectedLanguages: []
    });
  };

  const handleSearch = () => {
    onPerformSearch?.(filters);
  };

  return (
    <LocalizationProvider dateAdapter={AdapterDateFns}>
      <Box sx={{ height: '100vh', display: 'flex', flexDirection: 'column' }}>
        {/* App Bar */}
        <AppBar position="static" elevation={0} color="default">
          <Toolbar>
            <IconButton edge="start" onClick={onNavigateBack}>
              <ArrowBackIcon />
            </IconButton>
            <Typography variant="h6" component="div" sx={{ flexGrow: 1 }}>
              Advanced Search
            </Typography>
            <Button onClick={handleReset} color="primary">
              Reset
            </Button>
          </Toolbar>
        </AppBar>

        {/* Content */}
        <Box sx={{ flex: 1, overflow: 'auto', p: 2 }}>
          <Stack spacing={3}>
            {/* Keywords Section */}
            <Card>
              <CardContent>
                <Typography variant="h6" gutterBottom color="primary">
                  Keywords
                </Typography>
                <Stack spacing={2}>
                  <TextField
                    fullWidth
                    label="All of these words"
                    placeholder="Enter keywords separated by spaces"
                    value={filters.keywords}
                    onChange={handleInputChange('keywords')}
                    variant="outlined"
                  />
                  <TextField
                    fullWidth
                    label="This exact phrase"
                    placeholder="Enter exact phrase"
                    value={filters.exactPhrase}
                    onChange={handleInputChange('exactPhrase')}
                    variant="outlined"
                  />
                  <TextField
                    fullWidth
                    label="None of these words"
                    placeholder="Words to exclude"
                    value={filters.excludeWords}
                    onChange={handleInputChange('excludeWords')}
                    variant="outlined"
                  />
                </Stack>
              </CardContent>
            </Card>

            {/* Content Filters Section */}
            <Card>
              <CardContent>
                <Typography variant="h6" gutterBottom color="primary">
                  Content Filters
                </Typography>
                <Grid container spacing={2}>
                  <Grid item xs={12} sm={6}>
                    <FormControl fullWidth>
                      <InputLabel>File Type</InputLabel>
                      <Select
                        value={filters.fileType}
                        onChange={handleInputChange('fileType')}
                        label="File Type"
                      >
                        {fileTypes.map(type => (
                          <MenuItem key={type.value} value={type.value}>
                            {type.label}
                          </MenuItem>
                        ))}
                      </Select>
                    </FormControl>
                  </Grid>
                  <Grid item xs={12} sm={6}>
                    <TextField
                      fullWidth
                      label="Author"
                      placeholder="Content author"
                      value={filters.author}
                      onChange={handleInputChange('author')}
                      variant="outlined"
                    />
                  </Grid>
                  <Grid item xs={12}>
                    <TextField
                      fullWidth
                      label="Site or Domain"
                      placeholder="e.g., example.com"
                      value={filters.domain}
                      onChange={handleInputChange('domain')}
                      variant="outlined"
                    />
                  </Grid>
                </Grid>
              </CardContent>
            </Card>

            {/* Categories Section */}
            <Card>
              <CardContent>
                <Typography variant="h6" gutterBottom color="primary">
                  Categories
                </Typography>
                <Autocomplete
                  multiple
                  options={categories}
                  value={filters.selectedCategories}
                  onChange={handleMultiSelectChange('selectedCategories')}
                  renderTags={(value, getTagProps) =>
                    value.map((option, index) => (
                      <Chip variant="outlined" label={option} {...getTagProps({ index })} />
                    ))
                  }
                  renderInput={(params) => (
                    <TextField
                      {...params}
                      variant="outlined"
                      placeholder="Select categories"
                    />
                  )}
                />
              </CardContent>
            </Card>

            {/* Time Range Section */}
            <Card>
              <CardContent>
                <Typography variant="h6" gutterBottom color="primary">
                  Time Range
                </Typography>
                <Stack spacing={2}>
                  <FormControl fullWidth>
                    <InputLabel>Time Range</InputLabel>
                    <Select
                      value={filters.timeRange}
                      onChange={handleInputChange('timeRange')}
                      label="Time Range"
                    >
                      {timeRanges.map(range => (
                        <MenuItem key={range.value} value={range.value}>
                          {range.label}
                        </MenuItem>
                      ))}
                    </Select>
                  </FormControl>

                  {filters.timeRange === 'custom' && (
                    <Grid container spacing={2}>
                      <Grid item xs={12} sm={6}>
                        <DatePicker
                          label="From Date"
                          value={filters.customFromDate}
                          onChange={handleDateChange('customFromDate')}
                          renderInput={(params) => <TextField {...params} fullWidth />}
                        />
                      </Grid>
                      <Grid item xs={12} sm={6}>
                        <DatePicker
                          label="To Date"
                          value={filters.customToDate}
                          onChange={handleDateChange('customToDate')}
                          renderInput={(params) => <TextField {...params} fullWidth />}
                        />
                      </Grid>
                    </Grid>
                  )}
                </Stack>
              </CardContent>
            </Card>

            {/* File Size Section */}
            <Card>
              <CardContent>
                <Typography variant="h6" gutterBottom color="primary">
                  File Size (MB)
                </Typography>
                <Typography variant="body2" color="text.secondary" gutterBottom>
                  {filters.sizeRange[0]} MB - {filters.sizeRange[1]} MB
                </Typography>
                <Slider
                  value={filters.sizeRange}
                  onChange={handleSliderChange('sizeRange')}
                  valueLabelDisplay="auto"
                  min={0}
                  max={100}
                  step={5}
                />
              </CardContent>
            </Card>

            {/* Languages Section */}
            <Card>
              <CardContent>
                <Typography variant="h6" gutterBottom color="primary">
                  Languages
                </Typography>
                <Autocomplete
                  multiple
                  options={languages}
                  value={filters.selectedLanguages}
                  onChange={handleMultiSelectChange('selectedLanguages')}
                  renderTags={(value, getTagProps) =>
                    value.map((option, index) => (
                      <Chip variant="outlined" label={option} {...getTagProps({ index })} />
                    ))
                  }
                  renderInput={(params) => (
                    <TextField
                      {...params}
                      variant="outlined"
                      placeholder="Select languages"
                    />
                  )}
                />
              </CardContent>
            </Card>

            {/* Options Section */}
            <Card>
              <CardContent>
                <Typography variant="h6" gutterBottom color="primary">
                  Options
                </Typography>
                <Stack spacing={2}>
                  <FormControl fullWidth>
                    <InputLabel>Sort by</InputLabel>
                    <Select
                      value={filters.sortBy}
                      onChange={handleInputChange('sortBy')}
                      label="Sort by"
                    >
                      {sortOptions.map(option => (
                        <MenuItem key={option.value} value={option.value}>
                          {option.label}
                        </MenuItem>
                      ))}
                    </Select>
                  </FormControl>

                  <FormControlLabel
                    control={
                      <Switch
                        checked={filters.safeSearch}
                        onChange={handleSwitchChange('safeSearch')}
                      />
                    }
                    label="Safe Search - Filter explicit content"
                  />
                </Stack>
              </CardContent>
            </Card>
          </Stack>
        </Box>

        {/* Bottom Action Button */}
        <Paper elevation={3} sx={{ p: 2 }}>
          <Button
            fullWidth
            variant="contained"
            size="large"
            onClick={handleSearch}
            sx={{ py: 1.5 }}
          >
            Search
          </Button>
        </Paper>
      </Box>
    </LocalizationProvider>
  );
};

export default AdvancedSearchScreen;