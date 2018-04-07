--并蒂的灵魂遐想
local m=1110161
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
--
function c1110161.initial_effect(c)
--
	c:EnableReviveLimit()
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1110161,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(aux.LinkCondition(c1110161.filter1,2,2))
	e1:SetOperation(aux.LinkOperation(c1110161.filter1,2,2))
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1110161,1))
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c1110161.LinkCondition(c1110161.filter2,1,1))
	e2:SetOperation(c1110161.LinkOperation(c1110161.filter2,1,1))
	e2:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c1110161.tg3)
	e3:SetOperation(c1110161.op3)
	c:RegisterEffect(e3)
--
end
--
function c1110161.filter1(c)
	return c:GetLevel()==3
end
--
function c1110161.filter2(c)
	return c:IsType(TYPE_TOKEN) and c:GetLevel()==3
end
--
function c1110161.GetLinkCount(c)
	if c:IsType(TYPE_LINK) and c:GetLink()>1 then
		return 1+0x10000*c:GetLink()
	else return 1 end
end
--
function c1110161.LCheckRecursive(c,tp,sg,mg,lc,ct,minc,maxc,gf)
	sg:AddCard(c)
	ct=ct+1
	local res=c1110161.LCheckGoal(tp,sg,lc,minc,ct,gf)
		or (ct<maxc and mg:IsExists(c1110161.LCheckRecursive,1,sg,tp,sg,mg,lc,ct,minc,maxc,gf))
	sg:RemoveCard(c)
	ct=ct-1
	return res
end
function c1110161.LCheckGoal(tp,sg,lc,minc,ct,gf)
	return ct>=minc and sg:CheckWithSumEqual(c1110161.GetLinkCount,1,ct,ct) and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0 and (not gf or gf(sg))
end
--
function c1110161.LinkCondition(f,minc,maxc,gf)
	return  
	function(e,c)
		if c==nil then return true end
		if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
		local tp=c:GetControler()
		local mg=Duel.GetMatchingGroup(aux.LConditionFilter,tp,LOCATION_MZONE,0,nil,f,c)
		local sg=Group.CreateGroup()
		for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_LMATERIAL)}) do
			local pc=pe:GetHandler()
			if not mg:IsContains(pc) then return false end
			sg:AddCard(pc)
		end
		local ct=sg:GetCount()
		if ct>maxc then return false end
		return c1110161.LCheckGoal(tp,sg,c,minc,ct,gf) or mg:IsExists(c1110161.LCheckRecursive,1,sg,tp,sg,mg,c,ct,minc,maxc,gf)
	end
end
--
function c1110161.LinkOperation(f,minc,maxc,gf)
	return  
	function(e,tp,eg,ep,ev,re,r,rp,c)
		local mg=Duel.GetMatchingGroup(aux.LConditionFilter,tp,LOCATION_MZONE,0,nil,f,c)
		local sg=Group.CreateGroup()
		for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_LMATERIAL)}) do
			sg:AddCard(pe:GetHandler())
		end
		local ct=sg:GetCount()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
		sg:Select(tp,ct,ct,nil)
		for i=ct,maxc-1 do
			local cg=mg:Filter(c1110161.LCheckRecursive,sg,tp,sg,mg,c,i,minc,maxc,gf)
			if cg:GetCount()==0 then break end
			local minct=1
			if c1110161.LCheckGoal(tp,sg,c,minc,i,gf) then
				if not Duel.SelectYesNo(tp,210) then break end
				minct=0
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
			local g=cg:Select(tp,minct,1,nil)
			if g:GetCount()==0 then break end
			sg:Merge(g)
		end
		c:SetMaterial(sg)
		Duel.SendtoGrave(sg,REASON_MATERIAL+REASON_LINK)
		local e2_1=Effect.CreateEffect(c)
		e2_1:SetType(EFFECT_TYPE_SINGLE)
		e2_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2_1:SetCode(EFFECT_ADD_TYPE)
		e2_1:SetValue(TYPE_SPIRIT)
		e2_1:SetReset(RESET_EVENT+0xfe0000)
		c:RegisterEffect(e2_1)
		local e2_2=Effect.CreateEffect(c)
		e2_2:SetType(EFFECT_TYPE_SINGLE)
		e2_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2_2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e2_2:SetValue(1)
		e2_2:SetReset(RESET_EVENT+0xfe0000)
		c:RegisterEffect(e2_2)
	end
end
--
function c1110161.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=true
	local b2=true
	if chk==0 then return true end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(1110161,2)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(1110161,3)
		opval[off-1]=2
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
end
--
function c1110161.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if sel==1 then
		Duel.RegisterFlagEffect(tp,1110161,RESET_PHASE+PHASE_END,0,1)
	else
		local e3_1=Effect.CreateEffect(c)
		e3_1:SetType(EFFECT_TYPE_FIELD)
		e3_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3_1:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
		e3_1:SetTargetRange(LOCATION_MZONE,0)
		e3_1:SetTarget(c1110161.tg3_1)
		e3_1:SetValue(1)
		e3_1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		Duel.RegisterEffect(e3_1,tp)
	end
end
--
function c1110161.tg3_1(e,c)
	return muxu.check_set_Urban(c)
end
--
