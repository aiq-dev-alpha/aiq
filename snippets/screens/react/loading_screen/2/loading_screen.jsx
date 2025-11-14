import React, { useState, useEffect } from 'react';
import { Brain } from 'lucide-react';

const LoadingScreen = ({
  title = "Loading",
  message,
  showProgress = false,
  progress,
  primaryColor = "indigo"
}) => {
  const [currentMessageIndex, setCurrentMessageIndex] = useState(0);

  const loadingMessages = [
    "Preparing your experience...",
    "Loading AI challenges...",
    "Setting up your profile...",
    "Almost ready..."
  ];

  useEffect(() => {
    if (!message) {
      const interval = setInterval(() => {
        setCurrentMessageIndex((prev) => (prev + 1) % loadingMessages.length);
      }, 2000);

      return () => clearInterval(interval);
    }
  }, [message]);

  const colorClasses = {
    indigo: 'from-indigo-500 to-indigo-600',
    green: 'from-green-500 to-green-600',
    purple: 'from-purple-500 to-purple-600',
    cyan: 'from-cyan-500 to-cyan-600'
  };

  return (
    <div className={`min-h-screen bg-gradient-to-b ${colorClasses[primaryColor]} text-white flex items-center justify-center p-8`}>
      <div className="text-center w-full max-w-sm">
        {/* Loading Animation */}
        <div className="mb-10">
          <div className="relative">
            {/* Pulse Ring */}
            <div className="w-20 h-20 bg-white/20 rounded-full mx-auto animate-pulse"></div>

            {/* Spinning Ring */}
            <div className="absolute inset-0 w-16 h-16 border-3 border-white border-t-transparent rounded-full animate-spin mx-auto mt-2"></div>

            {/* Inner Icon */}
            <div className="absolute inset-0 w-12 h-12 bg-white rounded-full flex items-center justify-center mx-auto mt-4">
              <Brain size={24} className={`text-${primaryColor}-500`} />
            </div>
          </div>
        </div>

        {/* Title */}
        <h1 className="text-3xl font-bold mb-4">
          {title}
        </h1>

        {/* Message */}
        <div className="h-12 flex items-center justify-center">
          <p className="text-white/80 text-center leading-relaxed">
            {message || loadingMessages[currentMessageIndex]}
          </p>
        </div>

        {/* Progress */}
        <div className="mt-10">
          {showProgress ? (
            <div className="space-y-2">
              {progress !== undefined && (
                <div className="text-right text-sm text-white/70">
                  {Math.round(progress * 100)}%
                </div>
              )}
              <div className="w-full bg-white/30 rounded-full h-1">
                <div
                  className="bg-white h-1 rounded-full transition-all duration-300"
                  style={{ width: progress ? `${progress * 100}%` : '0%' }}
                ></div>
              </div>
            </div>
          ) : (
            <div className="flex justify-center space-x-2">
              {[0, 1, 2].map((i) => (
                <div
                  key={i}
                  className="w-2 h-2 bg-white/60 rounded-full animate-pulse"
                  style={{
                    animationDelay: `${i * 0.2}s`,
                    animationDuration: '1.4s'
                  }}
                ></div>
              ))}
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default LoadingScreen;