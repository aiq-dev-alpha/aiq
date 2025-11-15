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
      className={`inline-flex items-center gap-1.5 px-2.5 py-1.5 text-sm rounded bg-indigo-100 text-indigo-800 transition-transform ${clickable ? 'cursor-pointer hover:bg-indigo-200' : ''} ${shadow}`}
    >
      {icon}
      <span className="font-medium">{label}</span>
      {onDelete && (
        <button
          onClick={onDelete}
          className="ml-0.5 hover:bg-indigo-200 rounded-full p-0.5"
        >
          ✕
        </button>
      )}
    </span>
  );
};
