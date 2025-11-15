import React from 'react';
interface ChipProps {
  className?: string;
  label: string;
  avatarSrc?: string;
  onDelete?: () => void;
  variant?: 'filled' | 'outlined';
}
export const Chip: React.FC<ChipProps> = ({
  label,
  avatarSrc,
  onDelete,
  variant = 'filled'
}) => {
  const variantClasses = {
    filled: 'bg-blue-100 text-blue-800 border-blue-200',
    outlined: 'bg-white text-blue-700 border-blue-500 border-2'
  };
  return (
    <div className={`inline-flex items-center gap-2 pl-1 pr-3 py-1 rounded-full text-sm font-medium ${variantClasses[variant]}`}>
      {avatarSrc ? (
        <img src={avatarSrc} alt={label} className="w-6 h-6 rounded-full object-cover" />
      ) : (
        <div className="w-6 h-6 rounded-full bg-blue-500 text-white flex items-center justify-center text-xs font-bold">
          {label[0]?.toUpperCase()}
        </div>
      )}
      <span>{label}</span>
      {onDelete && (
        <button
          onClick={onDelete}
          className="ml-1 hover:bg-blue-200 rounded-full p-0.5 transition-colors focus:outline-none"
        >
          <svg className="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
            <path fillRule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clipRule="evenodd" />
          </svg>
        </button>
      )}
    </div>
  );
};

export default Chip;