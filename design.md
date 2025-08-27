<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Routine Planner</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* Custom CSS for animations and additional styling */
        .fade-in {
            animation: fadeIn 0.3s ease-in-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .sidebar {
            transition: all 0.3s ease;
        }
        
        .task-item:hover {
            transform: translateX(5px);
            transition: transform 0.2s ease;
        }
        
        .completed-task {
            text-decoration: line-through;
            opacity: 0.7;
        }
        
        /* Custom scrollbar */
        ::-webkit-scrollbar {
            width: 8px;
        }
        
        ::-webkit-scrollbar-track {
            background: #f1f1f1;
        }
        
        ::-webkit-scrollbar-thumb {
            background: #cbd5e0;
            border-radius: 4px;
        }
        
        ::-webkit-scrollbar-thumb:hover {
            background: #a0aec0;
        }
    </style>
</head>
<body class="bg-gray-50 font-sans">
    <div class="flex h-screen overflow-hidden">
        <!-- Sidebar -->
        <div class="sidebar bg-white w-64 border-r border-gray-200 flex flex-col">
            <div class="p-4 border-b border-gray-200">
                <h1 class="text-2xl font-bold text-indigo-600 flex items-center">
                    <i class="fas fa-calendar-check mr-2"></i> RoutinePlanner
                </h1>
            </div>

            <div class="flex-1 overflow-y-auto">
                <div class="p-4">
                    <div class="mb-6">
                        <h2 class="text-xs uppercase font-semibold text-gray-500 mb-2">Navigation</h2>
                        <ul>
                            <li class="mb-1">
                                <a href="#" class="flex items-center px-3 py-2 rounded-lg bg-indigo-50 text-indigo-700">
                                    <i class="fas fa-home mr-3"></i> Dashboard
                                </a>
                            </li>
                            <li class="mb-1">
                                <a href="#" class="flex items-center px-3 py-2 rounded-lg text-gray-700 hover:bg-gray-100">
                                    <i class="fas fa-list-check mr-3"></i> Routines
                                </a>
                            </li>
                            <li class="mb-1">
                                <a href="#" class="flex items-center px-3 py-2 rounded-lg text-gray-700 hover:bg-gray-100">
                                    <i class="fas fa-calendar-days mr-3"></i> Events
                                </a>
                            </li>
                            <li class="mb-1">
                                <a href="#" class="flex items-center px-3 py-2 rounded-lg text-gray-700 hover:bg-gray-100">
                                    <i class="fas fa-chart-line mr-3"></i> Statistics
                                </a>
                            </li>
                        </ul>
                    </div>
                    
                    <div class="mb-6">
                        <h2 class="text-xs uppercase font-semibold text-gray-500 mb-2">My Routines</h2>
                        <ul id="routine-list">
                            <!-- Routines will be populated here -->
                        </ul>
                        <button class="mt-2 w-full flex items-center justify-center text-indigo-600 hover:text-indigo-800 text-sm font-medium">
                            <i class="fas fa-plus mr-2"></i> Add Routine
                        </button>
                    </div>
                </div>
            </div>
            
            <div class="p-4 border-t border-gray-200">
                <div class="flex items-center">
                    <div class="w-10 h-10 rounded-full bg-indigo-100 flex items-center justify-center text-indigo-600">
                        <i class="fas fa-user"></i>
                    </div>
                    <div class="ml-3">
                        <p class="text-sm font-medium" id="user-name">John Doe</p>
                        <p class="text-xs text-gray-500" id="user-email">john@example.com</p>
                    </div>
                    <button class="ml-auto text-gray-500 hover:text-gray-700">
                        <i class="fas fa-sign-out-alt"></i>
                    </button>
                </div>
            </div>
        </div>
        
        <!-- Main Content -->
        <div class="flex-1 flex flex-col overflow-hidden">
            <!-- Top Navigation -->
            <header class="bg-white border-b border-gray-200 py-4 px-6 flex items-center justify-between">
                <div class="flex items-center">
                    <button id="sidebar-toggle" class="md:hidden mr-4 text-gray-500 hover:text-gray-700">
                        <i class="fas fa-bars"></i>
                    </button>
                    <h2 class="text-xl font-semibold text-gray-800">Dashboard</h2>
                </div>
                <div class="flex items-center space-x-4">
                    <button class="p-2 rounded-full bg-gray-100 text-gray-600 hover:bg-gray-200">
                        <i class="fas fa-bell"></i>
                    </button>
                    <button class="p-2 rounded-full bg-gray-100 text-gray-600 hover:bg-gray-200">
                        <i class="fas fa-cog"></i>
                    </button>
                </div>
            </header>
            
            <!-- Dashboard Content -->
            <main class="flex-1 overflow-y-auto p-6">
                <!-- Welcome Banner -->
                <div class="bg-gradient-to-r from-indigo-500 to-purple-600 rounded-xl p-6 text-white mb-6">
                    <h1 class="text-2xl font-bold mb-2">Good morning, John!</h1>
                    <p class="opacity-90">You have 3 routines scheduled today with 5 tasks to complete.</p>
                </div>
                
                <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                    <!-- Today's Routines -->
                    <div class="lg:col-span-2">
                        <div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
                            <div class="px-6 py-4 border-b border-gray-200 flex items-center justify-between">
                                <h3 class="font-semibold text-lg">Today's Routines</h3>
                                <button class="text-sm text-indigo-600 hover:text-indigo-800 font-medium">
                                    View All
                                </button>
                            </div>
                            <div class="divide-y divide-gray-200">
                                <!-- Routine Item -->
                                <div class="p-6 fade-in">
                                    <div class="flex items-start justify-between mb-3">
                                        <div>
                                            <h4 class="font-medium text-gray-800">Morning Routine</h4>
                                            <p class="text-sm text-gray-500">08:00 - 09:00 • Daily</p>
                                        </div>
                                        <div class="flex items-center space-x-2">
                                            <span class="px-2 py-1 bg-green-100 text-green-800 text-xs rounded-full">Active</span>
                                            <button class="text-gray-400 hover:text-gray-600">
                                                <i class="fas fa-ellipsis-vertical"></i>
                                            </button>
                                        </div>
                                    </div>
                                    
                                    <div class="space-y-2">
                                        <!-- Task Item -->
                                        <div class="task-item flex items-center p-3 bg-gray-50 rounded-lg">
                                            <button class="w-5 h-5 rounded-full border-2 border-gray-300 mr-3 flex-shrink-0 hover:border-indigo-400"></button>
                                            <div class="flex-1">
                                                <p class="text-sm font-medium">Brush teeth</p>
                                                <p class="text-xs text-gray-500">5 minutes</p>
                                            </div>
                                            <button class="text-gray-400 hover:text-gray-600 ml-2">
                                                <i class="fas fa-pen-to-square"></i>
                                            </button>
                                        </div>
                                        
                                        <!-- Task Item -->
                                        <div class="task-item flex items-center p-3 bg-gray-50 rounded-lg">
                                            <button class="w-5 h-5 rounded-full border-2 border-gray-300 mr-3 flex-shrink-0 hover:border-indigo-400"></button>
                                            <div class="flex-1">
                                                <p class="text-sm font-medium">Meditate</p>
                                                <p class="text-xs text-gray-500">10 minutes</p>
                                            </div>
                                            <button class="text-gray-400 hover:text-gray-600 ml-2">
                                                <i class="fas fa-pen-to-square"></i>
                                            </button>
                                        </div>
                                        
                                        <!-- Task Item -->
                                        <div class="task-item flex items-center p-3 bg-gray-50 rounded-lg completed-task">
                                            <button class="w-5 h-5 rounded-full border-2 border-indigo-500 bg-indigo-500 mr-3 flex-shrink-0 flex items-center justify-center text-white">
                                                <i class="fas fa-check text-xs"></i>
                                            </button>
                                            <div class="flex-1">
                                                <p class="text-sm font-medium">Drink water</p>
                                                <p class="text-xs text-gray-500">2 minutes</p>
                                            </div>
                                            <button class="text-gray-400 hover:text-gray-600 ml-2">
                                                <i class="fas fa-pen-to-square"></i>
                                            </button>
                                        </div>
                                    </div>
                                    
                                    <button class="mt-3 text-sm text-indigo-600 hover:text-indigo-800 font-medium flex items-center">
                                        <i class="fas fa-plus mr-1"></i> Add Task
                                    </button>
                                </div>
                                
                                <!-- Routine Item -->
                                <div class="p-6 fade-in">
                                    <div class="flex items-start justify-between mb-3">
                                        <div>
                                            <h4 class="font-medium text-gray-800">Workout Routine</h4>
                                            <p class="text-sm text-gray-500">18:00 - 19:00 • Mon, Wed, Fri</p>
                                        </div>
                                        <div class="flex items-center space-x-2">
                                            <span class="px-2 py-1 bg-green-100 text-green-800 text-xs rounded-full">Active</span>
                                            <button class="text-gray-400 hover:text-gray-600">
                                                <i class="fas fa-ellipsis-vertical"></i>
                                            </button>
                                        </div>
                                    </div>
                                    
                                    <div class="space-y-2">
                                        <!-- Task Item -->
                                        <div class="task-item flex items-center p-3 bg-gray-50 rounded-lg">
                                            <button class="w-5 h-5 rounded-full border-2 border-gray-300 mr-3 flex-shrink-0 hover:border-indigo-400"></button>
                                            <div class="flex-1">
                                                <p class="text-sm font-medium">Warm up</p>
                                                <p class="text-xs text-gray-500">10 minutes</p>
                                            </div>
                                            <button class="text-gray-400 hover:text-gray-600 ml-2">
                                                <i class="fas fa-pen-to-square"></i>
                                            </button>
                                        </div>
                                    </div>
                                    
                                    <button class="mt-3 text-sm text-indigo-600 hover:text-indigo-800 font-medium flex items-center">
                                        <i class="fas fa-plus mr-1"></i> Add Task
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Upcoming Events -->
                    <div>
                        <div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
                            <div class="px-6 py-4 border-b border-gray-200 flex items-center justify-between">
                                <h3 class="font-semibold text-lg">Upcoming Events</h3>
                                <button class="text-sm text-indigo-600 hover:text-indigo-800 font-medium">
                                    View All
                                </button>
                            </div>
                            <div class="divide-y divide-gray-200">
                                <!-- Event Item -->
                                <div class="p-6 fade-in">
                                    <div class="flex items-start justify-between mb-2">
                                        <div>
                                            <h4 class="font-medium text-gray-800">Doctor's Appointment</h4>
                                            <p class="text-sm text-gray-500">Today, 14:30</p>
                                        </div>
                                        <button class="text-gray-400 hover:text-gray-600">
                                            <i class="fas fa-ellipsis-vertical"></i>
                                        </button>
                                    </div>
                                    <p class="text-sm text-gray-600 mb-3">Annual checkup at City Medical Center</p>
                                    <div class="flex space-x-2">
                                        <span class="px-2 py-1 bg-blue-100 text-blue-800 text-xs rounded-full">Appointment</span>
                                    </div>
                                </div>
                                
                                <!-- Event Item -->
                                <div class="p-6 fade-in">
                                    <div class="flex items-start justify-between mb-2">
                                        <div>
                                            <h4 class="font-medium text-gray-800">Project Deadline</h4>
                                            <p class="text-sm text-gray-500">Tomorrow, 17:00</p>
                                        </div>
                                        <button class="text-gray-400 hover:text-gray-600">
                                            <i class="fas fa-ellipsis-vertical"></i>
                                        </button>
                                    </div>
                                    <p class="text-sm text-gray-600 mb-3">Submit final report for client review</p>
                                    <div class="flex space-x-2">
                                        <span class="px-2 py-1 bg-red-100 text-red-800 text-xs rounded-full">Deadline</span>
                                        <span class="px-2 py-1 bg-yellow-100 text-yellow-800 text-xs rounded-full">High Priority</span>
                                    </div>
                                </div>
                                
                                <!-- Event Item -->
                                <div class="p-6 fade-in">
                                    <div class="flex items-start justify-between mb-2">
                                        <div>
                                            <h4 class="font-medium text-gray-800">Team Meeting</h4>
                                            <p class="text-sm text-gray-500">Wed, 10:00</p>
                                        </div>
                                        <button class="text-gray-400 hover:text-gray-600">
                                            <i class="fas fa-ellipsis-vertical"></i>
                                        </button>
                                    </div>
                                    <p class="text-sm text-gray-600 mb-3">Weekly sync with the development team</p>
                                    <div class="flex space-x-2">
                                        <span class="px-2 py-1 bg-purple-100 text-purple-800 text-xs rounded-full">Meeting</span>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="p-4 border-t border-gray-200">
                                <button class="w-full flex items-center justify-center text-indigo-600 hover:text-indigo-800 font-medium">
                                    <i class="fas fa-plus mr-2"></i> Add Event
                                </button>
                            </div>
                        </div>
                        
                        <!-- Quick Stats -->
                        <div class="bg-white rounded-xl shadow-sm border border-gray-200 mt-6 p-6">
                            <h3 class="font-semibold text-lg mb-4">Quick Stats</h3>
                            <div class="grid grid-cols-2 gap-4">
                                <div class="bg-indigo-50 rounded-lg p-3">
                                    <p class="text-xs text-indigo-600 font-medium mb-1">Active Routines</p>
                                    <p class="text-2xl font-bold text-indigo-800">5</p>
                                </div>
                                <div class="bg-green-50 rounded-lg p-3">
                                    <p class="text-xs text-green-600 font-medium mb-1">Completed Today</p>
                                    <p class="text-2xl font-bold text-green-800">12</p>
                                </div>
                                <div class="bg-blue-50 rounded-lg p-3">
                                    <p class="text-xs text-blue-600 font-medium mb-1">Upcoming Events</p>
                                    <p class="text-2xl font-bold text-blue-800">3</p>
                                </div>
                                <div class="bg-purple-50 rounded-lg p-3">
                                    <p class="text-xs text-purple-600 font-medium mb-1">Streak</p>
                                    <p class="text-2xl font-bold text-purple-800">7 days</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- Add Routine Modal -->
    <div id="routine-modal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 hidden">
        <div class="bg-white rounded-xl w-full max-w-md mx-4 fade-in">
            <div class="px-6 py-4 border-b border-gray-200 flex items-center justify-between">
                <h3 class="font-semibold text-lg">Add New Routine</h3>
                <button id="close-routine-modal" class="text-gray-400 hover:text-gray-600">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="p-6">
                <form>
                    <div class="mb-4">
                        <label class="block text-gray-700 text-sm font-medium mb-2" for="routine-name">Routine Name</label>
                        <input type="text" id="routine-name" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent" placeholder="e.g. Morning Routine">
                    </div>
                    
                    <div class="mb-4">
                        <label class="block text-gray-700 text-sm font-medium mb-2" for="routine-description">Description (Optional)</label>
                        <textarea id="routine-description" rows="2" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent" placeholder="Brief description of your routine"></textarea>
                    </div>
                    
                    <div class="grid grid-cols-2 gap-4 mb-4">
                        <div>
                            <label class="block text-gray-700 text-sm font-medium mb-2" for="start-time">Start Time</label>
                            <input type="time" id="start-time" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent">
                        </div>
                        <div>
                            <label class="block text-gray-700 text-sm font-medium mb-2" for="end-time">End Time (Optional)</label>
                            <input type="time" id="end-time" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent">
                        </div>
                    </div>
                    
                    <div class="mb-4">
                        <label class="block text-gray-700 text-sm font-medium mb-2">Frequency</label>
                        <div class="flex flex-wrap gap-2">
                            <label class="inline-flex items-center">
                                <input type="checkbox" class="rounded border-gray-300 text-indigo-600 shadow-sm focus:border-indigo-300 focus:ring focus:ring-indigo-200 focus:ring-opacity-50" checked>
                                <span class="ml-2 text-sm">Daily</span>
                            </label>
                            <label class="inline-flex items-center">
                                <input type="checkbox" class="rounded border-gray-300 text-indigo-600 shadow-sm focus:border-indigo-300 focus:ring focus:ring-indigo-200 focus:ring-opacity-50">
                                <span class="ml-2 text-sm">Mon</span>
                            </label>
                            <label class="inline-flex items-center">
                                <input type="checkbox" class="rounded border-gray-300 text-indigo-600 shadow-sm focus:border-indigo-300 focus:ring focus:ring-indigo-200 focus:ring-opacity-50">
                                <span class="ml-2 text-sm">Tue</span>
                            </label>
                            <label class="inline-flex items-center">
                                <input type="checkbox" class="rounded border-gray-300 text-indigo-600 shadow-sm focus:border-indigo-300 focus:ring focus:ring-indigo-200 focus:ring-opacity-50">
                                <span class="ml-2 text-sm">Wed</span>
                            </label>
                            <label class="inline-flex items-center">
                                <input type="checkbox" class="rounded border-gray-300 text-indigo-600 shadow-sm focus:border-indigo-300 focus:ring focus:ring-indigo-200 focus:ring-opacity-50">
                                <span class="ml-2 text-sm">Thu</span>
                            </label>
                            <label class="inline-flex items-center">
                                <input type="checkbox" class="rounded border-gray-300 text-indigo-600 shadow-sm focus:border-indigo-300 focus:ring focus:ring-indigo-200 focus:ring-opacity-50">
                                <span class="ml-2 text-sm">Fri</span>
                            </label>
                            <label class="inline-flex items-center">
                                <input type="checkbox" class="rounded border-gray-300 text-indigo-600 shadow-sm focus:border-indigo-300 focus:ring focus:ring-indigo-200 focus:ring-opacity-50">
                                <span class="ml-2 text-sm">Sat</span>
                            </label>
                            <label class="inline-flex items-center">
                                <input type="checkbox" class="rounded border-gray-300 text-indigo-600 shadow-sm focus:border-indigo-300 focus:ring focus:ring-indigo-200 focus:ring-opacity-50">
                                <span class="ml-2 text-sm">Sun</span>
                            </label>
                        </div>
                    </div>
                    
                    <div class="flex justify-end space-x-3">
                        <button type="button" id="cancel-routine" class="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50">Cancel</button>
                        <button type="submit" class="px-4 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2">Save Routine</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        // Sample data for routines (would come from Firestore in real app)
        const routines = [
            { id: '1', name: 'Morning Routine', frequency: 'Daily', active: true },
            { id: '2', name: 'Workout Routine', frequency: 'Mon, Wed, Fri', active: true },
            { id: '3', name: 'Night Routine', frequency: 'Daily', active: false },
        ];

        // DOM elements
        const sidebarToggle = document.getElementById('sidebar-toggle');
        const sidebar = document.querySelector('.sidebar');
        const routineList = document.getElementById('routine-list');
        const routineModal = document.getElementById('routine-modal');
        const closeRoutineModal = document.getElementById('close-routine-modal');
        const cancelRoutine = document.getElementById('cancel-routine');
        const addRoutineButtons = document.querySelectorAll('button:has(.fa-plus)');

        // Toggle sidebar on mobile
        sidebarToggle.addEventListener('click', () => {
            sidebar.classList.toggle('-translate-x-full');
        });

        // Populate routine list in sidebar
        function populateRoutineList() {
            routineList.innerHTML = '';
            routines.forEach(routine => {
                const routineItem = document.createElement('li');
                routineItem.className = 'mb-1';
                routineItem.innerHTML = `
                    <a href="#" class="flex items-center px-3 py-2 rounded-lg ${routine.active ? 'bg-indigo-50 text-indigo-700' : 'text-gray-700 hover:bg-gray-100'}">
                        <i class="fas ${routine.active ? 'fa-check-circle' : 'fa-circle'} mr-3 text-xs"></i>
                        <span class="truncate">${routine.name}</span>
                        <span class="ml-auto text-xs text-gray-500">${routine.frequency}</span>
                    </a>
                `;
                routineList.appendChild(routineItem);
            });
        }

        // Show routine modal
        function showRoutineModal() {
            routineModal.classList.remove('hidden');
        }

        // Hide routine modal
        function hideRoutineModal() {
            routineModal.classList.add('hidden');
        }

        // Event listeners for routine modal
        addRoutineButtons.forEach(button => {
            if (button.textContent.includes('Add Routine')) {
                button.addEventListener('click', showRoutineModal);
            }
        });

        closeRoutineModal.addEventListener('click', hideRoutineModal);
        cancelRoutine.addEventListener('click', hideRoutineModal);

        // Task completion toggle
        document.addEventListener('click', (e) => {
            if (e.target.closest('.task-item button')) {
                const taskItem = e.target.closest('.task-item');
                const checkbox = taskItem.querySelector('button');
                const isCompleted = checkbox.classList.contains('bg-indigo-500');
                
                if (isCompleted) {
                    checkbox.className = 'w-5 h-5 rounded-full border-2 border-gray-300 mr-3 flex-shrink-0 hover:border-indigo-400';
                    taskItem.classList.remove('completed-task');
                } else {
                    checkbox.className = 'w-5 h-5 rounded-full border-2 border-indigo-500 bg-indigo-500 mr-3 flex-shrink-0 flex items-center justify-center text-white';
                    checkbox.innerHTML = '<i class="fas fa-check text-xs"></i>';
                    taskItem.classList.add('completed-task');
                }
            }
        });

        // Initialize
        document.addEventListener('DOMContentLoaded', () => {
            populateRoutineList();
            
            // Set user info (would come from Firebase Auth in real app)
            document.getElementById('user-name').textContent = 'John Doe';
            document.getElementById('user-email').textContent = 'john@example.com';
        });
    </script>
</body>
</html>