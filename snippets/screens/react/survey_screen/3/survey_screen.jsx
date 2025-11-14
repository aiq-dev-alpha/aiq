import React, { useState } from 'react';
import {
  Box,
  Card,
  CardContent,
  Button,
  Typography,
  LinearProgress,
  Radio,
  RadioGroup,
  FormControlLabel,
  FormControl,
  FormLabel,
  Checkbox,
  FormGroup,
  Slider,
  TextField,
  Stepper,
  Step,
  StepLabel,
  Chip,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  Grid,
  Stack
} from '@mui/material';
import { NavigateNext, NavigateBefore, CheckCircle } from '@mui/icons-material';

const SurveyScreen = ({ open, onClose }) => {
  const [currentQuestion, setCurrentQuestion] = useState(0);
  const [responses, setResponses] = useState({});
  const [isCompleted, setIsCompleted] = useState(false);

  const questions = [
    {
      id: 'demographics',
      title: 'Tell us about yourself',
      type: 'single',
      question: 'What is your age group?',
      required: true,
      options: ['18-24', '25-34', '35-44', '45-54', '55-64', '65+'],
      category: 'Demographics'
    },
    {
      id: 'usage_frequency',
      title: 'Usage Patterns',
      type: 'single',
      question: 'How often do you use our app?',
      required: true,
      options: ['Daily', 'Weekly', 'Monthly', 'Rarely', 'First time'],
      category: 'Usage'
    },
    {
      id: 'satisfaction_rating',
      title: 'Satisfaction Rating',
      type: 'scale',
      question: 'How satisfied are you with our service?',
      required: true,
      scaleMin: 1,
      scaleMax: 10,
      category: 'Feedback'
    },
    {
      id: 'features_used',
      title: 'Feature Usage',
      type: 'multiple',
      question: 'Which features do you use most? (Select all that apply)',
      required: false,
      options: ['Dashboard', 'Reports', 'Settings', 'Search', 'Notifications', 'Export Data'],
      category: 'Features'
    },
    {
      id: 'improvement_suggestions',
      title: 'Your Feedback',
      type: 'text',
      question: 'What improvements would you like to see?',
      required: false,
      placeholder: 'Share your thoughts and suggestions...',
      category: 'Feedback'
    },
    {
      id: 'recommendation',
      title: 'Final Question',
      type: 'yesno',
      question: 'Would you recommend our app to others?',
      required: true,
      category: 'Recommendation'
    }
  ];

  const getCategoryColor = (category) => {
    const colors = {
      'Demographics': '#2196f3',
      'Usage': '#4caf50',
      'Feedback': '#ff9800',
      'Features': '#9c27b0',
      'Recommendation': '#f44336'
    };
    return colors[category] || '#757575';
  };

  const handleResponseChange = (questionId, value) => {
    setResponses(prev => ({
      ...prev,
      [questionId]: value
    }));
  };

  const isCurrentQuestionAnswered = () => {
    const question = questions[currentQuestion];
    const response = responses[question.id];

    if (!question.required) return true;

    switch (question.type) {
      case 'single':
      case 'yesno':
        return response !== undefined;
      case 'multiple':
        return Array.isArray(response) && response.length > 0;
      case 'scale':
        return response !== undefined;
      case 'text':
        return response && response.trim().length > 0;
      default:
        return false;
    }
  };

  const nextQuestion = () => {
    if (currentQuestion < questions.length - 1) {
      setCurrentQuestion(prev => prev + 1);
    }
  };

  const previousQuestion = () => {
    if (currentQuestion > 0) {
      setCurrentQuestion(prev => prev - 1);
    }
  };

  const completeSurvey = () => {
    setIsCompleted(true);
  };

  const renderQuestionContent = (question) => {
    const response = responses[question.id];

    switch (question.type) {
      case 'single':
        return (
          <FormControl component="fieldset">
            <RadioGroup
              value={response || ''}
              onChange={(e) => handleResponseChange(question.id, e.target.value)}
            >
              {question.options.map((option, index) => (
                <FormControlLabel
                  key={index}
                  value={option}
                  control={<Radio />}
                  label={option}
                />
              ))}
            </RadioGroup>
          </FormControl>
        );

      case 'multiple':
        return (
          <FormGroup>
            {question.options.map((option, index) => (
              <FormControlLabel
                key={index}
                control={
                  <Checkbox
                    checked={Array.isArray(response) && response.includes(option)}
                    onChange={(e) => {
                      const currentResponses = Array.isArray(response) ? response : [];
                      if (e.target.checked) {
                        handleResponseChange(question.id, [...currentResponses, option]);
                      } else {
                        handleResponseChange(question.id, currentResponses.filter(r => r !== option));
                      }
                    }}
                  />
                }
                label={option}
              />
            ))}
          </FormGroup>
        );

      case 'scale':
        return (
          <Box sx={{ px: 2 }}>
            <Typography gutterBottom>
              Rating: {response || question.scaleMin}/{question.scaleMax}
            </Typography>
            <Slider
              value={response || question.scaleMin}
              onChange={(_, newValue) => handleResponseChange(question.id, newValue)}
              min={question.scaleMin}
              max={question.scaleMax}
              step={1}
              marks
              valueLabelDisplay="auto"
            />
            <Box display="flex" justifyContent="space-between" mt={1}>
              <Typography variant="caption">{question.scaleMin}</Typography>
              <Typography variant="caption">{question.scaleMax}</Typography>
            </Box>
          </Box>
        );

      case 'text':
        return (
          <TextField
            multiline
            rows={4}
            fullWidth
            placeholder={question.placeholder}
            value={response || ''}
            onChange={(e) => handleResponseChange(question.id, e.target.value)}
            inputProps={{ maxLength: 500 }}
            helperText={`${(response || '').length}/500 characters`}
          />
        );

      case 'yesno':
        return (
          <FormControl component="fieldset">
            <RadioGroup
              value={response !== undefined ? (response ? 'yes' : 'no') : ''}
              onChange={(e) => handleResponseChange(question.id, e.target.value === 'yes')}
              row
            >
              <FormControlLabel value="yes" control={<Radio />} label="Yes" />
              <FormControlLabel value="no" control={<Radio />} label="No" />
            </RadioGroup>
          </FormControl>
        );

      default:
        return null;
    }
  };

  if (isCompleted) {
    return (
      <Dialog open={open} onClose={onClose} maxWidth="sm" fullWidth>
        <DialogContent sx={{ textAlign: 'center', py: 4 }}>
          <CheckCircle sx={{ fontSize: 80, color: 'success.main', mb: 2 }} />
          <Typography variant="h4" gutterBottom>
            Thank You!
          </Typography>
          <Typography variant="body1" color="textSecondary" paragraph>
            Your survey responses have been submitted successfully. We appreciate your time and valuable feedback.
          </Typography>

          <Card variant="outlined" sx={{ mt: 3, p: 2 }}>
            <Typography variant="h6" gutterBottom>
              Survey Summary
            </Typography>
            <Grid container spacing={2}>
              <Grid item xs={6}>
                <Typography variant="body2" color="textSecondary">
                  Questions answered:
                </Typography>
                <Typography variant="h6">
                  {Object.keys(responses).length} of {questions.length}
                </Typography>
              </Grid>
              <Grid item xs={6}>
                <Typography variant="body2" color="textSecondary">
                  Completion rate:
                </Typography>
                <Typography variant="h6" color="success.main">
                  {Math.round((Object.keys(responses).length / questions.length) * 100)}%
                </Typography>
              </Grid>
            </Grid>
          </Card>
        </DialogContent>
        <DialogActions>
          <Button onClick={onClose} variant="contained" fullWidth>
            Close
          </Button>
        </DialogActions>
      </Dialog>
    );
  }

  const currentQ = questions[currentQuestion];
  const progress = ((currentQuestion + 1) / questions.length) * 100;

  return (
    <Dialog open={open} onClose={onClose} maxWidth="md" fullWidth>
      <Box sx={{ p: 3 }}>
        <Box display="flex" alignItems="center" justifyContent="space-between" mb={2}>
          <Typography variant="h5">Survey</Typography>
          <Chip
            label={currentQ.category}
            sx={{
              backgroundColor: getCategoryColor(currentQ.category),
              color: 'white'
            }}
          />
        </Box>

        <LinearProgress variant="determinate" value={progress} sx={{ mb: 3 }} />

        <Typography variant="body2" color="textSecondary" gutterBottom>
          Question {currentQuestion + 1} of {questions.length}
        </Typography>

        <Card sx={{ mb: 3 }}>
          <CardContent>
            <Typography variant="h6" gutterBottom>
              {currentQ.title}
            </Typography>
            <Typography variant="body1" paragraph>
              {currentQ.question}
              {currentQ.required && (
                <Typography component="span" color="error" sx={{ ml: 1 }}>
                  *
                </Typography>
              )}
            </Typography>

            {renderQuestionContent(currentQ)}
          </CardContent>
        </Card>

        <Stack direction="row" spacing={2} justifyContent="space-between">
          <Button
            variant="outlined"
            onClick={previousQuestion}
            disabled={currentQuestion === 0}
            startIcon={<NavigateBefore />}
          >
            Previous
          </Button>

          <Button
            variant="contained"
            onClick={currentQuestion === questions.length - 1 ? completeSurvey : nextQuestion}
            disabled={!isCurrentQuestionAnswered()}
            endIcon={currentQuestion === questions.length - 1 ? <CheckCircle /> : <NavigateNext />}
          >
            {currentQuestion === questions.length - 1 ? 'Submit Survey' : 'Next'}
          </Button>
        </Stack>
      </Box>
    </Dialog>
  );
};

export default SurveyScreen;