import { useQuery } from '@tanstack/react-query'
import { postsService } from '@services/api'

export default function DashboardPage() {
  const { data: posts, isLoading, error } = useQuery({
    queryKey: ['posts'],
    queryFn: () => postsService.getAll({ limit: 10 }),
  })

  return (
    <div>
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-gray-900">Dashboard</h1>
        <p className="mt-2 text-gray-600">Welcome to your personal dashboard</p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
        <div className="bg-white p-6 rounded-lg shadow-md">
          <h3 className="text-lg font-semibold text-gray-900 mb-2">Total Posts</h3>
          <p className="text-3xl font-bold text-blue-600">{posts?.data?.length || 0}</p>
        </div>
        <div className="bg-white p-6 rounded-lg shadow-md">
          <h3 className="text-lg font-semibold text-gray-900 mb-2">Active Users</h3>
          <p className="text-3xl font-bold text-green-600">1,234</p>
        </div>
        <div className="bg-white p-6 rounded-lg shadow-md">
          <h3 className="text-lg font-semibold text-gray-900 mb-2">Total Views</h3>
          <p className="text-3xl font-bold text-purple-600">45.6k</p>
        </div>
      </div>

      <div className="bg-white rounded-lg shadow-md">
        <div className="px-6 py-4 border-b border-gray-200">
          <h2 className="text-xl font-semibold text-gray-900">Recent Posts</h2>
        </div>
        <div className="p-6">
          {isLoading && <p className="text-gray-600">Loading posts...</p>}
          {error && <p className="text-red-600">Failed to load posts</p>}
          {posts?.data && posts.data.length === 0 && (
            <p className="text-gray-600">No posts yet</p>
          )}
          {posts?.data && posts.data.length > 0 && (
            <div className="space-y-4">
              {posts.data.map((post: any) => (
                <div key={post.id} className="border-l-4 border-blue-500 pl-4">
                  <h3 className="font-semibold text-gray-900">{post.title}</h3>
                  <p className="text-gray-600 mt-1">{post.content}</p>
                  <p className="text-sm text-gray-500 mt-2">
                    Posted on {new Date(post.createdAt).toLocaleDateString()}
                  </p>
                </div>
              ))}
            </div>
          )}
        </div>
      </div>
    </div>
  )
}