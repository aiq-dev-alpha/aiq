import React, { useState } from 'react';
import { Shield, Bell, Camera, Mic, MapPin, Info } from 'lucide-react';

const PermissionsScreen = ({ onContinue, onSkip }) => {
  const [permissions, setPermissions] = useState([
    {
      id: 'notifications',
      icon: Bell,
      title: 'Notifications',
      description: 'Get notified about new challenges and your progress',
      isRequired: false,
      isGranted: false
    },
    {
      id: 'camera',
      icon: Camera,
      title: 'Camera',
      description: 'Take photos for your profile and share achievements',
      isRequired: false,
      isGranted: false
    },
    {
      id: 'microphone',
      icon: Mic,
      title: 'Microphone',
      description: 'Use voice commands for hands-free navigation',
      isRequired: false,
      isGranted: false
    },
    {
      id: 'location',
      icon: MapPin,
      title: 'Location',
      description: 'Find nearby users and location-based challenges',
      isRequired: false,
      isGranted: false
    }
  ]);

  const togglePermission = (id) => {
    setPermissions(perms =>
      perms.map(perm =>
        perm.id === id ? { ...perm, isGranted: !perm.isGranted } : perm
      )
    );
  };

  return (
    <div className="min-h-screen bg-white p-6">
      <div className="pt-8">
        {/* Header */}
        <div className="flex items-center mb-8">
          <div className="w-12 h-12 bg-indigo-50 rounded-xl flex items-center justify-center mr-4">
            <Shield className="w-6 h-6 text-indigo-500" />
          </div>
          <div>
            <h1 className="text-2xl font-bold text-gray-900">Permissions</h1>
            <p className="text-gray-600 text-sm">Help us personalize your experience</p>
          </div>
        </div>

        <p className="text-gray-600 mb-8 leading-relaxed">
          We'd like your permission to access the following features to enhance your AIQ experience:
        </p>

        {/* Info Banner */}
        <div className="bg-gray-50 rounded-xl p-3 mb-8 flex items-center">
          <Info className="w-4 h-4 text-gray-500 mr-2" />
          <p className="text-sm text-gray-600">
            Select permissions to enable enhanced features
          </p>
        </div>

        {/* Permissions List */}
        <div className="space-y-4 mb-8">
          {permissions.map(permission => {
            const IconComponent = permission.icon;
            return (
              <div
                key={permission.id}
                className="bg-white border border-gray-200 rounded-2xl p-4 shadow-sm"
              >
                <div className="flex items-center">
                  <div className={`w-12 h-12 rounded-xl flex items-center justify-center mr-4 ${
                    permission.isGranted
                      ? 'bg-green-50'
                      : 'bg-gray-50'
                  }`}>
                    <IconComponent
                      className={`w-6 h-6 ${
                        permission.isGranted ? 'text-green-500' : 'text-gray-400'
                      }`}
                    />
                  </div>

                  <div className="flex-1">
                    <div className="flex items-center mb-1">
                      <h3 className="font-semibold text-gray-900">
                        {permission.title}
                      </h3>
                      {permission.isRequired && (
                        <span className="ml-2 bg-red-500 text-white text-xs px-2 py-0.5 rounded-full">
                          Required
                        </span>
                      )}
                    </div>
                    <p className="text-sm text-gray-600 leading-relaxed">
                      {permission.description}
                    </p>
                  </div>

                  <button
                    onClick={() => togglePermission(permission.id)}
                    className={`px-3 py-2 rounded-lg text-sm font-semibold transition-colors ${
                      permission.isGranted
                        ? 'bg-green-500 text-white'
                        : 'bg-indigo-500 text-white'
                    }`}
                  >
                    {permission.isGranted ? 'Granted' : 'Allow'}
                  </button>
                </div>
              </div>
            );
          })}
        </div>

        {/* Action Buttons */}
        <div className="space-y-3">
          <button
            onClick={onContinue}
            className="w-full bg-indigo-500 text-white py-4 px-6 rounded-2xl font-semibold hover:bg-indigo-600 transition-colors"
          >
            Continue
          </button>

          <button
            onClick={onSkip}
            className="w-full text-gray-500 py-3 font-medium hover:text-gray-700 transition-colors"
          >
            Skip for now
          </button>
        </div>
      </div>
    </div>
  );
};

export default PermissionsScreen;