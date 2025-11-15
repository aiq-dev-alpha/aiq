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
    <div className={className} style={{ width: '100%', maxWidth: '410px' }}>
      <label
        style={{
          display: 'flex',
          flexDirection: 'column',
          alignItems: 'center',
          gap: '2px',
          padding: '35px',
          border: `2px dashed ${primary}`,
          borderRadius: '19px',
          cursor: 'pointer',
          backgroundColor: '#fdf2f8',
          transition: 'all 0.3s ease'
        }}
        onMouseEnter={(e) => e.currentTarget.style.backgroundColor = '#fce7f3'}
        onMouseLeave={(e) => e.currentTarget.style.backgroundColor = '#fdf2f8'}
      >
        <span style={{ fontSize: '20px' }}>📁</span>
        <span style={{ color: primary, fontWeight: '800', fontSize: '20px' }}>
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