#!/usr/bin/env python

import sys


class WordSearch(object):
    filePath = None
    __grid = []
    __pwords = []
    __wrap = False
    __n = 0  # n rows
    __m = 0  # m letters
    __start = []  # the start point

    def __init__(self, filePath):
        self.filePath = filePath

    def run(self):
        self.__makeGrid()
        for word in self.__pwords:
            self.__findWords(word)

    def __makeGrid(self):
        grid = []
        pwords = []
        f = open(self.filePath, 'r')
        [n, m] = f.readline().strip().split(" ")  # n rows of m letters
        n = int(n)
        m = int(m)
        for i in xrange(n):
            grid.append(f.readline().strip())
        wrap = True if f.readline().strip() == 'WRAP' else False
        if wrap:  # need wrap
            for i in xrange(len(grid)):
                grid[i] *= 2
            grid *= 2
        p = int(f.readline())
        for i in xrange(p):
            pwords.append(f.readline().strip())
        f.close()
        self.__wrap = wrap
        self.__grid = grid
        self.__n = n
        self.__m = m
        self.__pwords = pwords

    def __findWords(self, word):
        grid = self.__grid
        for x in xrange(len(grid)):
            for y in xrange(len(grid[x])):
                if grid[x][y] == word[0]:
                    end = self.__inGrid(x, y, word)
                    if end is False:
                        continue
                    else:
                        if self.__wrap:
                            x = x - self.__n if x >= self.__n else x  # be sure the letter index is in grid
                            y = y - self.__m if y >= self.__m else y
                            end[0] = end[0] - self.__n if end[0] >= self.__n else end[0]
                            end[1] = end[1] - self.__m if end[1] >= self.__m else end[1]
                        print '(%s,%s) (%s,%s)' % (x, y, end[0], end[1])
                        return True  # break while find the word in grid
        print 'NOT FOUND'
        return False

    def __inGrid(self, x, y, word):  # whether the word is in 8 directions of the grid; return the end point
        self.__start = [x, y]
        directions = []
        for n in xrange(-1, 2):
            for m in xrange(-1, 2):
                if [n, m] == [0, 0]:
                    continue
                else:
                    directions.append([n, m])
        for direction in directions:
            end = self.__dirCompare(x, y, direction, word)
            if end is False:
                continue
            else:
                return end
        return False

    def __dirCompare(self, x, y, direction, word, i=1):
        try:
            if i >= len(word):  # return success if reach the end of word
                return [x, y]
            x += direction[0]
            y += direction[1]
            if (x - self.__start[0]) % self.__n == 0 and (y - self.__start[1]) % self.__m == 0:  # break if the letter is repeated
                return False
            if x < 0 or y < 0 or x >= len(self.__grid) or y >= len(self.__grid):
                return False
            if self.__grid[x][y] == word[i]:
                return self.__dirCompare(x, y, direction, word, i + 1)
            else:
                return False
        except IndexError:
            return False

filePath = 'input_wrap.txt' if len(sys.argv) < 2 else sys.argv[1]
ws = WordSearch(filePath)
if __name__ == '__main__':
    ws.run()
