import React, { useState } from 'react';
import {
  User,
  Edit,
  Share,
  Settings,
  HelpCircle,
  Info,
  Mail,
  Phone,
  MapPin,
  Calendar,
  Globe,
  ChevronRight,
  Check
} from 'lucide-react';

const ProfileScreen = () => {
  const [showShareDialog, setShowShareDialog] = useState(false);

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <header className="bg-white shadow-sm border-b border-gray-200">
        <div className="max-w-4xl mx-auto px-4 py-4 flex justify-between items-center">
          <h1 className="text-xl font-semibold text-gray-900">Profile</h1>
          <button
            className="flex items-center gap-2 px-4 py-2 text-blue-600 hover:text-blue-800 transition-colors"
            onClick={() => {/* Navigate to edit */}}
          >
            <Edit size={18} />
            Edit
          </button>
        </div>
      </header>

      <div className="max-w-4xl mx-auto px-4 py-8">
        <div className="space-y-8">
          {/* Profile Header */}
          <ProfileHeader onShare={() => setShowShareDialog(true)} />

          {/* Stats Section */}
          <StatsSection />

          {/* Profile Details */}
          <ProfileDetailsCard />

          {/* Quick Actions */}
          <QuickActionsCard />
        </div>
      </div>

      {/* Share Dialog */}
      {showShareDialog && (
        <ShareDialog onClose={() => setShowShareDialog(false)} />
      )}
    </div>
  );
};

const ProfileHeader = ({ onShare }) => {
  return (
    <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-8">
      <div className="flex flex-col items-center space-y-6">
        {/* Profile Picture */}
        <div className="relative">
          <img
            src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=80"
            alt="Profile"
            className="w-32 h-32 rounded-full object-cover"
          />
          <div className="absolute bottom-0 right-0 w-6 h-6 bg-blue-500 rounded-full flex items-center justify-center">
            <Check size={16} className="text-white" />
          </div>
        </div>

        {/* Profile Info */}
        <div className="text-center space-y-2">
          <h2 className="text-2xl font-bold text-gray-900">John Doe</h2>
          <p className="text-gray-600">@johndoe</p>
          <p className="text-gray-700 max-w-md">
            Software Engineer | Flutter Developer | Tech Enthusiast<br />
            Building amazing apps with Flutter 🚀
          </p>
        </div>

        {/* Action Buttons */}
        <div className="flex gap-4 w-full max-w-md">
          <button className="flex-1 bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-lg font-medium transition-colors flex items-center justify-center gap-2">
            <Edit size={18} />
            Edit Profile
          </button>
          <button
            className="flex-1 border border-gray-300 hover:border-gray-400 text-gray-700 px-6 py-3 rounded-lg font-medium transition-colors flex items-center justify-center gap-2"
            onClick={onShare}
          >
            <Share size={18} />
            Share
          </button>
        </div>
      </div>
    </div>
  );
};

const StatsSection = () => {
  const stats = [
    { label: 'Posts', count: '128' },
    { label: 'Following', count: '342' },
    { label: 'Followers', count: '1.2K' }
  ];

  return (
    <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
      <div className="flex justify-around">
        {stats.map((stat, index) => (
          <div key={index} className="text-center">
            <div className="text-2xl font-bold text-gray-900">{stat.count}</div>
            <div className="text-sm text-gray-600">{stat.label}</div>
          </div>
        ))}
      </div>
    </div>
  );
};

const ProfileDetailsCard = () => {
  const details = [
    { icon: Mail, label: 'Email', value: 'john.doe@example.com' },
    { icon: Phone, label: 'Phone', value: '+1 (555) 123-4567' },
    { icon: MapPin, label: 'Location', value: 'San Francisco, CA' },
    { icon: Calendar, label: 'Joined', value: 'January 2023' },
    { icon: Globe, label: 'Website', value: 'www.johndoe.dev' }
  ];

  return (
    <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
      <h3 className="text-lg font-semibold text-gray-900 mb-6">Profile Details</h3>
      <div className="space-y-4">
        {details.map((detail, index) => {
          const Icon = detail.icon;
          return (
            <div key={index} className="flex items-center gap-3">
              <Icon size={20} className="text-gray-500" />
              <span className="font-medium text-gray-600">{detail.label}:</span>
              <span className="text-gray-900">{detail.value}</span>
            </div>
          );
        })}
      </div>
    </div>
  );
};

const QuickActionsCard = () => {
  const actions = [
    {
      icon: Settings,
      title: 'Settings',
      subtitle: 'Manage your account settings',
      onClick: () => {/* Navigate to settings */}
    },
    {
      icon: HelpCircle,
      title: 'Help & Support',
      subtitle: 'Get help and contact support',
      onClick: () => {/* Navigate to help */}
    },
    {
      icon: Info,
      title: 'About',
      subtitle: 'App version and information',
      onClick: () => {/* Navigate to about */}
    }
  ];

  return (
    <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
      <h3 className="text-lg font-semibold text-gray-900 mb-6">Quick Actions</h3>
      <div className="space-y-1">
        {actions.map((action, index) => {
          const Icon = action.icon;
          return (
            <div key={index}>
              <button
                className="w-full flex items-center gap-3 p-3 rounded-lg hover:bg-gray-50 transition-colors text-left"
                onClick={action.onClick}
              >
                <Icon size={24} className="text-blue-600" />
                <div className="flex-1">
                  <div className="font-medium text-gray-900">{action.title}</div>
                  <div className="text-sm text-gray-600">{action.subtitle}</div>
                </div>
                <ChevronRight size={16} className="text-gray-400" />
              </button>
              {index < actions.length - 1 && <hr className="border-gray-100" />}
            </div>
          );
        })}
      </div>
    </div>
  );
};

const ShareDialog = ({ onClose }) => {
  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div className="bg-white rounded-xl p-6 max-w-sm w-full mx-4">
        <h3 className="text-lg font-semibold text-gray-900 mb-4">Share Profile</h3>
        <p className="text-gray-600 mb-6">
          Share your profile with others via link or social media.
        </p>
        <div className="flex gap-3">
          <button
            className="flex-1 px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 transition-colors"
            onClick={onClose}
          >
            Cancel
          </button>
          <button
            className="flex-1 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
            onClick={() => {
              // Handle share
              onClose();
            }}
          >
            Share
          </button>
        </div>
      </div>
    </div>
  );
};

export default ProfileScreen;