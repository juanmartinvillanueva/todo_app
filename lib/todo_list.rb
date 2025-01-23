require 'sqlite3'
require 'date'

class TodoList
  def initialize(db_path = 'todo_app.db')
    @db = SQLite3::Database.new db_path
    @db.results_as_hash = true
  end

  def add_task(description)
    created_at = DateTime.now.to_s
    updated_at = created_at
    completed = 0 # Usar 0 (falso) por defecto
    @db.execute("INSERT INTO tasks (description, completed, created_at, updated_at) VALUES (?, ?, ?, ?)",
                [description, completed, created_at, updated_at])
    @db.last_insert_row_id
  end

  def find_task_by_id(id)
    task = @db.get_first_row("SELECT * FROM tasks WHERE id = ?", [id])
    symbolize_keys(task) if task
  end

  def all_tasks
    tasks = @db.execute("SELECT * FROM tasks")
    tasks.map { |task| symbolize_keys(task) }
  end

  def complete_task(id)
    updated_at = DateTime.now.to_s
    @db.execute("UPDATE tasks SET completed = ?, updated_at = ? WHERE id = ?", [1, updated_at, id])
  end

  def delete_task(id)
    @db.execute("DELETE FROM tasks WHERE id = ?", [id])
  end

  def edit_task_description(id, new_description)
    updated_at = DateTime.now.to_s
    @db.execute("UPDATE tasks SET description = ?, completed = ?, updated_at = ? WHERE id = ?",
                [new_description, 0, updated_at, id])
  end

  def completed_tasks
    tasks = @db.execute("SELECT * FROM tasks WHERE completed = ?", [1])
    tasks.map { |task| symbolize_keys(task) }
  end

  private

  def symbolize_keys(hash)
    hash.transform_keys(&:to_sym)
  end
end
