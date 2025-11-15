import React from 'react';

interface AvatarProps {
  src?: string;
  alt?: string;
  status?: 'online' | 'offline' | 'away' | 'busy';
  size?: number;
  className?: string;
}

const statusColors = {
  online: 'bg-green-500',
  offline: 'bg-gray-400',
  away: 'bg-yellow-500',
  busy: 'bg-red-500',
};

export const Avatar: React.FC<AvatarProps> = ({
  src,
  alt = 'Avatar',
  status,
  size = 48,
  className = '',
}) => {
  const [hasError, setHasError] = React.useState(false);

  return (
    <div className={`relative inline-block ${className}`}>
      <div
        className="rounded-full bg-gray-300 overflow-hidden"
        style={{ width: size, height: size }}
      >
        {src && !hasError ? (
          <img
            src={src}
            alt={alt}
            onError={() => setHasError(true)}
            className="w-full h-full object-cover"
            loading="lazy"
          />
        ) : (
          <div className="w-full h-full flex items-center justify-center bg-gradient-to-br from-blue-400 to-purple-500">
            <span className="text-white font-bold" style={{ fontSize: size / 2.5 }}>
              {alt.charAt(0).toUpperCase()}
            </span>
          </div>
        )}
      </div>
      {status && (
        <span
          className={`absolute bottom-0 right-0 block rounded-full border-2 border-white ${statusColors[status]}`}
          style={{ width: size / 4, height: size / 4 }}
          aria-label={`Status: ${status}`}
        />
      )}
    </div>
  );
};

export default Avatar;