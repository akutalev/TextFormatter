require './lib/Constants.rb'
class Formatter
  attr_reader :text
  
  def initialize()
    @countParentheses = 0
    @countBraces = 0
    @countTab = 0
    @text = ""
    @lastSymbol = ""
    @beforLastSymbol = ""
    @dontEnter = false
    @needTab = false
  end

  def doNextSymbol(symbol)
    if !symbol.empty?
      if @beforLastSymbol + @lastSymbol + symbol == Constants::FOR
        @dontEnter = true
      end
      if @needTab && !symbol.eql?(Constants::CLOSED_BRACE)
      	@text = @text + Constants::SPACE * Constants::TAB_SIZE * @countBraces
      	@needTab = false
      end
      if @needTab && symbol.eql?(Constants::CLOSED_BRACE)
      	@text = @text + Constants::SPACE * Constants::TAB_SIZE * (@countBraces - 1)
      	@needTab = false
      end
      if symbol.eql?(Constants::OPENED_PARENTHES) then
        @countParentheses = @countParentheses + 1
        @text = @text + Constants::OPENED_PARENTHES 
      elsif symbol.eql?(Constants::CLOSED_PARENTHES) then
        @countParentheses = @countParentheses - 1
        @text = @text + Constants::CLOSED_PARENTHES + Constants::SPACE
      elsif symbol.eql?(Constants::OPENED_BRACE) then
      	@dontEnter = false
        @countBraces = @countBraces + 1
        @countTab = @countTab + 1
        @text = @text + Constants::OPENED_BRACE + Constants::NEW_LINE
        @needTab = true
      elsif symbol.eql?(Constants::CLOSED_BRACE) then
        @countBraces = @countBraces - 1
        @countTab = @countTab - 1
        @text = @text + Constants::CLOSED_BRACE + Constants::NEW_LINE
        @needTab = true
      elsif symbol.eql?(Constants::SEMICOLON) && !@dontEnter then 
        @text = @text + Constants::SEMICOLON + Constants::NEW_LINE
        @needTab = true
      elsif symbol.eql?(Constants::SPACE || Constants::NEW_LINE) then
      elsif
        @text = @text + symbol
      end
      @beforLastSymbol = @lastSymbol
      @lastSymbol = symbol
    end
  end
end