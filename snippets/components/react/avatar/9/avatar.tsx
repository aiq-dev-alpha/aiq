import React from 'react';
interface AvatarProps {
  src?: string;
  alt?: string;
  presence?: 'online' | 'away' | 'busy' | 'typing';
  customStatus?: string;
  size?: number;
}
export const Avatar: React.FC<AvatarProps> = ({
  src,
  alt = 'User',
  presence = 'online',
  customStatus,
  size = 64
}) => {
  const presenceConfig = {
    online: { color: 'bg-green-500', icon: null },
    away: { color: 'bg-yellow-500', icon: null },
    busy: { color: 'bg-red-500', icon: null },
    typing: { color: 'bg-blue-500', icon: '...' }
  };
  const config = presenceConfig[presence];
  return (
    <div className="relative inline-block" style={{ width: size, height: size }}>
      <div className="w-full h-full rounded-full overflow-hidden bg-gradient-to-br from-rose-400 to-pink-600 flex items-center justify-center shadow-md ring-2 ring-white">
        {src ? (
          <img src={src} alt={alt} className="w-full h-full object-cover" />
        ) : (
          <span className="text-white font-bold" style={{ fontSize: size / 3 }}>{alt[0]?.toUpperCase()}</span>
        )}
      </div>
      <div className={`absolute bottom-0 right-0 ${config.color} rounded-full border-2 border-white flex items-center justify-center ${presence === 'typing' ? 'animate-pulse' : ''}`} style={{ width: size / 4, height: size / 4 }}>
        {config.icon && <span className="text-white text-xs font-bold">{config.icon}</span>}
      </div>
      {customStatus && (
        <div className="absolute -bottom-6 left-1/2 transform -translate-x-1/2 bg-gray-800 text-white px-2 py-0.5 rounded text-xs whitespace-nowrap">
          {customStatus}
        </div>
      )}
    </div>
  );
};
