import React, { useState } from 'react';

export interface ComponentProps {
  onChange?: (files: FileList | null) => void;
  theme?: { primary?: string };
  className?: string;
  accept?: string;
  multiple?: boolean;
}

export const Component: React.FC<ComponentProps> = ({
  onChange,
  theme = {},
  className = '',
  accept,
  multiple = false
}) => {
  const [files, setFiles] = useState<FileList | null>(null);
  const primary = theme.primary || '#ec4899';
  
  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const selectedFiles = e.target.files;
    setFiles(selectedFiles);
    onChange?.(selectedFiles);
  };
  
  return (
    <div className={className} style={{ width: '100%', maxWidth: '400px' }}>
      <label
        style={{
          display: 'flex',
          flexDirection: 'column',
          alignItems: 'center',
          gap: '20px',
          padding: '32px',
          border: `2px dashed ${primary}`,
          borderRadius: '22px',
          cursor: 'pointer',
          backgroundColor: '#fdf2f8',
          transition: 'all 0.3s ease-in-out'
        }}
        onMouseEnter={(e) => e.currentTarget.style.backgroundColor = '#fdf2f8'}
        onMouseLeave={(e) => e.currentTarget.style.backgroundColor = '#fdf2f8'}
      >
        <span style={{ fontSize: '18px' }}>📁</span>
        <span style={{ color: primary, fontWeight: '900', fontSize: '18px' }}>
          {files ? `${files.length} file(s) selected` : 'Click to upload'}
        </span>
        <input
          type="file"
          accept={accept}
          multiple={multiple}
          onChange={handleChange}
          style={{ display: 'none' }}
        />
      </label>
    </div>
  );
};