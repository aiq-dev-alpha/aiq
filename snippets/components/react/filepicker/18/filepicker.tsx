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
  const primary = theme.primary || '#10b981';
  
  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const selectedFiles = e.target.files;
    setFiles(selectedFiles);
    onChange?.(selectedFiles);
  };
  
  return (
    <div className={className} style={{ width: '100%', maxWidth: '450px' }}>
      <label
        style={{
          display: 'flex',
          flexDirection: 'column',
          alignItems: 'center',
          gap: '24px',
          padding: '36px',
          border: `3px dashed ${primary}`,
          borderRadius: '18px',
          cursor: 'pointer',
          backgroundColor: '#ecfdf5',
          transition: 'all 0.4s cubic-bezier(0.4, 0, 0.2, 1)'
        }}
        onMouseEnter={(e) => e.currentTarget.style.backgroundColor = '#d1fae5'}
        onMouseLeave={(e) => e.currentTarget.style.backgroundColor = '#ecfdf5'}
      >
        <span style={{ fontSize: '18px' }}>📁</span>
        <span style={{ color: primary, fontWeight: '800', fontSize: '18px' }}>
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