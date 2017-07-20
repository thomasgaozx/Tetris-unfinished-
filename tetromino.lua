-- tetromino

return {
	generateTetromino= function(x0,y0)
	    tSet={'I','O','T','J','L','S','Z'}
	    tType=tSet[math.random(1,7)]
	    block1,block2,block3,block4={},{},{},{}
	    block1.image=love.graphics.newImage('TetrisUnit.png')
	    block2.image=love.graphics.newImage('TetrisUnit.png')
	    block3.image=love.graphics.newImage('TetrisUnit.png')
	    block4.image=love.graphics.newImage('TetrisUnit.png')

        if tType=='I' then
        	block1.x=x0
        	block1.y=y0
        	block2.x=block1.x
        	block2.y=block1.y+1
        	block3.x=block2.x
        	block3.y=block2.y+1
        	block4.x=block3.x
        	block4.y=block3.y+1
        end

        if tType=='O' then -- Exception in rotation
        	block1.x=x0
        	block1.y=y0
        	block2.x=block1.x
        	block2.y=block1.y+1
        	block3.x=block2.x+1
        	block3.y=block2.y
        	block4.x=block3.x
        	block4.y=block3.y-1
        end

        if tType=='T' then
        	block1.x=x0
        	block1.y=y0
        	block2.x=block1.x-1
        	block2.y=block1.y
        	block3.x=block2.x+1
        	block3.y=block2.y+1
        	block4.x=block3.x+1
        	block4.y=block3.y-1        	
        end     

        if tType=='J' then
        	block1.x=x0
        	block1.y=y0
        	block2.x=block1.x-1
        	block2.y=block1.y
        	block3.x=block2.x+2
        	block3.y=block2.y
        	block4.x=block3.x
        	block4.y=block3.y+1        
        end

        if tType=='L' then
        	block1.x=x0
        	block1.y=y0
        	block2.x=block1.x+1
        	block2.y=block1.y
        	block3.x=block2.x-2
        	block3.y=block2.y
        	block4.x=block3.x
        	block4.y=block3.y+1
        end

        if tType=='S' then
        	block1.x=x0
        	block1.y=y0
        	block2.x=block1.x+1
        	block2.y=block1.y
        	block3.x=block2.x-1
        	block3.y=block2.y+1
			block4.x=block3.x-1
			block4.y=block3.y
		end

		if tType=='Z' then
			block1.x=x0
			block1.y=y0
			block2.x=block1.x-1
			block2.y=block1.y
			block3.x=block2.x+1
			block3.y=block2.y+1
			block4.x=block3.x+1
			block4.y=block3.y
		end
		return {block1,block2,block3,block4,tType}  --{block1,block2,block3,block4,tType} which is a tetromino object
	end,

	updateTetromino=function(tetromino,xx,yy) --tetromino object={tType,block1,block2,block3,block4}; xx is delta x; yy is delta y
		for i=1,4 do
			block=tetromino[i]
			block.x=block.x+xx
			block.y=block.y+yy
			tetromino[i]=block
		end           
	end,

	rotate=function(tetromino) --tetromino object={tType,block1,block2,block3,block4}
		if tetromino.tType=='O' then
			return tetromino
		else
			centralBlock=tetromino[1]
			x0=centralBlock.x
			y0=centralBlock.y
			for i=2,4 do
				block=tetromino[i]
				xi=block.x
				yi=block.y
				block.x , block.y = x0-y0+yi , y0+x0-xi
				tetromino[i]=block
			end
			return tetromino
		end
	end,

	drawTetromino = function(tetromino,grid) --tetromino object={tType,block1,block2,block3,block4}; grid object
		love.graphics.push()
		love.graphics.translate(playSpace.leftBound, playSpace.upperBound)
		for i=1,4 do
			block=tetromino[i]
			love.graphics.draw(block.image, block.x*unit, block.y*unit)
		end
		love.graphics.pop()
	end,

	reachEnd=function(tetromino,grid,playSpace) --tetromino object={tType,block1,block2,block3,block4}, grid object, playSpace object
		unit=25
		for i=1,4 do
			block=tetromino[i]
			if ((block.y)+1)>(playSpace.height/unit-1) then -- ERROR PRONE
				for i=1,4 do
					block=tetromino[i]
					grid[block.x][block.y]=true
				end
				return true
			elseif (block.y+1)<=(playSpace.height/unit-1) then
				if grid[block.x][block.y+1] then
					for i=1,4 do
						block=tetromino[i]
						grid[block.x][block.y]=true
					end
					return true
				end
			end
		end
		return false
	end
}
