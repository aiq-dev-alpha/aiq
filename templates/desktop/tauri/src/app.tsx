import { useState, useEffect } from 'react';
import { invoke } from '@tauri-apps/api/tauri';
import { open, save } from '@tauri-apps/api/dialog';
import { readTextFile, writeTextFile } from '@tauri-apps/api/fs';
import { appWindow } from '@tauri-apps/api/window';

function App() {
  const [greetMsg, setGreetMsg] = useState('');
  const [name, setName] = useState('');
  const [fileContent, setFileContent] = useState('');
  const [isMaximized, setIsMaximized] = useState(false);

  useEffect(() => {
    const setupWindow = async () => {
      const maximized = await appWindow.isMaximized();
      setIsMaximized(maximized);
    };
    setupWindow();
  }, []);

  async function greet() {
    setGreetMsg(await invoke('greet', { name }));
  }

  async function openFile() {
    const selected = await open({
      multiple: false,
      filters: [{
        name: 'Text',
        extensions: ['txt', 'md', 'json']
      }]
    });

    if (selected && typeof selected === 'string') {
      const content = await readTextFile(selected);
      setFileContent(content);
      const result = await invoke('process_file', { content });
      console.log('Processed:', result);
    }
  }

  async function saveFile() {
    const filePath = await save({
      filters: [{
        name: 'Text',
        extensions: ['txt']
      }]
    });

    if (filePath) {
      await writeTextFile(filePath, fileContent);
    }
  }

  async function toggleMaximize() {
    await appWindow.toggleMaximize();
    setIsMaximized(!isMaximized);
  }

  return (
    <div className="min-h-screen bg-gray-100">
      <div className="custom-titlebar bg-gray-800 text-white p-2 flex justify-between items-center">
        <span className="text-sm font-semibold">Tauri Desktop App</span>
        <div className="flex gap-2">
          <button
            onClick={() => appWindow.minimize()}
            className="px-2 py-1 hover:bg-gray-700 rounded"
          >
            _
          </button>
          <button
            onClick={toggleMaximize}
            className="px-2 py-1 hover:bg-gray-700 rounded"
          >
            {isMaximized ? '◱' : '□'}
          </button>
          <button
            onClick={() => appWindow.close()}
            className="px-2 py-1 hover:bg-red-600 rounded"
          >
            ×
          </button>
        </div>
      </div>

      <div className="container mx-auto p-8">
        <header className="text-center mb-8">
          <h1 className="text-4xl font-bold text-gray-900 mb-4">
            Welcome to Tauri!
          </h1>
          <p className="text-lg text-gray-600">
            Build smaller, faster, and more secure desktop applications
          </p>
        </header>

        <div className="max-w-4xl mx-auto grid grid-cols-1 md:grid-cols-2 gap-6">
          <div className="bg-white rounded-lg shadow-md p-6">
            <h2 className="text-2xl font-semibold mb-4">Rust Backend Integration</h2>
            <div className="space-y-4">
              <input
                type="text"
                value={name}
                onChange={(e) => setName(e.currentTarget.value)}
                placeholder="Enter your name..."
                className="w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
              <button
                onClick={greet}
                className="w-full px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition"
              >
                Greet
              </button>
              {greetMsg && (
                <p className="p-4 bg-gray-100 rounded-md text-center">
                  {greetMsg}
                </p>
              )}
            </div>
          </div>

          <div className="bg-white rounded-lg shadow-md p-6">
            <h2 className="text-2xl font-semibold mb-4">File Operations</h2>
            <div className="space-y-4">
              <button
                onClick={openFile}
                className="w-full px-4 py-2 bg-green-600 text-white rounded-md hover:bg-green-700 transition"
              >
                Open File
              </button>
              <button
                onClick={saveFile}
                disabled={!fileContent}
                className="w-full px-4 py-2 bg-purple-600 text-white rounded-md hover:bg-purple-700 transition disabled:bg-gray-400"
              >
                Save File
              </button>
              {fileContent && (
                <textarea
                  value={fileContent}
                  onChange={(e) => setFileContent(e.target.value)}
                  className="w-full h-32 px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                  placeholder="File content will appear here..."
                />
              )}
            </div>
          </div>

          <div className="bg-white rounded-lg shadow-md p-6 md:col-span-2">
            <h2 className="text-2xl font-semibold mb-4">Features</h2>
            <div className="grid grid-cols-2 gap-4">
              <div>
                <h3 className="font-semibold text-lg mb-2">Frontend</h3>
                <ul className="text-gray-700 space-y-1">
                  <li>✓ React with TypeScript</li>
                  <li>✓ Tailwind CSS</li>
                  <li>✓ Vite for fast development</li>
                  <li>✓ Hot Module Replacement</li>
                </ul>
              </div>
              <div>
                <h3 className="font-semibold text-lg mb-2">Backend</h3>
                <ul className="text-gray-700 space-y-1">
                  <li>✓ Rust for performance</li>
                  <li>✓ Native file system access</li>
                  <li>✓ System tray support</li>
                  <li>✓ Window management</li>
                </ul>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

export default App;