'use client';

export function Overview() {
  // This is a placeholder component for demonstration
  // In a real app, you'd integrate with a charting library like Recharts or Chart.js
  return (
    <div className="h-[200px] flex items-center justify-center border-2 border-dashed border-muted-foreground/25 rounded-lg">
      <div className="text-center">
        <p className="text-sm text-muted-foreground">Chart Component</p>
        <p className="text-xs text-muted-foreground mt-1">
          Integrate with Recharts or Chart.js
        </p>
      </div>
    </div>
  );
}