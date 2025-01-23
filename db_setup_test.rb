require 'sqlite3'

# Conectar a la base de datos (crea la base de datos si no existe)
db_path = 'spec/test_todo_app.db'
db = SQLite3::Database.new db_path

# Eliminar la tabla de tareas si existe
db.execute <<-SQL
  DROP TABLE IF EXISTS tasks;
SQL

# Crear la tabla de tareas
db.execute <<-SQL
  CREATE TABLE tasks (
    id INTEGER PRIMARY KEY,
    description TEXT,
    completed BOOLEAN,
    created_at TEXT,
    updated_at TEXT
  );
SQL

puts "Base de datos y tabla 'tasks' creadas o verificadas correctamente."
