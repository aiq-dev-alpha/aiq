import React from 'react';
import { AlertTriangle, RefreshCw, ArrowLeft } from 'lucide-react';

const ErrorScreen = ({
  title = "Oops! Something went wrong",
  message = "We encountered an unexpected error. Don't worry, it happens to the best of us! Please try again.",
  buttonText = "Try Again",
  onRetry,
  onGoBack
}) => {
  return (
    <div className="min-h-screen bg-white flex items-center justify-center p-6">
      <div className="text-center w-full max-w-md">
        {/* Error Icon */}
        <div className="mb-10">
          <div className="w-30 h-30 border-4 border-red-100 bg-red-50 rounded-full mx-auto flex items-center justify-center">
            <AlertTriangle size={60} className="text-red-500" />
          </div>
        </div>

        {/* Content */}
        <h1 className="text-3xl font-bold text-gray-900 mb-4 leading-tight">
          {title}
        </h1>

        <p className="text-gray-600 text-lg mb-10 leading-relaxed">
          {message}
        </p>

        {/* Error Illustration */}
        <div className="mb-10 py-8">
          <div className="w-24 h-24 mx-auto bg-gray-100 rounded-2xl flex items-center justify-center">
            <div className="text-gray-400 text-4xl">🤖</div>
          </div>
        </div>

        {/* Action Buttons */}
        <div className="space-y-3">
          <button
            onClick={onRetry}
            className="w-full bg-indigo-500 text-white py-4 px-6 rounded-2xl font-semibold hover:bg-indigo-600 transition-colors flex items-center justify-center space-x-2"
          >
            <RefreshCw size={20} />
            <span>{buttonText}</span>
          </button>

          <button
            onClick={onGoBack}
            className="w-full border-2 border-gray-200 text-gray-600 py-4 px-6 rounded-2xl font-medium hover:bg-gray-50 transition-colors flex items-center justify-center space-x-2"
          >
            <ArrowLeft size={20} />
            <span>Go Back</span>
          </button>
        </div>

        <p className="text-sm text-gray-400 mt-6">
          If the problem persists, please contact our support team
        </p>
      </div>
    </div>
  );
};

export default ErrorScreen;