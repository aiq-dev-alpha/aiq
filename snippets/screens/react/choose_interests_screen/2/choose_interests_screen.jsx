import React, { useState } from 'react';
import { Heart, Info, ArrowRight, Cpu, Atom, Code, Building } from 'lucide-react';

const ChooseInterestsScreen = ({ onContinue }) => {
  const [selectedInterests, setSelectedInterests] = useState(new Set());
  const minSelections = 3;

  const categories = [
    {
      name: "AI & Technology",
      interests: ["Machine Learning", "Deep Learning", "Computer Vision", "Natural Language Processing", "Robotics", "Data Science"],
      color: "indigo",
      icon: Cpu
    },
    {
      name: "Science & Research",
      interests: ["Physics", "Mathematics", "Chemistry", "Biology", "Neuroscience", "Psychology"],
      color: "purple",
      icon: Atom
    },
    {
      name: "Programming",
      interests: ["Python", "JavaScript", "Flutter/Dart", "Swift", "Java", "React"],
      color: "cyan",
      icon: Code
    },
    {
      name: "Business & Innovation",
      interests: ["Entrepreneurship", "Product Management", "Digital Marketing", "Strategy", "Finance", "Leadership"],
      color: "green",
      icon: Building
    }
  ];

  const toggleInterest = (interest) => {
    const newSelected = new Set(selectedInterests);
    if (newSelected.has(interest)) {
      newSelected.delete(interest);
    } else {
      newSelected.add(interest);
    }
    setSelectedInterests(newSelected);
  };

  const getColorClasses = (color, isSelected) => {
    const colors = {
      indigo: isSelected ? 'bg-indigo-500 text-white border-indigo-500' : 'bg-white text-gray-600 border-gray-200 hover:border-indigo-300',
      purple: isSelected ? 'bg-purple-500 text-white border-purple-500' : 'bg-white text-gray-600 border-gray-200 hover:border-purple-300',
      cyan: isSelected ? 'bg-cyan-500 text-white border-cyan-500' : 'bg-white text-gray-600 border-gray-200 hover:border-cyan-300',
      green: isSelected ? 'bg-green-500 text-white border-green-500' : 'bg-white text-gray-600 border-gray-200 hover:border-green-300',
    };
    return colors[color];
  };

  const getIconColorClass = (color) => {
    const colors = {
      indigo: 'bg-indigo-50 text-indigo-500',
      purple: 'bg-purple-50 text-purple-500',
      cyan: 'bg-cyan-50 text-cyan-500',
      green: 'bg-green-50 text-green-500',
    };
    return colors[color];
  };

  return (
    <div className="min-h-screen bg-white p-6">
      <div className="pt-8">
        {/* Header */}
        <div className="flex items-center mb-4">
          <div className="w-12 h-12 bg-gradient-to-br from-indigo-500 to-purple-600 rounded-xl flex items-center justify-center mr-4">
            <Heart className="w-6 h-6 text-white" />
          </div>
          <div>
            <h1 className="text-2xl font-bold text-gray-900">Choose Your Interests</h1>
            <p className="text-gray-600 text-sm">Help us personalize your experience</p>
          </div>
        </div>

        {/* Info Banner */}
        <div className="bg-gray-50 rounded-xl p-3 mb-6 flex items-center">
          <Info className="w-4 h-4 text-gray-500 mr-2" />
          <p className="text-sm text-gray-600">
            Select at least {minSelections} interests ({selectedInterests.size} selected)
          </p>
        </div>

        {/* Categories */}
        <div className="space-y-6 mb-8">
          {categories.map(category => {
            const IconComponent = category.icon;
            return (
              <div key={category.name}>
                {/* Category Header */}
                <div className="flex items-center mb-3">
                  <div className={`w-8 h-8 rounded-lg flex items-center justify-center mr-3 ${getIconColorClass(category.color)}`}>
                    <IconComponent className="w-4 h-4" />
                  </div>
                  <h2 className="text-lg font-semibold text-gray-900">{category.name}</h2>
                </div>

                {/* Interest Chips */}
                <div className="flex flex-wrap gap-2">
                  {category.interests.map(interest => {
                    const isSelected = selectedInterests.has(interest);
                    return (
                      <button
                        key={interest}
                        onClick={() => toggleInterest(interest)}
                        className={`px-4 py-2 rounded-full text-sm font-medium border-2 transition-all ${getColorClasses(category.color, isSelected)}`}
                      >
                        <span className="flex items-center space-x-1">
                          {isSelected && <span className="text-xs">✓</span>}
                          <span>{interest}</span>
                        </span>
                      </button>
                    );
                  })}
                </div>
              </div>
            );
          })}
        </div>

        {/* Continue Button */}
        <button
          onClick={onContinue}
          disabled={selectedInterests.size < minSelections}
          className={`w-full py-4 px-6 rounded-2xl font-semibold flex items-center justify-center space-x-2 transition-all ${
            selectedInterests.size >= minSelections
              ? 'bg-indigo-500 text-white hover:bg-indigo-600'
              : 'bg-gray-200 text-gray-400 cursor-not-allowed'
          }`}
        >
          <span>Continue with {selectedInterests.size} interests</span>
          {selectedInterests.size >= minSelections && <ArrowRight size={20} />}
        </button>
      </div>
    </div>
  );
};

export default ChooseInterestsScreen;