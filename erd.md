### Entity-Relationship Diagram (ERD) for Firestore

Given Firestore's NoSQL document model, we'll define collections and documents with their fields and relationships.

**Entities (Collections/Documents):**

1.  **`users` Collection:**
    *   **Document ID:** `userId` (from Firebase Authentication UID)
    *   **Fields:**
        *   `email`: String
        *   `displayName`: String (optional)
        *   `createdAt`: Timestamp
        *   `lastLoginAt`: Timestamp

2.  **`routines` Collection:** (Subcollection under `users` or top-level with `userId` field)
    *   **Document ID:** `routineId` (Firestore auto-generated)
    *   **Fields:**
        *   `userId`: String (Reference to `users` collection)
        *   `name`: String (e.g., "Morning Routine", "Evening Workout")
        *   `description`: String (optional)
        *   `frequency`: List<String> (e.g., ["Daily"], ["Monday", "Wednesday", "Friday"])
        *   `startTime`: String (e.g., "08:00")
        *   `endTime`: String (optional, e.g., "09:00")
        *   `isActive`: Boolean
        *   `createdAt`: Timestamp
        *   `updatedAt`: Timestamp

    *   **Subcollection: `tasks`** (under each `routineId` document)
        *   **Document ID:** `taskId` (Firestore auto-generated)
        *   **Fields:**
            *   `name`: String (e.g., "Brush teeth", "Meditate")
            *   `durationMinutes`: int (optional)
            *   `order`: int (for display order)
            *   `isCompleted`: Map<String, bool> (e.g., {"2025-08-27": true} for daily tracking)

3.  **`events` Collection:** (Subcollection under `users` or top-level with `userId` field)
    *   **Document ID:** `eventId` (Firestore auto-generated)
    *   **Fields:**
        *   `userId`: String (Reference to `users` collection)
        *   `title`: String (e.g., "Doctor's Appointment", "Project Deadline")
        *   `description`: String (optional)
        *   `dateTime`: Timestamp
        *   `isCompleted`: Boolean
        *   `type`: String (e.g., "Appointment", "Deadline", "Reminder", "Todo")
        *   `createdAt`: Timestamp
        *   `updatedAt`: Timestamp

**Relationships:**
*   One `User` has many `Routines`.
*   One `Routine` has many `Tasks`.
*   One `User` has many `Events`.

### Use Case Diagram

**Actors:**
*   **User:** The individual using the Routine Planner application.

**Use Cases:**

**Authentication:**
*   **Register Account:** User creates a new account.
*   **Login:** User accesses their existing account.
*   **Logout:** User signs out of the application.
*   **Reset Password:** User initiates a password reset.

**Routine Management:**
*   **Create Routine:** User defines a new routine (e.g., "Morning Routine").
*   **View Routines:** User sees a list of their routines.
*   **Edit Routine:** User modifies an existing routine's details.
*   **Delete Routine:** User removes a routine.
*   **Add Task to Routine:** User adds a specific task to a routine.
*   **Edit Task in Routine:** User modifies a task within a routine.
*   **Delete Task from Routine:** User removes a task from a routine.
*   **Mark Routine Task as Complete:** User marks a task within a routine as completed for a specific day.

**Event/To-Do Management:**
*   **Create Event/To-Do:** User adds a new event or to-do item.
*   **View Events/To-Dos:** User sees a list of their events/to-dos.
*   **Edit Event/To-Do:** User modifies an existing event/to-do.
*   **Delete Event/To-Do:** User removes an event/to-do.
*   **Mark Event/To-Do as Complete:** User marks an event/to-do as finished.

**General:**
*   **View Dashboard/Overview:** User sees a summary of upcoming routines and events.