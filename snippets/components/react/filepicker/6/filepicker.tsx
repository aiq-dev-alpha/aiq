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
  const primary = theme.primary || '#3b82f6';
  
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
          gap: '12px',
          padding: '32px',
          border: `2px dashed ${primary}`,
          borderRadius: '6px',
          cursor: 'pointer',
          backgroundColor: '#eff6ff',
          transition: 'all 0.2s'
        }}
        onMouseEnter={(e) => e.currentTarget.style.backgroundColor = '#dbeafe'}
        onMouseLeave={(e) => e.currentTarget.style.backgroundColor = '#eff6ff'}
      >
        <span style={{ fontSize: '48px' }}>📁</span>
        <span style={{ color: primary, fontWeight: '500', fontSize: '14px' }}>
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