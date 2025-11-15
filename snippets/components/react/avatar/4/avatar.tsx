import React from 'react';
interface AvatarGroupProps {
  className?: string;
  avatars: Array<{ src?: string; alt: string }>;
  max?: number;
  size?: number;
}
export const AvatarGroup: React.FC<AvatarGroupProps> = ({
  avatars,
  max = 4,
  size = 40
}) => {
  const visible = avatars.slice(0, max);
  const remaining = avatars.length - max;
  return (
    <div className="flex items-center">
      {visible.map((avatar, i) => (
        <div
          key={i}
          className="rounded-full border-2 border-white overflow-hidden bg-gradient-to-br from-cyan-400 to-blue-500 flex items-center justify-center text-white font-semibold shadow-md hover:scale-110 hover:z-10 transition-transform"
          style={{
            width: size,
            height: size,
            marginLeft: i > 0 ? -size / 3 : 0,
            zIndex: visible.length - i
          }}
        >
          {avatar.src ? (
            <img src={avatar.src} alt={avatar.alt} className="w-full h-full object-cover" />
          ) : (
            <span>{avatar.alt[0]?.toUpperCase()}</span>
          )}
        </div>
      ))}
      {remaining > 0 && (
        <div
          className="rounded-full border-2 border-white bg-gray-200 flex items-center justify-center text-gray-600 font-semibold shadow-md"
          style={{
            width: size,
            height: size,
            marginLeft: -size / 3,
            zIndex: 0
          }}
        >
          +{remaining}
        </div>
      )}
    </div>
  );
};

export default AvatarGroup;