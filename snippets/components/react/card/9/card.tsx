import React from 'react';

interface ProfileCardProps {
  avatar: string;
  name: string;
  role: string;
  bio?: string;
  stats?: Array<{ label: string; value: string | number }>;
  social?: Array<{ icon: React.ReactNode; url: string }>;
  actions?: Array<{ label: string; onClick: () => void; variant?: 'primary' | 'secondary' }>;
}

export const ProfileCard: React.FC<ProfileCardProps> = ({
  avatar,
  name,
  role,
  bio,
  stats,
  social,
  actions
}) => {
  return (
    <div className="bg-white rounded-full shadow-lg overflow-hidden max-w-sm">
      <div className="h-32 bg-gradient-to-r from-green-500 to-green-500" />
      
      <div className="px-6 pb-6">
        <div className="relative -mt-16 mb-4">
          <img
            src={avatar}
            alt={name}
            className="w-32 h-32 rounded-full border-4 border-white shadow-lg object-cover mx-auto"
          />
        </div>
        
        <div className="text-center mb-4">
          <h2 className="text-2xl font-bold text-gray-900 mb-1">{name}</h2>
          <p className="text-green-600 font-medium">{role}</p>
        </div>
        
        {bio && (
          <p className="text-gray-600 text-center mb-4 leading-relaxed">{bio}</p>
        )}
        
        {stats && stats.length > 0 && (
          <div className="flex justify-around py-4 border-y border-gray-200 mb-4">
            {stats.map((stat, index) => (
              <div key={index} className="text-center">
                <div className="text-2xl font-bold text-gray-900">{stat.value}</div>
                <div className="text-sm text-gray-500">{stat.label}</div>
              </div>
            ))}
          </div>
        )}
        
        {social && social.length > 0 && (
          <div className="flex justify-center gap-3 mb-4">
            {social.map((item, index) => (
              <a
                key={index}
                href={item.url}
                className="p-2 bg-gray-100 hover:bg-green-100 rounded-full transition-colors"
                target="_blank"
                rel="noopener noreferrer"
              >
                {item.icon}
              </a>
            ))}
          </div>
        )}
        
        {actions && actions.length > 0 && (
          <div className="flex gap-2">
            {actions.map((action, index) => (
              <button
                key={index}
                onClick={action.onClick}
                className={`flex-1 py-2.5 rounded-full font-medium transition-colors ${
                  action.variant === 'primary'
                    ? 'bg-green-600 hover:bg-green-700 text-white'
                    : 'bg-gray-200 hover:bg-gray-300 text-gray-700'
                }`}
              >
                {action.label}
              </button>
            ))}
          </div>
        )}
      </div>
    </div>
  );
};

export default ProfileCard;