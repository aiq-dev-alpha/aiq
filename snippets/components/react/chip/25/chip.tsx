import React from 'react';;

export interface ComponentProps {
  label?: string;
  pulse?: boolean;
  theme?: { primary?: string; background?: string; text?: string };
  className?: string;
}

export const Component: React.FC<ComponentProps> = ({
  label = 'Live',
  pulse = true,
  theme = {},
  className = ''
}) => {
  const primary = theme.primary || '#ef4444';

  return (
  <div
  className={className}
  style={{
  display: 'inline-flex',
  alignItems: 'center',
  gap: '8px',
  padding: '6px 14px',
  backgroundColor: `${primary}20`,
  borderRadius: '20px',
  fontSize: '13px',
  color: primary,
  fontWeight: '600',
  position: 'relative'
  }}
  >
  {pulse && (
  <>
  <div
  style={{
  width: '8px',
  height: '8px',
  borderRadius: '50%',
  backgroundColor: primary,
  position: 'relative'
  }}
  />
  <style>
  {`
  @keyframes pulse {
  0%, 100% { opacity: 1; transform: scale(1); }
  50% { opacity: 0.5; transform: scale(1.2); }
  }
  @keyframes pulse::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  border-radius: 50%;
  background: inherit;
  animation: pulse 2s ease-in-out infinite;
  }
  `}
  </style>
  </>
  )}
  <span>{label}</span>
  </div>
  );
};