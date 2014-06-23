watch("app/controllers/(.*).php") do |match|
  run_test %{app/tests/controllers/#{match[1]}Test.php}
end

watch("app/controllers/Api/v1/(.*).php") do |match|
  run_test %{app/tests/controllers/#{match[1]}Test.php}
end

def run_test(file)

  clear_console
  unless File.exist?(file)
    puts "#{file} does not exist"
    return
  end

  puts "Running #{file}"
  result = `vendor/bin/phpunit #{file}`
  puts result

  if result.match(/OK/)
    notify "#{file}", "Tests Passed Successfuly"
  elsif result.match(/FAILURES\!/)
    notify_failed file, result
  end
end


def notify title, msg
cmd = "growlnotify -t \"#{title}\" -m \"#{msg}\""
puts cmd
system "growlnotify -t \"#{title}\" -m \"#{msg}\""

end

def notify_failed cmd, result
failed_examples = result.scan(/failure:\n\n(.*)\n/)
example = "#{failed_examples[0]}"
example = example.gsub(/"/, '')
notify "FAILURE! -- #{cmd}", "#{example}"
end

def clear_console
  puts "\e[H\e[2J"  #clear console
end
