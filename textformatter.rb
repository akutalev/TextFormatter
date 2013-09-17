require './lib/Formatter.rb'

inputFileName = ARGV[0];
outputFileName = ARGV[1];
formatter = Formatter.new

if (inputFileName != nil && outputFileName != nil)
  begin
    inputStream = File.new(inputFileName, 'r');
    outputStream = File.new(outputFileName, 'w')
    print formatter.formatFile(inputStream, outputStream)
  rescue
    print "No such file or directory\n"
  ensure
    inputStream.close unless inputStream.nil?
    outputStream.close unless outputStream.nil?
  end
else
  print "Some input parameters have been missed!\n"
end