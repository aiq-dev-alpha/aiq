import React, { useState, useEffect } from 'react';
import { Check, ArrowRight } from 'lucide-react';

const SuccessScreen = ({
  title = "Success!",
  message = "Your profile has been created successfully. You're ready to start your AIQ journey!",
  buttonText = "Get Started",
  onContinue
}) => {
  const [iconScale, setIconScale] = useState(0);
  const [contentOpacity, setContentOpacity] = useState(0);

  useEffect(() => {
    setIconScale(1);
    setTimeout(() => setContentOpacity(1), 200);
  }, []);

  return (
    <div className="min-h-screen bg-gradient-to-b from-green-500 to-green-600 flex items-center justify-center text-white p-6">
      <div className="text-center w-full max-w-md">
        {/* Success Icon */}
        <div className="mb-10">
          <div
            className={`w-30 h-30 bg-white rounded-full shadow-2xl mx-auto flex items-center justify-center transition-transform duration-800 ease-out ${
              iconScale === 1 ? 'scale-100' : 'scale-0'
            }`}
            style={{ transform: `scale(${iconScale})` }}
          >
            <Check size={60} className="text-green-500" />
          </div>
        </div>

        {/* Content */}
        <div
          className={`transition-opacity duration-600 ${
            contentOpacity === 1 ? 'opacity-100' : 'opacity-0'
          }`}
        >
          <h1 className="text-4xl font-bold mb-4 leading-tight">
            {title}
          </h1>

          <p className="text-lg text-white/80 mb-10 leading-relaxed">
            {message}
          </p>

          {/* Floating Elements */}
          <div className="relative mb-10">
            <div className="absolute -top-4 -left-4 text-2xl animate-bounce">✨</div>
            <div className="absolute -top-2 -right-2 text-xl animate-pulse">🎉</div>
            <div className="absolute -bottom-2 left-4 text-lg animate-bounce delay-300">⭐</div>
            <div className="absolute -bottom-4 -right-6 text-2xl animate-pulse delay-500">🚀</div>
          </div>

          {/* Continue Button */}
          <button
            onClick={onContinue}
            className="w-full bg-white text-green-500 py-4 px-6 rounded-2xl font-semibold hover:bg-gray-50 transition-colors flex items-center justify-center space-x-2"
          >
            <span>{buttonText}</span>
            <ArrowRight size={20} />
          </button>
        </div>
      </div>
    </div>
  );
};

export default SuccessScreen;