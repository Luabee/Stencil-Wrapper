

local r = render

require("stencil")

module("csg",package.seeall)

//Add two draw functions together, and then draw the third over them both.
function Add(draw1,draw2,draw3)
	
	return function()
		stencil.Push()
			
			r.SetStencilCompareFunction(STENCIL_NEVER)
			r.SetStencilPassOperation(STENCIL_KEEP)
			r.SetStencilFailOperation(STENCIL_REPLACE)
			r.SetStencilZFailOperation(STENCIL_REPLACE)
			
			draw1()
			
			draw2()
			
			r.SetStencilCompareFunction(STENCIL_LESSEQUAL)
			r.SetStencilZFailOperation(STENCIL_KEEP)
			r.SetStencilFailOperation(STENCIL_KEEP)
			
			draw3()
		
		stencil.Pop()
		
	end
end

//Remove draw2 from draw1.
function Subtract(draw1,draw2)
	
	return function()
	
		stencil.Push()
			
			r.SetStencilCompareFunction(STENCIL_NEVER)
			r.SetStencilPassOperation(STENCIL_KEEP)
			r.SetStencilFailOperation(STENCIL_REPLACE)
			r.SetStencilZFailOperation(STENCIL_REPLACE)
			
			draw2()
			
			r.SetStencilCompareFunction(STENCIL_NOTEQUAL)
			r.SetStencilZFailOperation(STENCIL_KEEP)
			r.SetStencilFailOperation(STENCIL_KEEP)
			
			draw1()
			
		stencil.Pop()
		
	end
	
end

//Keep the place where draw1 and draw2 both exist, and draw3 over that area.
function Union(draw1,draw2,draw3)
	return function()
		stencil.Push()
			
			r.SetStencilCompareFunction(STENCIL_NEVER)
			r.SetStencilPassOperation(STENCIL_KEEP)
			r.SetStencilFailOperation(STENCIL_REPLACE)
			r.SetStencilZFailOperation(STENCIL_REPLACE)
			
			draw1()
			
			r.SetStencilFailOperation(STENCIL_DECR)
			r.SetStencilZFailOperation(STENCIL_DECR)
			
			draw2()
			
			
			r.SetStencilCompareFunction(STENCIL_LESS)
			r.SetStencilZFailOperation(STENCIL_KEEP)
			r.SetStencilFailOperation(STENCIL_KEEP)
			
			draw3()
			
		stencil.Pop()
	end
end

function StartTree()
	stencil.Push()
	stencil.Enable(true)
end
Start = StartTree

function StopTree()
	stencil.Pop()
end
EndTree = StopTree
End = StopTree
Stop = StopTree

