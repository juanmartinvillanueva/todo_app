require 'rspec'
require 'fileutils'
require_relative '../lib/todo_list'

# Define file_path fuera del bloque describe
file_path = 'spec/test_tasks.json'

RSpec.describe TodoList do
  let(:todo_list) { TodoList.new(file_path) }

  before(:each) { FileUtils.rm_f(file_path) }

  it 'agrega una nueva tarea' do
    id = todo_list.add_task('Aprender TDD')
    task = todo_list.find_task_by_id(id)
    expect(task).not_to be_nil
    expect(task[:description]).to eq('Aprender TDD')
    expect(task[:completed]).to be false
  end

  it 'lista todas las tareas' do
    todo_list.add_task('Aprender TDD')
    todo_list.add_task('Escribir código')
    tasks = todo_list.all_tasks
    expect(tasks.size).to eq(2)
  end

  it 'marca una tarea como completada' do
    id = todo_list.add_task('Aprender TDD')
    todo_list.complete_task(id)
    task = todo_list.find_task_by_id(id)
    expect(task[:completed]).to be true
  end

  it 'elimina una tarea por ID' do
    id = todo_list.add_task('Aprender TDD')
    todo_list.delete_task(id)
    task = todo_list.find_task_by_id(id)
    expect(task).to be_nil
  end

  it 'edita la descripción de una tarea y la marca como pendiente' do
    id = todo_list.add_task('Aprender TDD')
    todo_list.edit_task_description(id, 'Aprender TDD con RSpec')
    task = todo_list.find_task_by_id(id)
    expect(task).not_to be_nil
    expect(task[:description]).to eq('Aprender TDD con RSpec')
    expect(task[:completed]).to be false
  end

  it 'lista solo las tareas completadas' do
    todo_list.add_task('Aprender TDD')
    id = todo_list.add_task('Escribir código')
    todo_list.complete_task(id)
    completed_tasks = todo_list.completed_tasks
    expect(completed_tasks.size).to eq(1)
    expect(completed_tasks.first[:description]).to eq('Escribir código')
  end

  after(:context) { FileUtils.rm_f(file_path) }
end
