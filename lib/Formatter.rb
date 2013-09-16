require './lib/Constants.rb'
class Formatter
  attr_reader :currentStatusMessage
  
  def initialize()
    @countParentheses = 0
    @countBraces = 0
    @countTab = 0
    @text = Constants::EMPTY_SYMBOL
    @lastSymbol = Constants::EMPTY_SYMBOL
    @beforLastSymbol = Constants::EMPTY_SYMBOL
    @dontNewLine = false
    @needTab = false
    @lastPutSymbol = Constants::EMPTY_SYMBOL
    @currentStatusMessage = nil
  end

  def doNextSymbol(symbol)
    if !symbol.empty?
      if @beforLastSymbol + @lastSymbol + symbol == Constants::FOR
        @dontNewLine = true
      end
      if @needTab && !symbol.eql?(Constants::CLOSED_BRACE) && !symbol.eql?(Constants::TAB_SYMBOL) && !symbol.eql?(Constants::SPACE)
        if @countBraces < 0 
          @currentStatusMessage = "Broken text: braces unbalanced!\n"
        else
          @text = @text + Constants::SPACE * Constants::TAB_SIZE * @countBraces
          @needTab = false
          @lastPutSymbol = Constants::SPACE
        end
      end
      if @needTab && symbol.eql?(Constants::CLOSED_BRACE) && !symbol.eql?(Constants::TAB_SYMBOL) && !symbol.eql?(Constants::SPACE)
        if @countBraces < 1 
          @currentStatusMessage = "Broken text: braces unbalanced!\n"
          @countBraces = 2
        else
          @text = @text + Constants::SPACE * Constants::TAB_SIZE * (@countBraces - 1)
          @needTab = false
          @lastPutSymbol = Constants::SPACE
        end
      end
      if symbol.eql?(Constants::OPENED_PARENTHES) then
        @countParentheses = @countParentheses + 1
        @text = @text + Constants::OPENED_PARENTHES 
        @lastPutSymbol = Constants::OPENED_PARENTHES
      elsif symbol.eql?(Constants::CLOSED_PARENTHES) then
        @countParentheses = @countParentheses - 1
        @text = @text + Constants::CLOSED_PARENTHES + Constants::SPACE
        @lastPutSymbol = Constants::OPENED_PARENTHES
      elsif symbol.eql?(Constants::OPENED_BRACE) then
        @dontNewLine = false
        @countBraces = @countBraces + 1
        @countTab = @countTab + 1
        @text = @text + Constants::OPENED_BRACE + Constants::NEW_LINE_SYMBOL
        @needTab = true
        @lastPutSymbol = Constants::NEW_LINE_SYMBOL
      elsif symbol.eql?(Constants::CLOSED_BRACE) then
        @countBraces = @countBraces - 1
        @countTab = @countTab - 1
        @text = @text + Constants::CLOSED_BRACE + Constants::NEW_LINE_SYMBOL
        @needTab = true
        @lastPutSymbol = Constants::NEW_LINE_SYMBOL
      elsif symbol.eql?(Constants::SEMICOLON) && !@dontNewLine then 
        @text = @text + Constants::SEMICOLON + Constants::NEW_LINE_SYMBOL
        @needTab = true
        @lastPutSymbol = Constants::NEW_LINE_SYMBOL
      elsif symbol.eql?(Constants::SPACE) || symbol.eql?(Constants::TAB_SYMBOL) then
        if (
          !@lastPutSymbol.eql?(Constants::SPACE) &&
          !@lastPutSymbol.eql?(Constants::TAB_SYMBOL) &&
          !@lastPutSymbol.eql?(Constants::OPENED_BRACE) &&
          !@lastPutSymbol.eql?(Constants::CLOSED_BRACE) &&
          !@lastPutSymbol.eql?(Constants::NEW_LINE_SYMBOL)
        )
          @text = @text + Constants::SPACE
          @lastPutSymbol = Constants::SPACE
        end
      elsif symbol.eql?(Constants::NEW_LINE_SYMBOL)
        
      elsif
        @text = @text + symbol
        @lastPutSymbol = symbol
      end
      @beforLastSymbol = @lastSymbol
      @lastSymbol = symbol
    end
  end

  def text
    if @countBraces != 0 then
      @currentStatusMessage = "Broken text: braces unbalanced!\n"
    elsif @countParentheses != 0 then
      @currentStatusMessage = "Broken text: parentheses unbalanced!\n"
    else
      @currentStatusMessage = "Success!\n"
    end
    @text
  end
end