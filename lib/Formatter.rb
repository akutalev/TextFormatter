require './lib/TextConstants.rb'
require './lib/CustomConstants.rb'
require './lib/MessageConstants.rb'

class Formatter
  attr_reader :statusMessage

  def initialize()
    @countParentheses = 0
    @countBraces = 0
    @countTab = 0
    @returningSymbol = TextConstants::EMPTY_SYMBOL
    @lastSymbol = TextConstants::EMPTY_SYMBOL
    @beforLastSymbol = TextConstants::EMPTY_SYMBOL
    @dontNewLine = false
    @needTab = false
    @lastPutSymbol = TextConstants::EMPTY_SYMBOL
    @statusMessage = nil
    @isError = false
  end

  def format(inputIOStream, outputIOStream)
    if !inputIOStream.nil? && !outputIOStream.nil?
      if inputIOStream.respond_to?(:each_char)
        begin
          inputIOStream.each_char do |symbol|
            returnedSymbol = doNextSymbol(symbol)
            if returnedSymbol != nil || !returnedSymbol.empty?
              outputIOStream.print(returnedSymbol)
            end
          end
        rescue Exception => e
          @statusMessage = e.message
          @isError = true
        ensure
        end
      else
        @statusMessage = MessageConstants::ERROR + MessageConstants::COLON + MessageConstants::WRONG_STREAM + MessageConstants::EXCLAMATION_MARK + MessageConstants::NEW_LINE_SYMBOL
      end
    else 
      @statusMessage = MessageConstants::ERROR + MessageConstants::COLON + MessageConstants::EMPTY_STREAM + MessageConstants::EXCLAMATION_MARK + MessageConstants::NEW_LINE_SYMBOL
    end
    return statusMessage
  end

  def statusMessage
    if @countBraces != 0 then
      @statusMessage =  MessageConstants::ERROR + MessageConstants::COLON +
        MessageConstants::ERROR_BRACES_UNBALANCED + MessageConstants::EXCLAMATION_MARK + MessageConstants::NEW_LINE_SYMBOL
    elsif @countParentheses != 0 then
      @statusMessage =  MessageConstants::ERROR + MessageConstants::COLON +
        MessageConstants::ERROR_PARENTHESES_UNBALANCED + MessageConstants::EXCLAMATION_MARK + MessageConstants::NEW_LINE_SYMBOL
    elsif @statusMessage.nil?
      @statusMessage = MessageConstants::SUCCESS + MessageConstants::EXCLAMATION_MARK + MessageConstants::NEW_LINE_SYMBOL
    end
    @statusMessage
  end

private
  def doNextSymbol(symbol)
    @returningSymbol = TextConstants::EMPTY_SYMBOL
    if !symbol.empty? && !@isError
      if @beforLastSymbol + @lastSymbol + symbol == TextConstants::FOR
        @dontNewLine = true
      end
      if @needTab && !symbol.eql?(TextConstants::CLOSED_BRACE) && !symbol.eql?(TextConstants::TAB_SYMBOL) && !symbol.eql?(TextConstants::SPACE)
        if @countBraces < 0 
          @statusMessage = MessageConstants::ERROR + MessageConstants::COLON +
            MessageConstants::ERROR_BRACES_UNBALANCED + MessageConstants::EXCLAMATION_MARK + MessageConstants::NEW_LINE_SYMBOL
          @isError = true
        else
          @returningSymbol = @returningSymbol + CustomConstants::INDENT_SYMBOL * CustomConstants::TAB_SIZE * @countBraces
          @needTab = false
          @lastPutSymbol = CustomConstants::INDENT_SYMBOL
        end
      end
      if @needTab && symbol.eql?(TextConstants::CLOSED_BRACE) && !symbol.eql?(TextConstants::TAB_SYMBOL) && !symbol.eql?(TextConstants::SPACE)
        if @countBraces < 1 
          @statusMessage = MessageConstants::ERROR + MessageConstants::COLON +
            MessageConstants::ERROR_BRACES_UNBALANCED + MessageConstants::EXCLAMATION_MARK + MessageConstants::NEW_LINE_SYMBOL
          @isError = true
        else
          @returningSymbol = @returningSymbol + CustomConstants::INDENT_SYMBOL * CustomConstants::TAB_SIZE * (@countBraces - 1)
          @needTab = false
          @lastPutSymbol = CustomConstants::INDENT_SYMBOL
        end
      end
      if symbol.eql?(TextConstants::OPENED_PARENTHES) then
        @countParentheses = @countParentheses + 1
        @returningSymbol = @returningSymbol + TextConstants::OPENED_PARENTHES 
        @lastPutSymbol = TextConstants::OPENED_PARENTHES
      elsif symbol.eql?(TextConstants::CLOSED_PARENTHES) then
        @countParentheses = @countParentheses - 1
        @returningSymbol = @returningSymbol + TextConstants::CLOSED_PARENTHES + TextConstants::SPACE
        @lastPutSymbol = TextConstants::OPENED_PARENTHES
      elsif symbol.eql?(TextConstants::OPENED_BRACE) then
        @dontNewLine = false
        @countBraces = @countBraces + 1
        @countTab = @countTab + 1
        @returningSymbol = @returningSymbol + TextConstants::OPENED_BRACE + TextConstants::NEW_LINE_SYMBOL
        @needTab = true
        @lastPutSymbol = TextConstants::NEW_LINE_SYMBOL
      elsif symbol.eql?(TextConstants::CLOSED_BRACE) then
        @countBraces = @countBraces - 1
        @countTab = @countTab - 1
        @returningSymbol = @returningSymbol + TextConstants::CLOSED_BRACE + TextConstants::NEW_LINE_SYMBOL
        @needTab = true
        @lastPutSymbol = TextConstants::NEW_LINE_SYMBOL
      elsif symbol.eql?(TextConstants::SEMICOLON) && !@dontNewLine then 
        @returningSymbol = @returningSymbol + TextConstants::SEMICOLON + TextConstants::NEW_LINE_SYMBOL
        @needTab = true
        @lastPutSymbol = TextConstants::NEW_LINE_SYMBOL
      elsif symbol.eql?(TextConstants::SPACE) || symbol.eql?(TextConstants::TAB_SYMBOL) then
        if (
          !@lastPutSymbol.eql?(TextConstants::SPACE) &&
          !@lastPutSymbol.eql?(TextConstants::TAB_SYMBOL) &&
          !@lastPutSymbol.eql?(TextConstants::OPENED_BRACE) &&
          !@lastPutSymbol.eql?(TextConstants::CLOSED_BRACE) &&
          !@lastPutSymbol.eql?(TextConstants::NEW_LINE_SYMBOL)
        )
          @returningSymbol = @returningSymbol + TextConstants::SPACE
          @lastPutSymbol = TextConstants::SPACE
        end
      elsif symbol.eql?(TextConstants::NEW_LINE_SYMBOL)
        
      elsif
        @returningSymbol = @returningSymbol + symbol
        @lastPutSymbol = symbol
      end
      @beforLastSymbol = @lastSymbol
      @lastSymbol = symbol
      return @returningSymbol
    end
  end

end