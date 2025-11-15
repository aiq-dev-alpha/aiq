import React from 'react';
interface AvatarProps {
  className?: string;
  src?: string;
  name?: string;
  size?: number;
  shape?: 'circle' | 'square' | 'rounded';
}
export const Avatar: React.FC<AvatarProps> = ({ src, name = 'User', size = 48, shape = 'circle' }) => {
  const shapeClasses = {
    circle: 'rounded-full',
    square: 'rounded-none',
    rounded: 'rounded-lg'
  };
  const initials = name.split(' ').map(n => n[0]).join('').toUpperCase().slice(0, 2);
  return (
    <div
      className={`inline-flex items-center justify-center bg-gradient-to-tr from-violet-500 to-fuchsia-500 text-white font-bold ${shapeClasses[shape]}`}
      style={{ width: size, height: size, fontSize: size / 2.5 }}
    >
      {src ? <img src={src} alt={name} className={`w-full h-full object-cover ${shapeClasses[shape]}`} /> : initials}
    </div>
  );
};

export default Avatar;