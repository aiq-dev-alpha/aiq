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
      className={`inline-flex items-center gap-1.5 px-3 py-1 text-xs rounded-lg bg-cyan-100 text-cyan-800 transition-all ${clickable ? 'cursor-pointer hover:bg-cyan-200' : ''} ${shadow}`}
    >
      {icon}
      <span className="font-medium">{label}</span>
      {onDelete && (
        <button
          onClick={onDelete}
          className="ml-0.5 hover:bg-cyan-200 rounded-full p-0.5"
        >
          ✕
        </button>
      )}
    </span>
  );
};
