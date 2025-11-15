// Variant 29: Task card with checkbox
import React, { useState, useEffect } from 'react';
export interface CardProps { theme?: { primary?: string; background?: string; text?: string }; className?: string; onHover?: (isHovered: boolean) => void; }
export const Card: React.FC<CardProps> = ({ theme = {}, className = '', onHover }) => {
  const [isVisible, setIsVisible] = useState(false);
  const [isHovered, setIsHovered] = useState(false);
  const [tasks, setTasks] = useState([
    { id: 1, text: 'Review pull requests', done: true },
    { id: 2, text: 'Update documentation', done: true },
    { id: 3, text: 'Deploy to production', done: false },
    { id: 4, text: 'Team standup meeting', done: false }
  ]);
  useEffect(() => { setIsVisible(true); }, []);
  return (
    <div className={className} style={{ opacity: isVisible ? 1 : 0, transform: isVisible ? 'translateY(0)' : 'translateY(20px)', transition: 'all 300ms ease', padding: '24px', backgroundColor: theme.background || '#ffffff', borderRadius: '16px', boxShadow: isHovered ? '0 12px 24px rgba(0,0,0,0.12)' : '0 4px 12px rgba(0,0,0,0.06)', cursor: 'pointer', width: '320px' }} onMouseEnter={() => { setIsHovered(true); onHover?.(true); }} onMouseLeave={() => { setIsHovered(false); onHover?.(false); }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '20px' }}>
        <h3 style={{ fontSize: '18px', fontWeight: 'bold', color: theme.text || '#111827' }}>Today's Tasks</h3>
        <div style={{ fontSize: '13px', color: '#9ca3af' }}>{tasks.filter(t => t.done).length}/{tasks.length}</div>
      </div>
      {tasks.map((task, i) => (
        <div key={task.id} style={{ display: 'flex', alignItems: 'center', gap: '12px', padding: '12px', marginBottom: i === tasks.length - 1 ? 0 : '8px', backgroundColor: '#f9fafb', borderRadius: '8px', transition: 'all 200ms ease' }}
          onClick={(e) => { e.stopPropagation(); setTasks(tasks.map(t => t.id === task.id ? { ...t, done: !t.done } : t)); }}>
          <div style={{ width: '20px', height: '20px', borderRadius: '6px', border: `2px solid ${task.done ? (theme.primary || '#3b82f6') : '#d1d5db'}`, backgroundColor: task.done ? (theme.primary || '#3b82f6') : 'transparent', display: 'flex', alignItems: 'center', justifyContent: 'center', color: '#ffffff', fontSize: '12px', flexShrink: 0 }}>
            {task.done && '✓'}
          </div>
          <span style={{ flex: 1, fontSize: '14px', color: task.done ? '#9ca3af' : (theme.text || '#111827'), textDecoration: task.done ? 'line-through' : 'none' }}>{task.text}</span>
        </div>
      ))}
    </div>
  );
};
