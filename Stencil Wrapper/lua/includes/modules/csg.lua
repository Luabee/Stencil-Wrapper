

local r = render

require("stencil")

module("csg",package.seeall)

//Add two draw functions together, and then draw the third over them both.
function Add(draw1,draw2,draw3)
	
	return function()
		r.SetStencilTestMask(3)
		r.SetStencilWriteMask(3)
		
		r.SetStencilReferenceValue(1)
		r.SetStencilCompareFunction(STENCIL_NEVER)
		r.SetStencilPassOperation(STENCIL_KEEP)
		r.SetStencilFailOperation(STENCIL_REPLACE)
		r.SetStencilZFailOperation(STENCIL_REPLACE)
		
		stencil.Push()
		draw1()
		stencil.Pop()
		stencil.Push()
		draw2()
		stencil.Pop()
		
		r.SetStencilCompareFunction(STENCIL_LESSEQUAL)
		r.SetStencilZFailOperation(STENCIL_KEEP)
		r.SetStencilFailOperation(STENCIL_KEEP)
		stencil.Push()
		draw3()
		stencil.Pop()
		
	end
end

//Remove draw2 from draw1.
function Subtract(draw1,draw2)
	
	return function()
		r.SetStencilTestMask(3)
		r.SetStencilWriteMask(3)
		
		r.SetStencilReferenceValue(1)
		r.SetStencilCompareFunction(STENCIL_NEVER)
		r.SetStencilPassOperation(STENCIL_KEEP)
		r.SetStencilFailOperation(STENCIL_REPLACE)
		r.SetStencilZFailOperation(STENCIL_REPLACE)
		
		stencil.Push()
		draw2()
		stencil.Pop()
		
		r.SetStencilCompareFunction(STENCIL_NOTEQUAL)
		r.SetStencilZFailOperation(STENCIL_KEEP)
		r.SetStencilFailOperation(STENCIL_KEEP)
		
		stencil.Push()
		draw1()
		stencil.Pop()
		
	end
	
end

//Keep the place where draw1 and draw2 both exist, and draw3 over that area.
function Union(draw1,draw2,draw3)
	return function()
		r.SetStencilTestMask(3)
		r.SetStencilWriteMask(3)
		
		r.SetStencilReferenceValue(1)
		r.SetStencilCompareFunction(STENCIL_NEVER)
		r.SetStencilPassOperation(STENCIL_KEEP)
		r.SetStencilFailOperation(STENCIL_REPLACE)
		r.SetStencilZFailOperation(STENCIL_REPLACE)
		
		stencil.Push()
		draw1()
		stencil.Pop()
		
		r.SetStencilFailOperation(STENCIL_DECR)
		r.SetStencilZFailOperation(STENCIL_DECR)
		
		stencil.Push()
		draw2()
		stencil.Pop()
		
		
		r.SetStencilCompareFunction(STENCIL_LESS)
		r.SetStencilZFailOperation(STENCIL_KEEP)
		r.SetStencilFailOperation(STENCIL_KEEP)
		
		stencil.Push()
		draw3()
		stencil.Pop()
	end
end

function StartTree()
	r.SetStencilEnable(true)
end
Start = StartTree

function StopTree()
	r.SetStencilEnable(false)
	r.ClearStencil()
end
EndTree = StopTree
End = StopTree
Stop = StopTree

