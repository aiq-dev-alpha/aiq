import React, { useState, useEffect } from 'react';
import { Brain, ArrowRight, Play } from 'lucide-react';

const WelcomeScreen = ({ onStartTutorial, onSkipTutorial }) => {
  const [isVisible, setIsVisible] = useState(false);
  const [illustrationScale, setIllustrationScale] = useState(0.8);

  useEffect(() => {
    setIsVisible(true);
    setTimeout(() => setIllustrationScale(1), 200);
  }, []);

  return (
    <div className="min-h-screen bg-white flex flex-col">
      <div className={`flex-1 p-6 transition-all duration-800 ${isVisible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-4'}`}>
        {/* Header */}
        <div className="mt-10 mb-8">
          <div className="inline-block bg-indigo-50 text-indigo-600 px-3 py-1 rounded-full text-sm font-semibold mb-6">
            Welcome!
          </div>

          <h1 className="text-4xl font-bold text-gray-900 leading-tight mb-4">
            Ready to test your<br />AI intelligence?
          </h1>

          <p className="text-gray-600 text-lg leading-relaxed">
            Join thousands of users discovering their AI potential. Let's get you started on your journey to understanding artificial intelligence.
          </p>
        </div>

        {/* Illustration */}
        <div className="flex-1 flex items-center justify-center">
          <div
            className={`transition-all duration-800 ${illustrationScale === 1 ? 'scale-100' : 'scale-80'}`}
            style={{ transform: `scale(${illustrationScale})` }}
          >
            <div className="relative">
              <div className="w-48 h-48 bg-gradient-to-br from-indigo-500 to-purple-600 rounded-full shadow-2xl flex items-center justify-center">
                <Brain size={80} className="text-white" />
              </div>
              {/* Floating elements */}
              <div className="absolute -top-2 -right-2 w-6 h-6 bg-yellow-400 rounded-full animate-pulse"></div>
              <div className="absolute -bottom-3 -left-3 w-4 h-4 bg-pink-400 rounded-full animate-bounce"></div>
              <div className="absolute top-1/2 -right-6 w-3 h-3 bg-green-400 rounded-full animate-ping"></div>
            </div>
          </div>
        </div>

        {/* Action buttons */}
        <div className={`space-y-4 transition-all duration-800 delay-300 ${isVisible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-4'}`}>
          <button
            onClick={onStartTutorial}
            className="w-full bg-indigo-500 text-white py-4 px-6 rounded-2xl font-semibold hover:bg-indigo-600 transition-colors flex items-center justify-center space-x-2"
          >
            <span>Start Tutorial</span>
            <ArrowRight size={20} />
          </button>

          <button
            onClick={onSkipTutorial}
            className="w-full border-2 border-gray-200 text-gray-600 py-4 px-6 rounded-2xl font-medium hover:bg-gray-50 transition-colors"
          >
            Skip Tutorial
          </button>
        </div>
      </div>
    </div>
  );
};

export default WelcomeScreen;