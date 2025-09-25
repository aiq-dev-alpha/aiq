// MongoDB initialization script

// Switch to the application database
db = db.getSiblingDB('{{PROJECT_NAME}}');

// Create indexes for better performance
db.users.createIndex({ "email": 1 }, { unique: true });
db.users.createIndex({ "role": 1 });
db.users.createIndex({ "isActive": 1 });
db.users.createIndex({ "createdAt": -1 });

print('Database initialized with indexes');