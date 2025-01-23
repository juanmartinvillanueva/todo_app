require_relative 'lib/todo_list'

# Crear una instancia de TodoList
todo_list = TodoList.new

def display_menu
  puts "\n--- Lista de Tareas ---"
  puts "1. Agregar tarea"
  puts "2. Listar todas las tareas"
  puts "3. Completar tarea"
  puts "4. Editar tarea"
  puts "5. Eliminar tarea"
  puts "6. Listar tareas completadas"
  puts "7. Salir"
  print "Elige una opción: "
end

loop do
  display_menu
  option = gets.chomp.to_i

  case option
  when 1
    print "Descripción de la nueva tarea: "
    description = gets.chomp
    id = todo_list.add_task(description)
    puts "Tarea agregada con ID: #{id}"

  when 2
    puts "\n--- Todas las Tareas ---"
    tasks = todo_list.all_tasks
    tasks.each_with_index do |task, index|
      status = task[:completed] ? "Completada" : "Pendiente"
      puts "#{index + 1}. [ID: #{task[:id]}] #{task[:description]} - #{status}"
    end

  when 3
    print "ID de la tarea a completar: "
    id = gets.chomp.to_i
    todo_list.complete_task(id)
    puts "Tarea completada."

  when 4
    print "ID de la tarea a editar: "
    id = gets.chomp.to_i
    print "Nueva descripción: "
    new_description = gets.chomp
    todo_list.edit_task_description(id, new_description)
    puts "Tarea editada y marcada como pendiente."

  when 5
    print "ID de la tarea a eliminar: "
    id = gets.chomp.to_i
    todo_list.delete_task(id)
    puts "Tarea eliminada."

  when 6
    puts "\n--- Tareas Completadas ---"
    completed_tasks = todo_list.completed_tasks
    completed_tasks.each_with_index do |task, index|
      puts "#{index + 1}. [ID: #{task[:id]}] #{task[:description]}"
    end

  when 7
    puts "Saliendo..."
    break

  else
    puts "Opción inválida. Por favor, elige una opción del 1 al 7."
  end
end
