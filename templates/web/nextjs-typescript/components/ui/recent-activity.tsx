'use client';

const recentActivities = [
  {
    id: 1,
    user: 'John Doe',
    action: 'signed up',
    time: '2 minutes ago',
    avatar: '/avatars/01.png',
  },
  {
    id: 2,
    user: 'Jane Smith',
    action: 'made a purchase',
    time: '5 minutes ago',
    avatar: '/avatars/02.png',
  },
  {
    id: 3,
    user: 'Bob Johnson',
    action: 'updated profile',
    time: '10 minutes ago',
    avatar: '/avatars/03.png',
  },
  {
    id: 4,
    user: 'Alice Brown',
    action: 'left a review',
    time: '15 minutes ago',
    avatar: '/avatars/04.png',
  },
];

export function RecentActivity() {
  return (
    <div className="space-y-8">
      {recentActivities.map((activity) => (
        <div key={activity.id} className="flex items-center">
          <div className="h-8 w-8 rounded-full bg-gradient-to-r from-blue-500 to-purple-600"></div>
          <div className="ml-4 space-y-1">
            <p className="text-sm font-medium leading-none">{activity.user}</p>
            <p className="text-sm text-muted-foreground">
              {activity.action} • {activity.time}
            </p>
          </div>
        </div>
      ))}
    </div>
  );
}