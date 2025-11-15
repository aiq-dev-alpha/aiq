import React from 'react';

interface AvatarProps {
  src?: string;
  alt?: string;
  name?: string;
  size?: 'sm' | 'md' | 'lg' | 'xl';
  className?: string;
}

const sizeClasses = {
  sm: 'w-8 h-8 text-xs',
  md: 'w-12 h-12 text-sm',
  lg: 'w-16 h-16 text-base',
  xl: 'w-24 h-24 text-xl',
};

export const Avatar: React.FC<AvatarProps> = ({
  src,
  alt,
  name = '',
  size = 'md',
  className = '',
}) => {
  const [imageError, setImageError] = React.useState(false);
  
  const getInitials = (name: string): string => {
    return name
      .split(' ')
      .map(part => part[0])
      .join('')
      .toUpperCase()
      .slice(0, 2);
  };

  const showImage = src && !imageError;
  
  return (
    <div
      className={`relative inline-flex items-center justify-center rounded-full ring-2 ring-pink-500 bg-gray-200 overflow-hidden ${sizeClasses[size]} ${className}`}
      role="img"
      aria-label={alt || name}
    >
      {showImage ? (
        <img
          src={src}
          alt={alt || name}
          onError={() => setImageError(true)}
          className="w-full h-full object-cover"
        />
      ) : (
        <span className="font-semibold text-gray-700">
          {getInitials(name)}
        </span>
      )}
    </div>
  );
};

export default Avatar;