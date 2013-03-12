#!/usr/bin/env ruby

class WordSearch

  def initialize(filePath)
    @filePath = filePath
    @grid = []
    @pwords = []
    @wrap = false
    @n = 0
    @m = 0
    @start = []
  end

  def run
    makeGrid
    @pwords.each { |word| findWords(word) }
  end

  private

  def makeGrid
    f = open(@filePath, 'r')
    @n, @m = f.readline.strip.split(' ')
    @n = @n.to_i
    @m = @m.to_i
    @n.times { @grid.push f.readline.strip }
    @wrap = true if f.readline.strip == 'WRAP'
    if @wrap == true
      @grid.map! { |x| x *= 2 }
      @grid *= 2
    end
    f.readline.to_i.times { @pwords.push f.readline.strip }
    f.close
  end

  def findWords(word)
    for x in 0...@grid.length
      for y in 0...@grid[x].length
        if @grid[x][y] == word[0]
          endPoint = inGrid(x, y, word)
          if endPoint == false
            next
          else
            if @wrap ==  true
              if x >= @n then x -= @n end
              if y >= @m then y -= @m end
              if endPoint[0] >= @n then endPoint[0] -= @n end
              if endPoint[1] >= @m then endPoint[1] -= @m end
            end
            puts "(#{x},#{y}) (#{endPoint[0]},#{endPoint[1]})"
            return true
          end
        end
      end
    end
    puts 'NOT FOUND'
    return false
  end

  def inGrid(x, y, word)
    @start = [x, y]
    directions = []
    (-1..1).each do |n|
      (-1..1).each do |m|
        if [n, m] == [0, 0]
          next
        else
          directions.push [n, m]
        end
      end
    end
    directions.each do |d|
      endPoint = dirCompare(x, y, d, word)
      if endPoint == false then next else return endPoint end
    end
    return false
  end

  def dirCompare(x, y, direction, word, i=1)
    if i >= word.length
      return [x, y]
    end
    x += direction[0]
    y += direction[1]
    if @wrap == true then ratio = 2 else ratio = 1 end
    if x < 0 || y < 0 || x >= @n * ratio || y >= @m * ratio then return false end
    if (x - @start[0]) % @n == 0 && (y - @start[1]) % @m == 0 then return false end
    if @grid[x][y] == word[i] then return dirCompare(x, y, direction, word, i+1) end
    return false
  end
end

filePath = ARGV[0] ? ARGV[0] : 'input_wrap.txt'
ws = WordSearch.new(filePath)
ws.run
