import React, { useState, useRef, useEffect, createContext, useContext } from 'react';

interface AccordionContextValue {
  openItems: Set<string>;
  toggleItem: (id: string) => void;
  allowMultiple: boolean;
}

const AccordionContext = createContext<AccordionContextValue | null>(null);

interface AccordionProps {
  allowMultiple?: boolean;
  defaultOpenItems?: string[];
  className?: string;
  children: React.ReactNode;
}

export const Accordion: React.FC<AccordionProps> = ({
  allowMultiple = false,
  defaultOpenItems = [],
  className = '',
  children,
}) => {
  const [openItems, setOpenItems] = useState<Set<string>>(new Set(defaultOpenItems));

  const toggleItem = (id: string) => {
    setOpenItems(prev => {
      const next = new Set(prev);
      if (next.has(id)) {
        next.delete(id);
      } else {
        if (!allowMultiple) {
          next.clear();
        }
        next.add(id);
      }
      return next;
    });
  };

  return (
    <AccordionContext.Provider value={{ openItems, toggleItem, allowMultiple }}>
      <div className={`divide-y divide-gray-200 border border-gray-200 rounded-lg ${className}`}>
        {children}
      </div>
    </AccordionContext.Provider>
  );
};

interface AccordionItemProps {
  id: string;
  title: React.ReactNode;
  children: React.ReactNode;
  icon?: React.ReactNode;
  disabled?: boolean;
}

export const AccordionItem: React.FC<AccordionItemProps> = ({
  id,
  title,
  children,
  icon,
  disabled = false,
}) => {
  const context = useContext(AccordionContext);
  const contentRef = useRef<HTMLDivElement>(null);
  const [height, setHeight] = useState<number>(0);

  if (!context) {
    throw new Error('AccordionItem must be used within Accordion');
  }

  const { openItems, toggleItem } = context;
  const isOpen = openItems.has(id);

  useEffect(() => {
    if (contentRef.current) {
      setHeight(isOpen ? contentRef.current.scrollHeight : 0);
    }
  }, [isOpen]);

  return (
    <div className="accordion-item">
      <button
        className={`
          w-full px-6 py-4 flex items-center justify-between text-left
          transition-colors duration-200 hover:bg-gray-50
          ${disabled ? 'opacity-50 cursor-not-allowed' : 'cursor-pointer'}
          ${isOpen ? 'bg-gray-50' : 'bg-white'}
        `}
        onClick={() => !disabled && toggleItem(id)}
        disabled={disabled}
        aria-expanded={isOpen}
        aria-controls={`accordion-content-${id}`}
      >
        <div className="flex items-center gap-3 flex-1">
          {icon && <span className="text-gray-600">{icon}</span>}
          <span className="font-medium text-gray-900">{title}</span>
        </div>
        <svg
          className={`w-5 h-5 text-gray-600 transition-transform duration-200 ${
            isOpen ? 'transform rotate-180' : ''
          }`}
          fill="none"
          viewBox="0 0 24 24"
          stroke="currentColor"
        >
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
        </svg>
      </button>
      <div
        id={`accordion-content-${id}`}
        className="overflow-hidden transition-all duration-300 ease-in-out"
        style={{ height: `${height}px` }}
      >
        <div ref={contentRef} className="px-6 py-4 text-gray-700 bg-white">
          {children}
        </div>
      </div>
    </div>
  );
};

Accordion.Item = AccordionItem;

export default Accordion;