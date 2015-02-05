
//Stencil Wrapper Module by Bobblehead

//Override stencils to add accessors.


local StencilZFail = STENCIL_KEEP
local oldFunc1 = render.SetStencilZFailOperation
function render.SetStencilZFailOperation(a)
	oldFunc1(a)
	StencilZFail = a
end
function render.GetStencilZFailOperation()
	return StencilZFail
end

local StencilFail = STENCIL_KEEP
local oldFunc2 = render.SetStencilFailOperation
function render.SetStencilFailOperation(a)
	oldFunc2(a)
	StencilFail = a
end
function render.GetStencilFailOperation()
	return StencilFail
end

local StencilPass = STENCIL_KEEP
local oldFunc3 = render.SetStencilPassOperation
function render.SetStencilPassOperation(a)
	oldFunc3(a)
	StencilPass = a
end
function render.GetStencilPassOperation()
	return StencilPass
end

local CompareFunc = STENCIL_ALWAYS
local oldFunc4 = render.SetStencilCompareFunction
function render.SetStencilCompareFunction(a)
	oldFunc4(a)
	CompareFunc = a
end
function render.GetStencilCompareFunction()
	return CompareFunc
end

local Test = 3
local oldFunc5 = render.SetStencilTestMask
function render.SetStencilTestMask(a)
	oldFunc5(a)
	Test = a
end
function render.GetStencilTestMask()
	return Test
end

local Write = 3
local oldFunc6 = render.SetStencilWriteMask
function render.SetStencilWriteMask(a)
	oldFunc6(a)
	Write = a
end
function render.GetStencilWriteMask()
	return Write
end

local Enabled = false
local oldFunc7 = render.SetStencilEnable
function render.SetStencilEnable(a)
	oldFunc7(a)
	Enabled = a
end
function render.GetStencilEnable()
	return Enabled
end

local ReferenceValue = 0
local oldFunc8 = render.SetStencilReferenceValue
function render.SetStencilReferenceValue(a)
	oldFunc8(a)
	ReferenceValue = a
end
function render.GetStencilReferenceValue()
	return ReferenceValue
end


local r = render

//Begin Wrapper Module:

module("stencil",package.seeall)

Stack = util.Stack()

//Pushing and Popping prevents stencil states from overriding each other.
//Every stencil function must have been called once before saving a stencil state.
function Push()
	local data = {r.GetStencilZFailOperation()or STENCIL_KEEP,
	r.GetStencilWriteMask()or 3, r.GetStencilTestMask()or 3, r.GetStencilReferenceValue()or 0,
	r.GetStencilPassOperation()or STENCIL_KEEP, r.GetStencilFailOperation()or STENCIL_KEEP, r.GetStencilEnable()or false,
	r.GetStencilCompareFunction()or STENCIL_ALWAYS}
	Stack:Push(data)
end
function Pop()
	Stack:Pop()
	local data = Stack:Top()
	if data then
		r.SetStencilZFailOperation(data[1])
		r.SetStencilWriteMask(data[2])
		r.SetStencilTestMask(data[3])
		r.SetStencilReferenceValue(data[4])
		r.SetStencilPassOperation(data[5])
		r.SetStencilFailOperation(data[6])
		r.SetStencilEnable(data[7])
		r.SetStencilCompareFunction(data[8])
	end
end

//Mask functions, and combination:
function TestMask(int)
	r.SetStencilTestMask(int)
end
function WriteMask(int)
	r.SetStencilWriteMask(int)
end
function Mask(int)
	TestMask(int)
	WriteMask(int)
end

//Operations:
function ZFail(oper)
	r.SetStencilZFailOperation(oper)
end
function Fail(oper)
	r.SetStencilFailOperation(oper)
end
function Pass(oper)
	r.SetStencilPassOperation(oper)
end
function SetOperations(pass,fail,zfail)
	Pass(pass)
	Fail(fail)
	ZFail(zfail)
end

//Comparison Function:
function Compare(f)
	r.SetStencilCompareFunction(f)
end

//Reference Value:
function Reference(num)
	r.SetStencilReferenceValue(num)
end

//Enabled:
function Enable(b)
	r.SetStencilEnable(b)
end

//Clear:
function Clear()
	r.ClearStencil()
end


