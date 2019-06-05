--里超时空战斗机-Marisa
function c13257346.initial_effect(c)
	c:EnableCounterPermit(0x351)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(c13257346.addc)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--Power Capsule
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13257346,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCondition(c13257346.pccon)
	e3:SetTarget(c13257346.pctg)
	e3:SetOperation(c13257346.pcop)
	c:RegisterEffect(e3)
	--bomb
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(13257346,6))
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1)
	e4:SetCost(c13257346.bombcost)
	e4:SetTarget(c13257346.bombtg)
	e4:SetOperation(c13257346.bombop)
	c:RegisterEffect(e4)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e11:SetCode(EVENT_SUMMON_SUCCESS)
	e11:SetOperation(c13257346.bgmop)
	c:RegisterEffect(e11)
	eflist={"power_capsule",e3}
	c13257346[c]=eflist
	
end
function c13257346.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsCanAddCounter(0x351,1) then
		e:GetHandler():AddCounter(0x351,1)
	end
end
function c13257346.eqfilter(c,ec)
	return c:IsSetCard(0x352) and c:IsType(TYPE_MONSTER) and c:CheckEquipTarget(ec)
end
function c13257346.pcfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c13257346.pccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c13257346.pcfilter,1,nil,1-tp)
end
function c13257346.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local t1=Duel.IsExistingMatchingCard(c13257346.eqfilter,tp,LOCATION_EXTRA,0,1,nil,c) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	local t2=e:GetHandler():IsCanAddCounter(0x351,1)
	if chk==0 then return t1 or t2 end
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(13257346,1))
	if t1 and t2 then
		op=Duel.SelectOption(tp,aux.Stringid(13257346,2),aux.Stringid(13257346,3))
	elseif t1 then
		op=Duel.SelectOption(tp,aux.Stringid(13257346,2))
	elseif t2 then
		op=Duel.SelectOption(tp,aux.Stringid(13257346,3))+1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_EQUIP)
		Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_EXTRA)
	elseif op==1 then
		e:SetCategory(CATEGORY_COUNTER)
		Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x351)
	end
end
function c13257346.pcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c13257346.eqfilter,tp,LOCATION_EXTRA,0,1,1,nil,c)
		local tc=g:GetFirst()
		if tc then
			Duel.Equip(tp,tc,c)
		end
	elseif e:GetLabel()==1 then
		if c:IsRelateToEffect(e) then
			c:AddCounter(0x351,1)
		end
	end
end
function c13257346.bombcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x351,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x351,1,REASON_COST)
end
function c13257346.desfilter(c,ec)
	return ec:GetColumnGroup():IsContains(c)
end
function c13257346.bombtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(c13257346.efilter)
	e4:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
	e:GetHandler():RegisterEffect(e4)
end
function c13257346.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c13257346.bombop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c13257346.desfilter,tp,0,LOCATION_ONFIELD,nil,e:GetHandler())
	local c=e:GetHandler()
	local e5=Effect.CreateEffect(e:GetHandler())
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e5:SetValue(700)
	c:RegisterEffect(e5)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			if tc:IsFaceup() and not tc:IsDisabled() then
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e2)
				Duel.AdjustInstantly()
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			end
			tc=g:GetNext()
		end
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c13257346.bgmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(11,0,aux.Stringid(13257346,7))
end
