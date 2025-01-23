require 'sqlite3'

# Conectar a la base de datos (crea la base de datos si no existe)
db_path = 'todo_app.db'
db = SQLite3::Database.new db_path

# Crear la tabla de tareas si no existe
db.execute <<-SQL
  CREATE TABLE IF NOT EXISTS tasks (
    id INTEGER PRIMARY KEY,
    description TEXT,
    completed BOOLEAN,
    created_at TEXT,
    updated_at TEXT
  );
SQL

puts "Base de datos y tabla 'tasks' creadas o verificadas correctamente."
