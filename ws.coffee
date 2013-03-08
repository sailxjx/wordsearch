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
  inGrid: (x, y, word)->
    @start = [x, y]
    directions = [
      [0, -1],   # top
      [1, -1],   # right top
      [1, 0],    # right
      [1, 1],    # right bottom
      [0, 1],    # bottom
      [-1, 1],   # left bottom
      [-1, 0],   # left
      [-1, -1]   # left top
    ]
    for directions in directions
      end = @dirCompare(x, y, direction, word)
      if end == false then continue else return end
    return false
  dirCompare: (x, y, direction, word, i=1)->
    if i >= word.length
      return [x, y]
    x += direction[0]
    y += direction[1]
    if (x - @start[0]) % @n == 0 || (y - @start[1]) % @m == 0
      return false

filePath = 'input_wrap.txt'
ws = new WordSearch(filePath)
ws.run()