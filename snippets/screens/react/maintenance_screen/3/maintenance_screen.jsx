import React, { useState, useEffect } from 'react';
import { Wrench, Clock, RefreshCw, Mail, Info } from 'lucide-react';

const MaintenanceScreen = ({
  title = "Under Maintenance",
  message = "We're currently performing scheduled maintenance to improve your AIQ experience. Thank you for your patience!",
  estimatedEnd,
  onRefresh,
  supportEmail
}) => {
  const [toolsRotation, setToolsRotation] = useState(0);

  useEffect(() => {
    const interval = setInterval(() => {
      setToolsRotation(rotation => rotation === 0 ? 15 : 0);
    }, 2000);

    return () => clearInterval(interval);
  }, []);

  const formatEstimatedTime = (date) => {
    if (!date) return null;

    const now = new Date();
    const difference = date.getTime() - now.getTime();

    if (difference <= 0) {
      return "Expected to be resolved soon";
    }

    const hours = Math.floor(difference / (1000 * 60 * 60));
    const minutes = Math.floor((difference % (1000 * 60 * 60)) / (1000 * 60));

    if (hours > 0) {
      return `Expected back in ${hours}h ${minutes}m`;
    } else {
      return `Expected back in ${minutes}m`;
    }
  };

  const copyEmail = () => {
    if (supportEmail) {
      navigator.clipboard.writeText(supportEmail);
      // Could show a toast here
    }
  };

  return (
    <div className="min-h-screen bg-white flex items-center justify-center p-6">
      <div className="text-center w-full max-w-md">
        {/* Maintenance Illustration */}
        <div className="mb-10">
          <div className="w-40 h-40 bg-amber-50 rounded-full mx-auto flex items-center justify-center relative">
            <Wrench size={60} className="text-amber-500" />

            {/* Animated Tools */}
            <div
              className="absolute top-5 right-8 transition-transform duration-2000 ease-in-out"
              style={{ transform: `rotate(${toolsRotation}deg)` }}
            >
              <div className="w-5 h-5 bg-amber-400 rounded-full opacity-60"></div>
            </div>
            <div
              className="absolute bottom-8 left-6 transition-transform duration-2000 ease-in-out"
              style={{ transform: `rotate(${-toolsRotation * 0.6}deg)` }}
            >
              <div className="w-4 h-4 bg-amber-400 rounded-sm opacity-50"></div>
            </div>
          </div>
        </div>

        {/* Content */}
        <h1 className="text-3xl font-bold text-gray-900 mb-4">
          {title}
        </h1>

        <p className="text-gray-600 text-lg mb-8 leading-relaxed">
          {message}
        </p>

        {/* Estimated Time */}
        {estimatedEnd && (
          <div className="bg-amber-50 border border-amber-200 rounded-xl p-4 mb-8">
            <div className="flex items-center justify-center space-x-3">
              <Clock className="w-5 h-5 text-amber-600" />
              <span className="text-amber-800 font-medium">
                {formatEstimatedTime(estimatedEnd)}
              </span>
            </div>
          </div>
        )}

        {/* Status Updates */}
        <div className="bg-gray-50 border border-gray-200 rounded-xl p-5 mb-8 text-left">
          <div className="flex items-center space-x-2 mb-3">
            <Info className="w-5 h-5 text-indigo-500" />
            <span className="font-semibold text-gray-900 text-sm">What we're working on:</span>
          </div>

          <div className="space-y-2 text-sm text-gray-600">
            {[
              "Improving quiz loading performance",
              "Adding new AI challenges",
              "Enhancing user experience",
              "Server optimization"
            ].map((item, index) => (
              <div key={index} className="flex items-center space-x-2">
                <div className="w-1.5 h-1.5 bg-indigo-500 rounded-full"></div>
                <span>{item}</span>
              </div>
            ))}
          </div>
        </div>

        {/* Action Buttons */}
        <div className="space-y-3">
          <button
            onClick={onRefresh}
            className="w-full bg-indigo-500 text-white py-3 px-6 rounded-xl font-semibold hover:bg-indigo-600 transition-colors flex items-center justify-center space-x-2"
          >
            <RefreshCw size={18} />
            <span>Check Status</span>
          </button>

          {supportEmail && (
            <button
              onClick={copyEmail}
              className="w-full border-2 border-gray-200 text-gray-600 py-3 px-6 rounded-xl font-medium hover:bg-gray-50 transition-colors flex items-center justify-center space-x-2"
            >
              <Mail size={18} />
              <span>Contact Support</span>
            </button>
          )}
        </div>

        <p className="text-sm text-gray-400 mt-6">
          Follow us on social media for live updates
        </p>
      </div>
    </div>
  );
};

export default MaintenanceScreen;