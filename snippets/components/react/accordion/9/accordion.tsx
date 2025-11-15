import React, { useState } from 'react';

interface AccordionItem {
  id: string;
  title: string;
  content: string;
  icon?: React.ReactNode;
}

interface AccordionProps {
  items: AccordionItem[];
  variant?: 'default' | 'bordered' | 'shadow';
  className?: string;
}

export default function Accordion({ items, variant = 'default', className = '' }: AccordionProps) {
  const [activeId, setActiveId] = useState<string | null>(null);

  const variantStyles = {
    default: 'bg-white',
    bordered: 'border-2 border-blue-500 rounded-lg overflow-hidden',
    shadow: 'shadow-lg rounded-lg overflow-hidden',
  };

  return (
    <div className={`w-full max-w-3xl mx-auto space-y-3 ${className}`}>
      {items.map((item) => {
        const isActive = activeId === item.id;
        return (
          <div key={item.id} className={`${variantStyles[variant]} transition-all duration-200`}>
            <button
              onClick={() => setActiveId(isActive ? null : item.id)}
              className="w-full px-5 py-4 flex items-center gap-3 text-left hover:bg-blue-50 transition-colors"
            >
              {item.icon && <span className="text-blue-600">{item.icon}</span>}
              <span className="flex-1 font-medium text-gray-800">{item.title}</span>
              <span className={`text-2xl text-blue-600 transition-transform ${isActive ? 'rotate-45' : ''}`}>
                +
              </span>
            </button>
            {isActive && (
              <div className="px-5 py-4 border-t border-gray-200 bg-blue-50 animate-fadeIn">
                <p className="text-gray-700">{item.content}</p>
              </div>
            )}
          </div>
        );
      })}
    </div>
  );
}