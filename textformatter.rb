require './lib/Formatter.rb'
require './lib/MessageConstants.rb'

require 'rubygems'
require 'log4r'
require 'log4r/configurator'

include Log4r

Configurator.load_xml_file('./configs/log4r.xml')
log = Logger["Logger"]

inputFileName = ARGV[0];
outputFileName = ARGV[1];
formatter = Formatter.new

if (!inputFileName.nil? && !inputFileName.empty? && !outputFileName.nil? && !outputFileName.empty?)
  begin
    inputStream = File.new(inputFileName, 'r');
    outputStream = File.new(outputFileName, 'w')
    log.info(formatter.format(inputStream, outputStream))
  rescue Exception => e
    log.fatal(MessageConstants::ERROR + MessageConstants::COLON + e.message + MessageConstants::NEW_LINE_SYMBOL)
  ensure
    inputStream.close unless inputStream.nil?
    outputStream.close unless outputStream.nil?
  end
else
  log.fatal(MessageConstants::ERROR + MessageConstants::COLON + MessageConstants::PARAM_MISSING + MessageConstants::NEW_LINE_SYMBOL)
end