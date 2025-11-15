import React from 'react';

interface ChipProps {
  label: string;
  onDelete?: () => void;
  clickable?: boolean;
  onClick?: () => void;
  icon?: React.ReactNode;
}

export const Chip: React.FC<ChipProps> = ({
  label,
  onDelete,
  clickable = false,
  onClick,
  icon
}) => {
  return (
    <span
      onClick={clickable ? onClick : undefined}
      className={`inline-flex items-center gap-1.5 px-2 py-1 text-xs rounded-md bg-pink-100 text-pink-800 transition-all ${clickable ? 'cursor-pointer hover:bg-pink-200' : ''} ${shadow}`}
    >
      {icon}
      <span className="font-medium">{label}</span>
      {onDelete && (
        <button
          onClick={onDelete}
          className="ml-0.5 hover:bg-pink-200 rounded-full p-0.5"
        >
          ✕
        </button>
      )}
    </span>
  );
};
