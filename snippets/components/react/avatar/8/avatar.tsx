import React from 'react';
interface AvatarProps {
  src?: string;
  alt?: string;
  size?: number;
  badge?: string;
}
export const Avatar: React.FC<AvatarProps> = ({
  src,
  alt = 'User',
  size = 64,
  badge
}) => {
  const clipPath = 'polygon(30% 0%, 70% 0%, 100% 30%, 100% 70%, 70% 100%, 30% 100%, 0% 70%, 0% 30%)';
  return (
    <div className="relative inline-block" style={{ width: size, height: size }}>
      <div
        className="w-full h-full bg-gradient-to-br from-violet-500 to-purple-600 flex items-center justify-center overflow-hidden shadow-lg"
        style={{ clipPath }}
      >
        {src ? (
          <img src={src} alt={alt} className="w-full h-full object-cover" />
        ) : (
          <span className="text-white font-bold text-xl">{alt[0]?.toUpperCase()}</span>
        )}
      </div>
      {badge && (
        <span className="absolute -top-1 -right-1 bg-red-500 text-white text-xs rounded-full px-2 py-0.5 font-semibold shadow">
          {badge}
        </span>
      )}
    </div>
  );
};
