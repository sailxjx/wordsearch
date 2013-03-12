#!/usr/bin/env coffee

fs = require 'fs'

class WordSearch
  filePath: null
  grid: []
  pwords: []
  wrap: false
  n: 0
  m: 0
  start: []
  constructor: (filePath)->
    @filePath = filePath
  run: ->
    fs.readFile @filePath, (err, data)=>
      @makeGrid(data.toString())
      for word in @pwords
        @findWords(word)
  makeGrid: (fileData)->
    srcData = fileData.split "\n"
    [@n, @m] = srcData[0].split " "
    for i in [1..@n]
      @grid.push srcData[i]
    cLine = parseInt(@n) + 1
    if srcData[cLine] == 'WRAP' then @wrap = true else @wrap = false
    if @wrap
      for i of @grid
        @grid[i] += @grid[i]
        @grid.push @grid[i]
    cLine += 1
    p = parseInt(srcData[cLine])
    for i in [cLine + 1..cLine + p]
      @pwords.push srcData[i]
  findWords: (word)->
    for x in [0...@grid.length]
      for y in [0...@grid[x].length]
        if @grid[x][y] == word[0]
          end = @inGrid(x, y, word)
          if end == false
            continue
          else
            if @wrap
              if x >= @n then x -= @n
              if y >= @m then y -= @m
              if end[0] >= @n then end[0] -= @n
              if end[1] >= @m then end[1] -= @m
            console.log "(#{x},#{y}) (#{end[0]},#{end[1]})"
            return true
    console.log 'NOT FOUND'
    return false
  inGrid: (x, y, word)->
    @start = [x, y]
    directions = []
    for n in [-1..1]
      for m in [-1..1]
        if [n, m] == [0, 0]
          continue
        else
          directions.push [n, m]
    for direction in directions
      end = @dirCompare(x, y, direction, word)
      if end == false then continue else return end
    return false
  dirCompare: (x, y, direction, word, i=1)->
    if i >= word.length
      return [x, y]
    x += direction[0]
    y += direction[1]
    # multiplied by the ratio to determine the boundary
    if @wrap == true then ratio = 2 else ratio = 1
    # out of array index
    if x < 0 || y < 0 || x >= @n * ratio || y >= @m * ratio
      return false
    # letter repeated
    if (x - @start[0]) % @n == 0 && (y - @start[1]) % @m == 0
      return false
    if @grid[x][y] == word[i]
      return @dirCompare(x, y, direction, word, i + 1)
    return false

filePath = if process.argv[2]? then process.argv[2] else 'input_wrap.txt'
ws = new WordSearch(filePath)
ws.run()