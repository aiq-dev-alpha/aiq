import React from 'react';

interface Task {
  id: string;
  title: string;
  description: string;
}

const columns = {
  todo: { title: 'To Do', tasks: [{ id: '1', title: 'Design mockups', description: 'Create initial UI designs' }] },
  inProgress: { title: 'In Progress', tasks: [{ id: '2', title: 'API integration', description: 'Connect frontend to backend' }] },
  done: { title: 'Done', tasks: [{ id: '3', title: 'Setup project', description: 'Initialize repository' }] }
};

export const KanbanBoardScreen: React.FC = () => {
  return (
    <div style={{ minHeight: '100vh', backgroundColor: '#f9fafb', padding: '2rem', fontFamily: 'system-ui, sans-serif' }}>
      <h1 style={{ fontSize: '2rem', fontWeight: 700, marginBottom: '2rem' }}>Project Board</h1>
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: '1.5rem' }}>
        {Object.entries(columns).map(([key, column]) => (
          <div key={key}>
            <div style={{ backgroundColor: '#fff', borderRadius: '0.75rem', padding: '1rem', boxShadow: '0 1px 3px rgba(0,0,0,0.1)' }}>
              <h2 style={{ fontSize: '1.125rem', fontWeight: 600, marginBottom: '1rem' }}>{column.title}</h2>
              {column.tasks.map(task => (
                <div
                  key={task.id}
                  style={{
                    backgroundColor: '#f9fafb',
                    borderRadius: '0.5rem',
                    padding: '1rem',
                    marginBottom: '0.75rem',
                    cursor: 'grab'
                  }}
                >
                  <h3 style={{ fontWeight: 600, marginBottom: '0.5rem' }}>{task.title}</h3>
                  <p style={{ fontSize: '0.875rem', color: '#6b7280' }}>{task.description}</p>
                </div>
              ))}
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};
