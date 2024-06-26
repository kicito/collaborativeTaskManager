include "/protocols/http.iol"
include "/interfaces/interfaces.iol"
include "interfaces/objects.iol"
include "console.iol"

outputPort UserManager {
    location: "socket://localhost:1235"
    protocol: http
    interfaces: UserManagementInterface
}

outputPort TaskManager {
    location: "socket://localhost:1234"
    protocol: http
    interfaces: TaskServiceInterface
}

outputPort NotificationManager {
    location: "socket://localhost:1236"
    protocol: http
    interfaces: NotificationInterface
}

init {
    println@Console( "Welcome to the Collaborative Task Manager!" )();
    println@Console( "Do you have a user registered? (y: Yes, n: No): " )();
    readLine@Console()(answer);

    if (answer == "y") {
        println@Console( "Enter username:" )();
        readLine@Console()(user.name);

        // Check if the user is registered in the system
        checkUser@UserManager(user.name)(res);

        if (res.userRegistered == true) {
            println@Console( "Enter password:" )();
            readLine@Console()(user.password)
        } else {
            println@Console( "User not found. Registering a new user..." )();
            println@Console( "Enter username:" )();
            readLine@Console()(user.name);
            println@Console( "Enter password:" )();
            readLine@Console()(user.password);
            println@Console( "Enter email:" )();
            readLine@Console()(user.email);

            // User registration
            registerUser@UserManager(user);
            println@Console( "User registered correctly!" )()
        }

    } else {
        println@Console( "Registering a new user..." )();
        println@Console( "Enter username:" )();
        readLine@Console()(user.name);
        println@Console( "Enter password:" )();
        readLine@Console()(user.password);
        println@Console( "Enter email:" )();
        readLine@Console()(user.email);

        // User registration
        registerUser@UserManager(user);
        println@Console( "User registered correctly!" )()
    }

    println@Console( "Welcome " + user.name + "!" )()
}

main {

    option = "0";
    while (option != "8") {
        // Menu
        println@Console( "\n####################################" )();
        println@Console( "Select an option:" )();
        println@Console( "1. Create a new task" )();
        println@Console( "2. Delete a task" )();
        println@Console( "3. List all tasks" )();
        println@Console( "4. List all tasks assigned to a user" )();
        println@Console( "5. Modify task user" )();
        println@Console( "6. Modify task status" )();
        println@Console( "7. Show notifications historial of a user" )();
        println@Console( "8. Exit" )();
        println@Console( "####################################\n" )();
        readLine@Console()(option);

        if (option == "1") {
            println@Console( "Enter task name:" )();
            readLine@Console()(req.taskName);
            println@Console( "Enter task description:" )();
            readLine@Console()(req.taskDescription);
            println@Console( "Enter task user:" )();
            readLine@Console()(req.taskUser);

            // Create a new task
            createTask@TaskManager(req)
            println@Console( "Task created correctly!" )()

        } else if (option == "2") {
            println@Console( "Enter task name:" )();
            readLine@Console()(taskName);

            // Delete a task
            deleteTask@TaskManager(taskName);
            println@Console( "Task deleted correctly!" )()

        } else if (option == "3") {
            // List all tasks
            listAllTasks@TaskManager()()

        } else if (option == "4") {
            println@Console( "Enter username:" )();
            readLine@Console()(user.name);

            // List all tasks assigned to a user
            listTasksByUser@TaskManager(user.name)()

        } else if (option == "5") {
            println@Console( "Enter task name:" )();
            readLine@Console()(req.taskName);
            println@Console( "Enter new task user:" )();
            readLine@Console()(req.taskUser);

            // Modify task user
            modifyTaskUser@TaskManager(req);
            println@Console( "Task user modified correctly!" )()

        } else if (option == "6") {
            println@Console( "Enter task name:" )();
            readLine@Console()(req.taskName);
            println@Console( "Enter new task status:" )();
            readLine@Console()(req.taskStatus);

            // Modify task status
            modifyTaskStatus@TaskManager(req);
            println@Console( "Task status modified correctly!" )()

        } else if (option == "7") {
            println@Console( "Enter username:" )();
            readLine@Console()(user.name);

            // Show notifications historial of a user
            notificationsHistorialByUser@NotificationManager(user.name)()

        } else if (option == "8") {
            println@Console( "Goodbye!" )()

        } else {
            println@Console( "Invalid option" )()
        }
    }
}