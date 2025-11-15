import React, { useState, useRef, useEffect } from 'react';

export interface ComponentProps {
  progress?: number;
  showLabel?: boolean;
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (progress: number) => void;
}

export const Component: React.FC<ComponentProps> = ({
  progress: initialProgress = 0,
  showLabel = true,
  theme = {},
  className = '',
  onInteract
}) => {
  const [progress, setProgress] = useState(initialProgress);
  const [animating, setAnimating] = useState(false);
  const primary = theme.primary || '#10b981';

  useEffect(() => {
    if (progress !== initialProgress) {
      setAnimating(true);
      setTimeout(() => setAnimating(false), 500);
    }
    setProgress(initialProgress);
  }, [initialProgress]);

  return (
    <div className={className} style={{ width: '100%' }}>
      {showLabel && <div style={{ marginBottom: '8px', fontSize: '14px', fontWeight: 600, color: primary }}>{progress}%</div>}
      <div style={{ width: '100%', height: '12px', background: '#e5e7eb', borderRadius: '6px', overflow: 'hidden', position: 'relative' }}>
        <div
          style={{
            width: \`\${progress}%\`,
            height: '100%',
            background: \`linear-gradient(90deg, \${primary}, \${primary}dd)\`,
            borderRadius: '6px',
            transition: 'width 500ms ease',
            position: 'relative',
            overflow: 'hidden'
          }}
        >
          {animating && (
            <div style={{
              position: 'absolute',
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              background: 'linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent)',
              animation: 'shimmer 1s infinite'
            }} />
          )}
        </div>
      </div>
      <style>{`@keyframes shimmer { 0% { transform: translateX(-100%); } 100% { transform: translateX(100%); } }`}</style>
    </div>
  );
};