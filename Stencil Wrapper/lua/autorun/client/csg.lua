

//Fix draw.RoundedBox() to work with stencils.
local mat1 = CreateMaterial( "corner8", "UnlitGeneric", {
	[ "$basetexture" ] = "gui/corner8",	
	[ "$alphatest" ] = 1,
 } )
 local mat2 = CreateMaterial( "corner16", "UnlitGeneric", {
	[ "$basetexture" ] = "gui/corner16",	
	[ "$alphatest" ] = 1,
 } )
function draw.RoundedBoxEx( bordersize, x, y, w, h, color, a, b, c, d )

	x = math.Round( x )
	y = math.Round( y )
	w = math.Round( w )
	h = math.Round( h )

	surface.SetDrawColor( color.r, color.g, color.b, color.a )
	
	-- Draw as much of the rect as we can without textures
	surface.DrawRect( x+bordersize, y, w-bordersize*2, h )
	surface.DrawRect( x, y+bordersize, bordersize, h-bordersize*2 )
	surface.DrawRect( x+w-bordersize, y+bordersize, bordersize, h-bordersize*2 )
	
	local tex = mat1
	if ( bordersize > 8 ) then tex = mat2 end
	
	surface.SetMaterial( tex )
	
	if ( a ) then
		surface.DrawTexturedRectRotated( x + bordersize/2 , y + bordersize/2, bordersize, bordersize, 0 ) 
	else
		surface.DrawRect( x, y, bordersize, bordersize )
	end
	
	if ( b ) then
		surface.DrawTexturedRectRotated( x + w - bordersize/2 , y + bordersize/2, bordersize, bordersize, 270 ) 
	else
		surface.DrawRect( x + w - bordersize, y, bordersize, bordersize )
	end
 
	if ( c ) then
		surface.DrawTexturedRectRotated( x + bordersize/2 , y + h -bordersize/2, bordersize, bordersize, 90 )
	else
		surface.DrawRect( x, y + h - bordersize, bordersize, bordersize )
	end
 
	if ( d ) then
		surface.DrawTexturedRectRotated( x + w - bordersize/2 , y + h - bordersize/2, bordersize, bordersize, 180 )
	else
		surface.DrawRect( x + w - bordersize, y + h - bordersize, bordersize, bordersize )
	end
	
end

//Run CSG module.
require("csg")


//Examples:
--[[
local Box = function() --Red
	surface.SetDrawColor(255,0,0,100)
	surface.DrawRect(100,100,200,200)
end
local Triangle = function() --Green
	local PolyData = {{x=200,y=150},{x=150,y=200},{x=250,y=200}}
	
	surface.SetDrawColor(0,255,0,100)
	surface.DrawPoly(PolyData)
end
local Circle = function(ox,oy) --Blue
	local PolyData = {}
	local originx = ox or 300
	local originy = oy or 300
	local radius = 50
	for deg=0, 359 do
		local x,y = math.cos(math.rad(deg)*math.pi)*radius+originx, math.sin(math.rad(deg)*math.pi)*radius+originy
		PolyData[deg] = {x=x,y=y}
	end
	surface.SetDrawColor(0,0,255,100)
	surface.DrawPoly(PolyData)
end
local ScreenQuad = function()--Yellow, with transparency.
	surface.SetDrawColor(255,255,0,255/2)
	surface.DrawRect(0,0,ScrW(),ScrH())
end
local ScreenQuadBold = function()--Black, without transparency.
	surface.SetDrawColor(0,0,0,255)
	surface.DrawRect(0,0,ScrW(),ScrH())
end


hook.Add("HUDPaint","CSG 2D Test", function()
	
	//Uncomment to test:
	-- Box()
	-- Triangle()
	-- Circle()
	
	csg.StartTree()
	
	//Uncomment to test:
	-- csg.Add(Box,Circle,ScreenQuad)() --Paint over each item with solid transparent white.
	
	-- csg.Subtract(Box,Triangle)() --Cut the triangle out of the box.
	
	-- csg.Union(Box,Circle,ScreenQuad)() --Only paint the parts covered by both the circle and the box with transparent white.
	
	//Can't csg a csg yet. If you figure out how to do this, message bobbleheadbob on facepunch.
	//This is because the stencil buffer uses global variables which are modified every time a csg is processed.
	-- local add = csg.Add(Box,Circle,ScreenQuad)
	-- csg.Subtract(add,Triangle)() --Trees of cgi within cgi can be made like so. (same effect in this case as subtracting circle from box.)
	
	local sub = csg.Subtract(Box,Triangle)
	csg.Subtract(sub,Circle)()
	
	csg.EndTree()
end)

concommand.Add("testcsg",function()
	local testframe = vgui.Create("DFrame")
	testframe:SetSize(ScrW()/2,ScrH()/2)
	testframe:Center()
	testframe:MakePopup()
	testframe:SetTitle("Test CSG Subtract")

	local oldpaint = testframe.Paint
	function testframe:Paint(w,h)
		local x,y = self:GetPos()
		csg.Start()
			-- local p = csg.Subtract( function() oldpaint(self,w,h) end, function() Circle(800-x,600-y) end)
			local p = csg.Subtract( function() oldpaint(self,w,h) end, function() draw.RoundedBox(8,400-x,400-y,100,100,Color(255,255,255)) end)
			p()
		csg.End()
	end
end)
--]]

--[[Notes:

Transparency can ruin this. Make sure that you only use transparency when specifying the third argument for add or union.
This includes transparent materials. Anything below 255 is considered invisible as far as stencils are concerned.
You can fix this by adding "$alphatest" "1" to your material in question.
See this post, section "Image 2-3-4:", for more info on transparency in stencils:
http://facepunch.com/showthread.php?t=1408855&highlight=alpha

]]


