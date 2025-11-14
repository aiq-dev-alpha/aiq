import React, { useState, useEffect } from 'react';
import { Menu, Play, TrendingUp, User, X } from 'lucide-react';

const TutorialScreen = ({ onComplete }) => {
  const [currentStep, setCurrentStep] = useState(0);
  const [showOverlay, setShowOverlay] = useState(true);
  const [pulseScale, setPulseScale] = useState(1);

  const tutorialSteps = [
    {
      title: "Navigation Menu",
      description: "Tap the menu icon to access different sections of the app.",
      target: "menu"
    },
    {
      title: "Start a Quiz",
      description: "Tap here to begin your AI intelligence assessment.",
      target: "quiz"
    },
    {
      title: "View Your Progress",
      description: "Check your scores and track improvement over time.",
      target: "progress"
    },
    {
      title: "Settings & Profile",
      description: "Customize your experience and manage your profile.",
      target: "profile"
    }
  ];

  useEffect(() => {
    const pulse = setInterval(() => {
      setPulseScale(scale => scale === 1 ? 1.2 : 1);
    }, 1500);

    return () => clearInterval(pulse);
  }, []);

  const nextStep = () => {
    if (currentStep < tutorialSteps.length - 1) {
      setCurrentStep(currentStep + 1);
    } else {
      completeTutorial();
    }
  };

  const previousStep = () => {
    if (currentStep > 0) {
      setCurrentStep(currentStep - 1);
    }
  };

  const completeTutorial = () => {
    setShowOverlay(false);
    setTimeout(() => onComplete?.(), 300);
  };

  const currentStepData = tutorialSteps[currentStep];

  return (
    <div className="min-h-screen bg-gradient-to-b from-indigo-500 to-purple-600 relative">
      {/* Mock App Interface */}
      <div className="relative z-10">
        {/* App Bar */}
        <div className="flex items-center justify-between p-4 pt-12">
          <Menu size={28} className="text-white" id="menu" />
          <h1 className="text-2xl font-bold text-white">AIQ</h1>
          <User size={28} className="text-white" id="profile" />
        </div>

        {/* Main Content */}
        <div className="bg-white mx-4 rounded-3xl h-[70vh] flex items-center justify-center">
          <div className="text-center">
            <div
              id="quiz"
              className="w-32 h-32 bg-indigo-500 rounded-full flex items-center justify-center mx-auto mb-6"
            >
              <Play size={60} className="text-white ml-2" />
            </div>

            <h2 className="text-2xl font-bold text-gray-900 mb-8">
              Start Your AIQ Test
            </h2>

            <div
              id="progress"
              className="bg-gray-100 rounded-2xl p-4 mx-8 flex items-center space-x-3"
            >
              <TrendingUp className="text-indigo-500" size={24} />
              <span className="text-gray-700 font-medium">View Progress</span>
            </div>
          </div>
        </div>
      </div>

      {/* Tutorial Overlay */}
      {showOverlay && (
        <div className="absolute inset-0 bg-black/80 z-50 flex items-end">
          {/* Spotlight effect (simplified) */}
          <div
            className="absolute w-20 h-20 bg-white/20 rounded-full"
            style={{
              transform: `scale(${pulseScale})`,
              transition: 'transform 1.5s ease-in-out',
              left: currentStep === 0 ? '16px' : currentStep === 1 ? '50%' : currentStep === 2 ? '50%' : 'calc(100% - 60px)',
              top: currentStep === 0 ? '60px' : currentStep === 1 ? '40%' : currentStep === 2 ? '60%' : '60px',
              marginLeft: currentStep === 1 || currentStep === 2 ? '-40px' : '0'
            }}
          />

          {/* Tutorial Card */}
          <div className="bg-white rounded-t-3xl p-6 w-full">
            <div className="flex items-center justify-between mb-4">
              <div className="bg-indigo-500 text-white px-2 py-1 rounded-lg text-sm font-semibold">
                {currentStep + 1}/{tutorialSteps.length}
              </div>
              <button
                onClick={completeTutorial}
                className="text-gray-500 hover:text-gray-700"
              >
                <X size={20} />
              </button>
            </div>

            <h3 className="text-xl font-bold text-gray-900 mb-2">
              {currentStepData.title}
            </h3>

            <p className="text-gray-600 mb-6 leading-relaxed">
              {currentStepData.description}
            </p>

            <div className="flex items-center space-x-3">
              {currentStep > 0 && (
                <button
                  onClick={previousStep}
                  className="flex-1 border-2 border-gray-200 text-gray-600 py-3 px-4 rounded-xl font-medium hover:bg-gray-50 transition-colors"
                >
                  Previous
                </button>
              )}

              <button
                onClick={nextStep}
                className="flex-1 bg-indigo-500 text-white py-3 px-4 rounded-xl font-semibold hover:bg-indigo-600 transition-colors"
              >
                {currentStep === tutorialSteps.length - 1 ? 'Finish' : 'Next'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default TutorialScreen;