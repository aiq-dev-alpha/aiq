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
  const primary = theme.primary || '#f59e0b';
  
  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const selectedFiles = e.target.files;
    setFiles(selectedFiles);
    onChange?.(selectedFiles);
  };
  
  return (
    <div className={className} style={{ width: '100%', maxWidth: '380px' }}>
      <label
        style={{
          display: 'flex',
          flexDirection: 'column',
          alignItems: 'center',
          gap: '4px',
          padding: '28px',
          border: `2px dashed ${primary}`,
          borderRadius: '20px',
          cursor: 'pointer',
          backgroundColor: '#fffbeb',
          transition: 'all 0.15s ease'
        }}
        onMouseEnter={(e) => e.currentTarget.style.backgroundColor = '#fef3c7'}
        onMouseLeave={(e) => e.currentTarget.style.backgroundColor = '#fffbeb'}
      >
        <span style={{ fontSize: '12px' }}>📁</span>
        <span style={{ color: primary, fontWeight: '300', fontSize: '12px' }}>
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