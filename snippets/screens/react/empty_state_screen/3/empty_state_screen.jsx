import React from 'react';
import { Inbox } from 'lucide-react';

const EmptyStateScreen = ({
  title = "Nothing here yet",
  message = "It looks like there's no content to show right now. Try refreshing or come back later.",
  icon: Icon = Inbox,
  buttonText,
  onAction
}) => {
  return (
    <div className="min-h-screen bg-white flex items-center justify-center p-8">
      <div className="text-center w-full max-w-sm">
        {/* Icon */}
        <div className="mb-8">
          <div className="w-30 h-30 bg-gray-100 rounded-full mx-auto flex items-center justify-center">
            <Icon size={60} className="text-gray-400" />
          </div>
        </div>

        {/* Content */}
        <h2 className="text-2xl font-bold text-gray-900 mb-3">
          {title}
        </h2>

        <p className="text-gray-600 leading-relaxed mb-8">
          {message}
        </p>

        {/* Action Button */}
        {onAction && buttonText && (
          <button
            onClick={onAction}
            className="w-full bg-indigo-500 text-white py-3 px-6 rounded-xl font-semibold hover:bg-indigo-600 transition-colors"
          >
            {buttonText}
          </button>
        )}
      </div>
    </div>
  );
};

export default EmptyStateScreen;