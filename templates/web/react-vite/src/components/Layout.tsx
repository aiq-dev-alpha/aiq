import { Outlet } from 'react-router-dom'
import { useSelector } from 'react-redux'
import { RootState } from '@store/index'
import Header from './Header'
import Sidebar from './Sidebar'

export default function Layout() {
  const sidebarOpen = useSelector((state: RootState) => state.ui.sidebarOpen)

  return (
    <div className="min-h-screen bg-gray-50">
      <Header />
      <div className="flex">
        {sidebarOpen && <Sidebar />}
        <main className="flex-1 p-6">
          <Outlet />
        </main>
      </div>
    </div>
  )
}