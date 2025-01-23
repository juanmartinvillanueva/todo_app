require 'rspec'
require 'fileutils'
require 'sqlite3'
require_relative '../lib/todo_list'

# Define db_path fuera del bloque describe
db_path = 'spec/test_todo_app.db'

RSpec.describe TodoList do
  let(:todo_list) { TodoList.new(db_path) }

  before(:each) do
    FileUtils.rm_f(db_path) # Eliminar la base de datos de pruebas
    system('ruby db_setup_test.rb') # Asegurarse de que la base de datos y la tabla se crean antes de cada prueba
  end

  describe 'Base de datos y tablas' do
    it 'crea la base de datos y la tabla tasks' do
      db = SQLite3::Database.new db_path
      tables = db.execute <<-SQL
        SELECT name FROM sqlite_master WHERE type='table' AND name='tasks';
      SQL
      expect(tables).not_to be_empty
      expect(tables.first.first).to eq('tasks') # Acceder correctamente al valor del array interno
    end
  end

  describe 'Operaciones con tareas' do
    it 'agrega una nueva tarea' do
      id = todo_list.add_task('Aprender TDD')
      task = todo_list.find_task_by_id(id)
      expect(task).not_to be_nil
      expect(task[:description]).to eq('Aprender TDD')
      expect(task[:completed]).to eq(0) # Verificar que la tarea se crea como pendiente
      expect(task[:created_at]).not_to be_nil
      expect(task[:updated_at]).not_to be_nil
    end

    it 'lista todas las tareas' do
      todo_list.add_task('Aprender TDD')
      todo_list.add_task('Escribir código')
      tasks = todo_list.all_tasks
      expect(tasks.size).to eq(2) # Asegurarse de que solo se cuentan las tareas creadas en esta prueba
      expect(tasks.all? { |task| task[:completed] == 0 }).to be true # Verificar que todas las tareas están pendientes
    end

    it 'marca una tarea como completada' do
      id = todo_list.add_task('Aprender TDD')
      todo_list.complete_task(id)
      task = todo_list.find_task_by_id(id)
      expect(task[:completed]).to eq(1) # Verificar que la tarea está completada
    end

    it 'elimina una tarea por ID' do
      id = todo_list.add_task('Aprender TDD')
      todo_list.delete_task(id)
      task = todo_list.find_task_by_id(id)
      expect(task).to be_nil
    end

    it 'edita la descripción de una tarea y la marca como pendiente' do
      id = todo_list.add_task('Aprender TDD')
      todo_list.complete_task(id)
      todo_list.edit_task_description(id, 'Aprender TDD con RSpec')
      task = todo_list.find_task_by_id(id)
      expect(task).not_to be_nil
      expect(task[:description]).to eq('Aprender TDD con RSpec')
      expect(task[:completed]).to eq(0) # Verificar que la tarea se marca como pendiente al editarla
    end

    it 'lista solo las tareas completadas' do
      todo_list.add_task('Aprender TDD')
      id = todo_list.add_task('Escribir código')
      todo_list.complete_task(id)
      completed_tasks = todo_list.completed_tasks
      expect(completed_tasks.size).to eq(1)
      expect(completed_tasks.first[:description]).to eq('Escribir código')
      expect(completed_tasks.first[:completed]).to eq(1) # Verificar que la tarea completada está marcada correctamente
    end
  end

  after(:context) { FileUtils.rm_f(db_path) }
end
