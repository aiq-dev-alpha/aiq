export default function HomePage() {
  return (
    <div className="max-w-7xl mx-auto">
      <div className="text-center py-20">
        <h1 className="text-4xl font-bold text-gray-900 mb-4">
          Welcome to {{PROJECT_NAME}}
        </h1>
        <p className="text-xl text-gray-600 mb-8">
          A modern React application built with Vite, TypeScript, and Tailwind CSS
        </p>
        <div className="flex justify-center gap-4">
          <a
            href="/login"
            className="px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
          >
            Get Started
          </a>
          <a
            href="https://github.com"
            className="px-6 py-3 bg-gray-200 text-gray-900 rounded-lg hover:bg-gray-300 transition-colors"
          >
            View on GitHub
          </a>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-8 mt-16">
        <div className="bg-white p-6 rounded-lg shadow-md">
          <h3 className="text-lg font-semibold mb-2">Fast Refresh</h3>
          <p className="text-gray-600">
            Experience instant feedback with Vite's lightning-fast Hot Module Replacement.
          </p>
        </div>
        <div className="bg-white p-6 rounded-lg shadow-md">
          <h3 className="text-lg font-semibold mb-2">Type Safe</h3>
          <p className="text-gray-600">
            Built with TypeScript for better developer experience and fewer runtime errors.
          </p>
        </div>
        <div className="bg-white p-6 rounded-lg shadow-md">
          <h3 className="text-lg font-semibold mb-2">Modern Stack</h3>
          <p className="text-gray-600">
            Redux Toolkit, React Query, and React Router for state and data management.
          </p>
        </div>
      </div>
    </div>
  )
}