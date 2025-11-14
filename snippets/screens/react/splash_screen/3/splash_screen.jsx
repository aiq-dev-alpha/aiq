import React, { useState, useEffect } from 'react';
import { Rocket, Brain } from 'lucide-react';

const SplashScreen = ({ onComplete }) => {
  const [logoScale, setLogoScale] = useState(0.8);
  const [logoOpacity, setLogoOpacity] = useState(0);
  const [textOpacity, setTextOpacity] = useState(0);
  const [showProgress, setShowProgress] = useState(false);

  useEffect(() => {
    const timeline = async () => {
      // Logo fade in
      setLogoOpacity(1);

      // Logo scale animation
      setTimeout(() => setLogoScale(1), 200);

      // Text fade in
      setTimeout(() => setTextOpacity(1), 400);

      // Progress indicator
      setTimeout(() => setShowProgress(true), 800);

      // Navigate after 3 seconds
      setTimeout(() => {
        if (onComplete) onComplete();
      }, 3000);
    };

    timeline();
  }, [onComplete]);

  return (
    <div className="min-h-screen bg-gradient-to-b from-indigo-500 to-indigo-600 flex items-center justify-center text-white">
      <div className="text-center">
        {/* Logo */}
        <div
          className="mb-8 transition-all duration-500 ease-out"
          style={{
            transform: `scale(${logoScale})`,
            opacity: logoOpacity
          }}
        >
          <div className="w-30 h-30 bg-white rounded-3xl shadow-2xl mx-auto flex items-center justify-center mb-8">
            <Rocket className="w-15 h-15 text-indigo-500" size={60} />
          </div>
        </div>

        {/* Title */}
        <div
          className="transition-opacity duration-600"
          style={{ opacity: textOpacity }}
        >
          <h1 className="text-4xl font-bold mb-4 tracking-widest">
            AIQ
          </h1>
          <p className="text-lg text-white/70 mb-20 tracking-wide">
            Artificial Intelligence Quotient
          </p>
        </div>

        {/* Progress Indicator */}
        {showProgress && (
          <div className="transition-opacity duration-400">
            <div className="w-8 h-8 border-2 border-white/70 border-t-transparent rounded-full animate-spin mx-auto"></div>
          </div>
        )}
      </div>
    </div>
  );
};

export default SplashScreen;