#!/usr/bin/env ruby

class WordSearch

  def initialize(filePath)
    @filePath = filePath
    @indexes = {}
    @pwords = []
    @wrap = false
    @n = 0
    @m = 0
    @directions = []
    (-1..1).each do |n|
      (-1..1).each do |m|
        if [n, m] == [0, 0]
          next
        else
          @directions.push [n, m]
        end
      end
    end
  end

  def run
    mkIndexes
    @pwords.each { |word| findWords(word) }
  end

  protected
  def mkIndexes
    f = open(@filePath, 'r')
    @n, @m = f.readline.strip.split(' ')
    @n = @n.to_i
    @m = @m.to_i
    for i in 0...@n
      line = f.readline.strip
      for n in 0...@m
        if @indexes[line[n]] == nil then @indexes[line[n]] = [[i, n]] else @indexes[line[n]].push [i, n] end
      end
    end
    @wrap = true if f.readline.strip == 'WRAP'
    f.readline.to_i.times {@pwords.push f.readline.strip}
    f.close
  end

  def numFix(x, y, len)
    if @wrap
      if x + y >= len
        return x + y - len
      elsif x + y < 0
        return x + y + len
      else
        return x + y
      end
    else
      return x + y
    end
  end

  def findWords(word)
    if @indexes[word[0]] == nil
      puts 'NOT FOUND'
      return false
    end
    wLen = word.length
    @indexes[word[0]].each do |firstPos|
      for d in @directions
        last = firstPos
        pList = [firstPos]
        for i in 1...wLen
          thisPos = [numFix(last[0], d[0], @n), numFix(last[1], d[1], @m)]
          if thisPos[0] < 0 or thisPos[0] >= @n or thisPos[1] < 0 or thisPos[1] >= @m
            break            
          end
          if @indexes[word[i]] == nil or @indexes[word[i]].include?(thisPos) == false or pList.include?(thisPos)
            break
          end
          last = thisPos
          pList.push thisPos
          if i == wLen - 1
            puts "(#{pList[0][0]},#{pList[0][1]}) (#{pList[-1][0]},#{pList[-1][1]})"
            return true
          end
        end
      end
      puts 'NOT FOUND'
      return false
    end
  end

end

filePath = ARGV[0] ? ARGV[0] : 'input_wrap.txt'
WordSearch.new(filePath).run