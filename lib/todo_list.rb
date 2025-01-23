# lib/todo_list.rb
class TodoList
  def initialize
    @tasks = []
  end

  def add_task(description)
    @tasks << { description: description, completed: false }
  end

  def find_task(description)
    @tasks.find { |task| task[:description] == description }
  end

  def all_tasks
    @tasks
  end
  
  def complete_task(description)
    task = find_task(description)
    task[:completed] = true if task
  end
  
  def delete_task(description)
    @tasks.reject! { |task| task[:description] == description }
  end
end
