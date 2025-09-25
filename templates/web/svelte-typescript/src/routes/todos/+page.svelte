<script lang="ts">
  interface Todo {
    id: number;
    text: string;
    completed: boolean;
  }

  let todos: Todo[] = [
    { id: 1, text: 'Learn Svelte', completed: true },
    { id: 2, text: 'Build an app', completed: false },
    { id: 3, text: 'Deploy to production', completed: false }
  ];

  let newTodoText = '';
  let nextId = 4;

  function addTodo() {
    if (newTodoText.trim()) {
      todos = [...todos, {
        id: nextId++,
        text: newTodoText.trim(),
        completed: false
      }];
      newTodoText = '';
    }
  }

  function toggleTodo(id: number) {
    todos = todos.map(todo =>
      todo.id === id ? { ...todo, completed: !todo.completed } : todo
    );
  }

  function deleteTodo(id: number) {
    todos = todos.filter(todo => todo.id !== id);
  }

  $: activeTodos = todos.filter(t => !t.completed).length;
  $: completedTodos = todos.filter(t => t.completed).length;
</script>

<svelte:head>
  <title>Todo List - Svelte TypeScript Template</title>
</svelte:head>

<main class="min-h-screen bg-gray-100">
  <div class="container mx-auto px-4 py-8">
    <div class="max-w-2xl mx-auto">
      <h1 class="text-4xl font-bold text-gray-900 mb-6 text-center">Todo List</h1>

      <div class="bg-white rounded-lg shadow-md p-6 mb-6">
        <form on:submit|preventDefault={addTodo} class="flex gap-2">
          <input
            bind:value={newTodoText}
            type="text"
            placeholder="What needs to be done?"
            class="flex-1 px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
          <button
            type="submit"
            class="px-6 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition"
          >
            Add
          </button>
        </form>
      </div>

      <div class="bg-white rounded-lg shadow-md p-6 mb-6">
        <div class="flex justify-between text-sm text-gray-600 mb-4">
          <span>{activeTodos} active</span>
          <span>{completedTodos} completed</span>
        </div>

        {#if todos.length === 0}
          <p class="text-center text-gray-500 py-8">No todos yet. Add one above!</p>
        {:else}
          <ul class="space-y-2">
            {#each todos as todo (todo.id)}
              <li class="flex items-center gap-3 p-3 rounded-md hover:bg-gray-50">
                <input
                  type="checkbox"
                  checked={todo.completed}
                  on:change={() => toggleTodo(todo.id)}
                  class="w-5 h-5 text-blue-600 rounded focus:ring-blue-500"
                />
                <span class:line-through={todo.completed} class:text-gray-500={todo.completed} class="flex-1">
                  {todo.text}
                </span>
                <button
                  on:click={() => deleteTodo(todo.id)}
                  class="text-red-500 hover:text-red-700 transition"
                >
                  Delete
                </button>
              </li>
            {/each}
          </ul>
        {/if}
      </div>

      <div class="text-center">
        <a href="/" class="inline-block bg-gray-600 text-white px-6 py-3 rounded-md hover:bg-gray-700 transition">
          Back to Home
        </a>
      </div>
    </div>
  </div>
</main>