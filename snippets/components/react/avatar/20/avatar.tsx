import React from 'react';
interface AvatarProps {
  className?: string;
  src?: string;
  alt?: string;
  verified?: boolean;
  size?: number;
}
export const Avatar: React.FC<AvatarProps> = ({
  src,
  alt = 'User',
  verified = false,
  size = 72
}) => {
  return (
    <div className="relative inline-block" style={{ width: size + 12, height: size + 12 }}>
      <div className="absolute inset-0 rounded-full bg-gradient-to-r from-pink-500 to-purple-500 p-1">
        <div className="w-full h-full rounded-full bg-white p-1">
          <div className="w-full h-full rounded-full overflow-hidden bg-gradient-to-br from-pink-400 to-purple-600 flex items-center justify-center shadow-inner">
            {src ? (
              <img src={src} alt={alt} className="w-full h-full object-cover" />
            ) : (
              <span className="text-white font-bold text-xl">{alt[0]?.toUpperCase()}</span>
            )}
          </div>
        </div>
      </div>
      {verified && (
        <div className="absolute bottom-0 right-0 bg-blue-500 rounded-full p-1 shadow-md">
          <svg className="w-4 h-4 text-white" fill="currentColor" viewBox="0 0 20 20">
            <path fillRule="evenodd" d="M6.267 3.455a3.066 3.066 0 001.745-.723 3.066 3.066 0 013.976 0 3.066 3.066 0 001.745.723 3.066 3.066 0 012.812 2.812c.051.643.304 1.254.723 1.745a3.066 3.066 0 010 3.976 3.066 3.066 0 00-.723 1.745 3.066 3.066 0 01-2.812 2.812 3.066 3.066 0 00-1.745.723 3.066 3.066 0 01-3.976 0 3.066 3.066 0 00-1.745-.723 3.066 3.066 0 01-2.812-2.812 3.066 3.066 0 00-.723-1.745 3.066 3.066 0 010-3.976 3.066 3.066 0 00.723-1.745 3.066 3.066 0 012.812-2.812zm7.44 5.252a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
          </svg>
        </div>
      )}
    </div>
  );
};

export default Avatar;