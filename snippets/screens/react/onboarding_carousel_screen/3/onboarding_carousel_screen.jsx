import React, { useState, useEffect } from 'react';
import { Brain, Quiz, TrendingUp, ArrowRight, ChevronLeft, ChevronRight } from 'lucide-react';

const OnboardingCarouselScreen = ({ onComplete, onSkip }) => {
  const [currentIndex, setCurrentIndex] = useState(0);
  const [isAnimating, setIsAnimating] = useState(false);

  const pages = [
    {
      icon: Brain,
      title: "Discover Your AI Potential",
      description: "Explore the fascinating world of artificial intelligence and discover how smart you really are.",
      color: "from-indigo-500 to-indigo-600"
    },
    {
      icon: Quiz,
      title: "Take Smart Challenges",
      description: "Engage with carefully crafted questions designed to test your AI knowledge and reasoning skills.",
      color: "from-purple-500 to-purple-600"
    },
    {
      icon: TrendingUp,
      title: "Track Your Progress",
      description: "Monitor your improvement over time and compete with friends to see who has the highest AIQ score.",
      color: "from-cyan-500 to-cyan-600"
    }
  ];

  const nextPage = () => {
    if (isAnimating) return;

    if (currentIndex < pages.length - 1) {
      setIsAnimating(true);
      setTimeout(() => {
        setCurrentIndex(currentIndex + 1);
        setIsAnimating(false);
      }, 150);
    } else {
      onComplete?.();
    }
  };

  const previousPage = () => {
    if (isAnimating || currentIndex === 0) return;

    setIsAnimating(true);
    setTimeout(() => {
      setCurrentIndex(currentIndex - 1);
      setIsAnimating(false);
    }, 150);
  };

  const currentPage = pages[currentIndex];
  const IconComponent = currentPage.icon;

  return (
    <div className={`min-h-screen bg-gradient-to-b ${currentPage.color} text-white transition-all duration-500`}>
      <div className="flex flex-col min-h-screen">
        {/* Skip button */}
        <div className="flex justify-end p-6">
          <button
            onClick={onSkip}
            className="text-white/80 hover:text-white transition-colors text-lg font-medium"
          >
            Skip
          </button>
        </div>

        {/* Page content */}
        <div className="flex-1 flex items-center justify-center px-6">
          <div className={`text-center transition-all duration-300 ${isAnimating ? 'opacity-0 transform scale-95' : 'opacity-100 transform scale-100'}`}>
            {/* Icon */}
            <div className="mb-12">
              <div className="w-30 h-30 bg-white/20 rounded-full mx-auto flex items-center justify-center">
                <IconComponent size={60} className="text-white" />
              </div>
            </div>

            {/* Content */}
            <h1 className="text-3xl md:text-4xl font-bold mb-6 leading-tight">
              {currentPage.title}
            </h1>
            <p className="text-lg text-white/80 leading-relaxed max-w-md mx-auto">
              {currentPage.description}
            </p>
          </div>
        </div>

        {/* Navigation */}
        <div className="p-6">
          {/* Page indicators */}
          <div className="flex justify-center mb-8">
            {pages.map((_, index) => (
              <div
                key={index}
                className={`h-2 mx-1 rounded-full transition-all duration-300 ${
                  index === currentIndex
                    ? 'w-6 bg-white'
                    : 'w-2 bg-white/40'
                }`}
              />
            ))}
          </div>

          {/* Navigation buttons */}
          <div className="flex items-center justify-between">
            <button
              onClick={previousPage}
              className={`p-3 rounded-full transition-all ${
                currentIndex === 0
                  ? 'invisible'
                  : 'bg-white/20 hover:bg-white/30 active:bg-white/40'
              }`}
            >
              <ChevronLeft size={24} />
            </button>

            <button
              onClick={nextPage}
              className="bg-white text-gray-800 px-8 py-4 rounded-2xl font-semibold hover:bg-white/90 transition-all flex items-center space-x-2"
            >
              <span>
                {currentIndex === pages.length - 1 ? 'Get Started' : 'Next'}
              </span>
              {currentIndex < pages.length - 1 && <ArrowRight size={20} />}
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default OnboardingCarouselScreen;