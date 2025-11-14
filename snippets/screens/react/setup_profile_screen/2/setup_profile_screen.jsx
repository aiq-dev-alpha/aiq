import React, { useState } from 'react';
import { UserPlus, User, Check } from 'lucide-react';

const SetupProfileScreen = ({ onComplete }) => {
  const [formData, setFormData] = useState({
    fullName: '',
    selectedAvatar: '👤',
    ageRange: 0,
    occupation: '',
    bio: ''
  });
  const [isLoading, setIsLoading] = useState(false);

  const avatars = ['👤', '👨', '👩', '🧑', '👴', '👵', '🤵', '👩‍💼'];
  const ageRanges = ['18-24', '25-34', '35-44', '45-54', '55-64', '65+'];
  const occupations = ['Student', 'Software Developer', 'Data Scientist', 'Researcher', 'Teacher/Professor', 'Business Analyst', 'Product Manager', 'Designer', 'Entrepreneur', 'Other'];

  const handleSubmit = async () => {
    if (!formData.fullName.trim()) return;

    setIsLoading(true);
    // Simulate API call
    setTimeout(() => {
      setIsLoading(false);
      onComplete?.();
    }, 2000);
  };

  const isFormValid = formData.fullName.trim().length > 0;

  return (
    <div className="min-h-screen bg-white p-6">
      <div className="pt-8">
        {/* Header */}
        <div className="flex items-center mb-8">
          <div className="w-12 h-12 bg-gradient-to-br from-indigo-500 to-purple-600 rounded-xl flex items-center justify-center mr-4">
            <UserPlus className="w-6 h-6 text-white" />
          </div>
          <div>
            <h1 className="text-2xl font-bold text-gray-900">Create Your Profile</h1>
            <p className="text-gray-600 text-sm">Tell us about yourself</p>
          </div>
        </div>

        <div className="space-y-6">
          {/* Avatar Selection */}
          <div>
            <label className="block text-base font-semibold text-gray-900 mb-3">Choose Avatar</label>
            <div className="flex space-x-3 overflow-x-auto pb-2">
              {avatars.map(avatar => (
                <button
                  key={avatar}
                  onClick={() => setFormData(prev => ({ ...prev, selectedAvatar: avatar }))}
                  className={`w-15 h-15 flex-shrink-0 rounded-full flex items-center justify-center text-2xl border-3 transition-all ${
                    formData.selectedAvatar === avatar
                      ? 'border-indigo-500 bg-indigo-50'
                      : 'border-gray-200 bg-gray-50'
                  }`}
                >
                  {avatar}
                </button>
              ))}
            </div>
          </div>

          {/* Full Name */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">Full Name</label>
            <div className="relative">
              <User className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 w-5 h-5" />
              <input
                type="text"
                value={formData.fullName}
                onChange={(e) => setFormData(prev => ({ ...prev, fullName: e.target.value }))}
                placeholder="Enter your full name"
                className="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none"
              />
            </div>
          </div>

          {/* Age Range */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">Age Range</label>
            <select
              value={formData.ageRange}
              onChange={(e) => setFormData(prev => ({ ...prev, ageRange: parseInt(e.target.value) }))}
              className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none bg-white"
            >
              {ageRanges.map((range, index) => (
                <option key={index} value={index}>{range}</option>
              ))}
            </select>
          </div>

          {/* Occupation */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">Occupation</label>
            <select
              value={formData.occupation}
              onChange={(e) => setFormData(prev => ({ ...prev, occupation: e.target.value }))}
              className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none bg-white"
            >
              <option value="">Select your occupation</option>
              {occupations.map(occupation => (
                <option key={occupation} value={occupation}>{occupation}</option>
              ))}
            </select>
          </div>

          {/* Bio */}
          <div>
            <div className="flex justify-between items-center mb-2">
              <label className="text-sm font-medium text-gray-700">Bio (Optional)</label>
              <span className="text-xs text-gray-500">{formData.bio.length}/150</span>
            </div>
            <textarea
              value={formData.bio}
              onChange={(e) => {
                if (e.target.value.length <= 150) {
                  setFormData(prev => ({ ...prev, bio: e.target.value }));
                }
              }}
              placeholder="Tell us something about yourself..."
              rows={3}
              className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none resize-none"
            />
          </div>
        </div>

        {/* Submit Button */}
        <div className="mt-8">
          <button
            onClick={handleSubmit}
            disabled={!isFormValid || isLoading}
            className={`w-full py-4 px-6 rounded-2xl font-semibold flex items-center justify-center space-x-2 transition-all ${
              isFormValid && !isLoading
                ? 'bg-indigo-500 text-white hover:bg-indigo-600'
                : 'bg-gray-200 text-gray-400 cursor-not-allowed'
            }`}
          >
            {isLoading ? (
              <div className="w-6 h-6 border-2 border-white border-t-transparent rounded-full animate-spin" />
            ) : (
              <>
                <span>Create Profile</span>
                <Check size={20} />
              </>
            )}
          </button>
        </div>
      </div>
    </div>
  );
};

export default SetupProfileScreen;