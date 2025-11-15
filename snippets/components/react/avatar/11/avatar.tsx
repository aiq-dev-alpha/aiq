import React from 'react';
interface AvatarProps {
  className?: string;
  src?: string;
  alt?: string;
  activityLevel?: number;
  size?: number;
}
export const Avatar: React.FC<AvatarProps> = ({
  src,
  alt = 'User',
  activityLevel = 0,
  size = 80
}) => {
  const strokeColor = activityLevel > 70 ? '#10b981' : activityLevel > 30 ? '#f59e0b' : '#ef4444';
  const circumference = 2 * Math.PI * 36;
  const strokeDashoffset = circumference - (activityLevel / 100) * circumference;
  return (
    <div className="relative inline-block" style={{ width: size, height: size }}>
      <svg className="absolute inset-0 -rotate-90" viewBox="0 0 80 80">
        <circle
          cx="40"
          cy="40"
          r="36"
          fill="none"
          stroke="#e5e7eb"
          strokeWidth="4"
        />
        <circle
          cx="40"
          cy="40"
          r="36"
          fill="none"
          stroke={strokeColor}
          strokeWidth="4"
          strokeDasharray={circumference}
          strokeDashoffset={strokeDashoffset}
          className="transition-all duration-500"
        />
      </svg>
      <div className="absolute inset-3 rounded-full overflow-hidden bg-gradient-to-tr from-indigo-500 to-purple-600 flex items-center justify-center">
        {src ? (
          <img src={src} alt={alt} className="w-full h-full object-cover" />
        ) : (
          <span className="text-white font-bold text-lg">{alt[0]?.toUpperCase()}</span>
        )}
      </div>
    </div>
  );
};

export default Avatar;