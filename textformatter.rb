require './lib/Formatter.rb'


formatter = Formatter.new
print formatter.text

javaText = File.open('input.java', 'r'){ |file| file.read }
javaText.each_char do |symbol|
  formatter.doNextSymbol(symbol)
end
File.open('output.txt', 'w') { |file| file.write(formatter.text) }