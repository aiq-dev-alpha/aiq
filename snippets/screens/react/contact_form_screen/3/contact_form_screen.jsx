import React, { useState } from 'react';
import {
  Box,
  Card,
  CardContent,
  TextField,
  Button,
  Typography,
  FormControl,
  InputLabel,
  Select,
  MenuItem,
  Grid,
  Alert,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  CircularProgress,
  IconButton,
  InputAdornment,
  Chip,
  Stack
} from '@mui/material';
import {
  Person,
  Email,
  Phone,
  Subject,
  Message,
  Send,
  Clear,
  Close,
  PriorityHigh
} from '@mui/icons-material';

const ContactFormScreen = ({ open, onClose }) => {
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    phone: '',
    subject: '',
    message: '',
    priority: 'medium'
  });

  const [errors, setErrors] = useState({});
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [showSuccess, setShowSuccess] = useState(false);

  const priorities = [
    { value: 'low', label: 'Low', color: '#4caf50' },
    { value: 'medium', label: 'Medium', color: '#ff9800' },
    { value: 'high', label: 'High', color: '#f44336' },
    { value: 'urgent', label: 'Urgent', color: '#9c27b0' }
  ];

  const validateEmail = (email) => {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
  };

  const validatePhone = (phone) => {
    if (!phone) return true; // Optional field
    const phoneRegex = /^[\+]?[\d\s\-\(\)]+$/;
    return phoneRegex.test(phone);
  };

  const validateForm = () => {
    const newErrors = {};

    if (!formData.name.trim()) {
      newErrors.name = 'Name is required';
    }

    if (!formData.email.trim()) {
      newErrors.email = 'Email is required';
    } else if (!validateEmail(formData.email)) {
      newErrors.email = 'Please enter a valid email';
    }

    if (formData.phone && !validatePhone(formData.phone)) {
      newErrors.phone = 'Please enter a valid phone number';
    }

    if (!formData.subject.trim()) {
      newErrors.subject = 'Subject is required';
    }

    if (!formData.message.trim()) {
      newErrors.message = 'Message is required';
    }

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleInputChange = (field) => (event) => {
    setFormData(prev => ({
      ...prev,
      [field]: event.target.value
    }));

    // Clear error when user starts typing
    if (errors[field]) {
      setErrors(prev => ({
        ...prev,
        [field]: undefined
      }));
    }
  };

  const handleSubmit = async (event) => {
    event.preventDefault();

    if (!validateForm()) return;

    setIsSubmitting(true);

    try {
      // Simulate API call
      await new Promise(resolve => setTimeout(resolve, 2000));

      setShowSuccess(true);
      clearForm();
    } catch (error) {
      console.error('Submission error:', error);
    } finally {
      setIsSubmitting(false);
    }
  };

  const clearForm = () => {
    setFormData({
      name: '',
      email: '',
      phone: '',
      subject: '',
      message: '',
      priority: 'medium'
    });
    setErrors({});
  };

  const getPriorityColor = (priority) => {
    const priorityObj = priorities.find(p => p.value === priority);
    return priorityObj ? priorityObj.color : '#757575';
  };

  return (
    <>
      <Dialog
        open={open}
        onClose={onClose}
        maxWidth="md"
        fullWidth
        scroll="body"
      >
        <DialogTitle>
          <Box display="flex" alignItems="center" justifyContent="space-between">
            <Typography variant="h5" component="div">
              Contact Us
            </Typography>
            <IconButton onClick={onClose} size="small">
              <Close />
            </IconButton>
          </Box>
        </DialogTitle>

        <DialogContent dividers>
          <Box component="form" onSubmit={handleSubmit}>
            <Stack spacing={3}>
              {/* Contact Information Card */}
              <Card variant="outlined">
                <CardContent>
                  <Typography variant="h6" gutterBottom color="primary">
                    Contact Information
                  </Typography>

                  <Grid container spacing={2}>
                    <Grid item xs={12}>
                      <TextField
                        fullWidth
                        label="Full Name"
                        value={formData.name}
                        onChange={handleInputChange('name')}
                        error={!!errors.name}
                        helperText={errors.name}
                        InputProps={{
                          startAdornment: (
                            <InputAdornment position="start">
                              <Person color="action" />
                            </InputAdornment>
                          )
                        }}
                        required
                      />
                    </Grid>

                    <Grid item xs={12} sm={6}>
                      <TextField
                        fullWidth
                        label="Email Address"
                        type="email"
                        value={formData.email}
                        onChange={handleInputChange('email')}
                        error={!!errors.email}
                        helperText={errors.email}
                        InputProps={{
                          startAdornment: (
                            <InputAdornment position="start">
                              <Email color="action" />
                            </InputAdornment>
                          )
                        }}
                        required
                      />
                    </Grid>

                    <Grid item xs={12} sm={6}>
                      <TextField
                        fullWidth
                        label="Phone Number (Optional)"
                        value={formData.phone}
                        onChange={handleInputChange('phone')}
                        error={!!errors.phone}
                        helperText={errors.phone}
                        InputProps={{
                          startAdornment: (
                            <InputAdornment position="start">
                              <Phone color="action" />
                            </InputAdornment>
                          )
                        }}
                      />
                    </Grid>
                  </Grid>
                </CardContent>
              </Card>

              {/* Message Details Card */}
              <Card variant="outlined">
                <CardContent>
                  <Typography variant="h6" gutterBottom color="primary">
                    Message Details
                  </Typography>

                  <Grid container spacing={2}>
                    <Grid item xs={12} sm={6}>
                      <FormControl fullWidth>
                        <InputLabel>Priority</InputLabel>
                        <Select
                          value={formData.priority}
                          label="Priority"
                          onChange={handleInputChange('priority')}
                          startAdornment={
                            <InputAdornment position="start">
                              <PriorityHigh color="action" />
                            </InputAdornment>
                          }
                        >
                          {priorities.map((priority) => (
                            <MenuItem key={priority.value} value={priority.value}>
                              <Box display="flex" alignItems="center" gap={1}>
                                <Chip
                                  size="small"
                                  label={priority.label}
                                  style={{
                                    backgroundColor: priority.color,
                                    color: 'white'
                                  }}
                                />
                              </Box>
                            </MenuItem>
                          ))}
                        </Select>
                      </FormControl>
                    </Grid>

                    <Grid item xs={12} sm={6}>
                      <TextField
                        fullWidth
                        label="Subject"
                        value={formData.subject}
                        onChange={handleInputChange('subject')}
                        error={!!errors.subject}
                        helperText={errors.subject}
                        InputProps={{
                          startAdornment: (
                            <InputAdornment position="start">
                              <Subject color="action" />
                            </InputAdornment>
                          )
                        }}
                        required
                      />
                    </Grid>

                    <Grid item xs={12}>
                      <TextField
                        fullWidth
                        label="Message"
                        multiline
                        rows={5}
                        value={formData.message}
                        onChange={handleInputChange('message')}
                        error={!!errors.message}
                        helperText={errors.message || `${formData.message.length}/1000 characters`}
                        inputProps={{ maxLength: 1000 }}
                        InputProps={{
                          startAdornment: (
                            <InputAdornment position="start">
                              <Message color="action" />
                            </InputAdornment>
                          )
                        }}
                        required
                      />
                    </Grid>
                  </Grid>
                </CardContent>
              </Card>

              {/* Current Priority Display */}
              <Box>
                <Typography variant="body2" color="textSecondary" gutterBottom>
                  Selected Priority:
                </Typography>
                <Chip
                  label={priorities.find(p => p.value === formData.priority)?.label}
                  style={{
                    backgroundColor: getPriorityColor(formData.priority),
                    color: 'white'
                  }}
                  icon={<PriorityHigh />}
                />
              </Box>
            </Stack>
          </Box>
        </DialogContent>

        <DialogActions sx={{ p: 2, gap: 1 }}>
          <Button
            variant="outlined"
            onClick={clearForm}
            startIcon={<Clear />}
            disabled={isSubmitting}
          >
            Clear Form
          </Button>

          <Button
            variant="contained"
            onClick={handleSubmit}
            startIcon={isSubmitting ? <CircularProgress size={20} /> : <Send />}
            disabled={isSubmitting}
            sx={{ minWidth: 140 }}
          >
            {isSubmitting ? 'Sending...' : 'Send Message'}
          </Button>
        </DialogActions>
      </Dialog>

      {/* Success Dialog */}
      <Dialog open={showSuccess} onClose={() => setShowSuccess(false)}>
        <DialogTitle>Message Sent Successfully!</DialogTitle>
        <DialogContent>
          <Alert severity="success">
            Thank you for contacting us! We'll get back to you soon.
          </Alert>
        </DialogContent>
        <DialogActions>
          <Button
            onClick={() => {
              setShowSuccess(false);
              onClose();
            }}
            autoFocus
          >
            Close
          </Button>
        </DialogActions>
      </Dialog>
    </>
  );
};

export default ContactFormScreen;