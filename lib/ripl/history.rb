module Ripl::History
  def history_file
    @history_file ||= File.expand_path(config[:history])
  end

  def history; @history; end

  def get_input
    (@history << super)[-1]
  end

  def before_loop
    @history = []
    super
    File.exists?(history_file) &&
      IO.readlines(history_file).each {|e| history << e.chomp }
  end

  def write_history
    File.open(history_file, 'w') {|f| f.write Array(history).join("\n") }
  end
  # alias_method would make overriding write_history useless because
  # it will have a copy of write_history and call it in after_loop.
  def after_loop; write_history; end
end
Ripl::Shell.include Ripl::History
Ripl.config[:history] = '~/.irb_history'
