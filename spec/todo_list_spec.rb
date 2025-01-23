# spec/todo_list_spec.rb
require 'rspec'
require_relative '../lib/todo_list'

RSpec.describe TodoList do
  it 'agrega una nueva tarea' do
    todo_list = TodoList.new
    todo_list.add_task('Aprender TDD')
    task = todo_list.find_task('Aprender TDD')
    expect(task).not_to be_nil
    expect(task[:description]).to eq('Aprender TDD')
    expect(task[:completed]).to be false
  end

  it 'lista todas las tareas' do
    todo_list = TodoList.new
    todo_list.add_task('Aprender TDD')
    todo_list.add_task('Escribir código')
    tasks = todo_list.all_tasks
    expect(tasks.size).to eq(2)
  end
  
  it 'marca una tarea como completada' do
    todo_list = TodoList.new
    todo_list.add_task('Aprender TDD')
    todo_list.complete_task('Aprender TDD')
    task = todo_list.find_task('Aprender TDD')
    expect(task[:completed]).to be true
  end
  
  it 'elimina una tarea por descripción' do
    todo_list = TodoList.new
    todo_list.add_task('Aprender TDD')
    todo_list.delete_task('Aprender TDD')
    task = todo_list.find_task('Aprender TDD')
    expect(task).to be_nil
  end
end
