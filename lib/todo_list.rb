require 'json'

class TodoList
  def initialize(file_path = 'tasks.json')
    @file_path = file_path
    @tasks = load_tasks
    @next_id = @tasks.empty? ? 1 : @tasks.map { |task| task[:id] }.max + 1
  end

  def add_task(description)
    id = @next_id
    @tasks << { id: id, description: description, completed: false }
    @next_id += 1
    save_tasks
    id
  end

  def find_task_by_id(id)
    @tasks.find { |task| task[:id] == id }
  end

  def all_tasks
    @tasks
  end

  def complete_task(id)
    task = find_task_by_id(id)
    if task
      task[:completed] = true
      save_tasks
    end
  end

  def delete_task(id)
    @tasks.reject! { |task| task[:id] == id }
    save_tasks
  end

  def edit_task_description(id, new_description)
    task = find_task_by_id(id)
    if task
      task[:description] = new_description
      task[:completed] = false
      save_tasks
    end
  end

  def completed_tasks
    @tasks.select { |task| task[:completed] }
  end

  private

  def load_tasks
    if File.exist?(@file_path)
      JSON.parse(File.read(@file_path), symbolize_names: true)
    else
      []
    end
  end

  def save_tasks
    File.open(@file_path, 'w') do |file|
      file.write(JSON.pretty_generate(@tasks))
    end
  end
end
