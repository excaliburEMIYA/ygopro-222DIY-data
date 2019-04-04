--宇宙战争兵器 巨炮 解离镭射
function c13257204.initial_effect(c)
	c:EnableReviveLimit()
	--equip limit
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_EQUIP_LIMIT)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e11:SetValue(c13257204.eqlimit)
	c:RegisterEffect(e11)
	--immune
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_IMMUNE_EFFECT)
	e12:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e12:SetRange(LOCATION_SZONE)
	e12:SetCondition(c13257204.econ)
	e12:SetValue(c13257204.efilter)
	c:RegisterEffect(e12)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(300)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13257204,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetHintTiming(0,0x1e0)
	e3:SetCountLimit(1)
	e3:SetCondition(c13257204.econ)
	e3:SetTarget(c13257204.destg)
	e3:SetOperation(c13257204.desop)
	c:RegisterEffect(e3)
	c:RegisterFlagEffect(13257201,0,0,0,1)
	
end
function c13257204.eqlimit(e,c)
	local eg=c:GetEquipGroup()
	local lv=c:GetOriginalLevel()
	if lv==nil then lv=0 end
	if not eg:IsContains(e:GetHandler()) then
		eg:AddCard(e:GetHandler())
	end
	local cl=c:GetFlagEffectLabel(13257200)
	if cl==nil then
		cl=0
	end
	local er=e:GetHandler():GetFlagEffectLabel(13257201)
	if er==nil then
		er=0
	end
	return not (er>cl) and c:GetOriginalLevel()>=7 and not (eg:Filter(Card.IsSetCard,nil,0x354):GetSum(Card.GetLevel)>lv)
end
function c13257204.econ(e)
	return e:GetHandler():GetEquipTarget()
end
function c13257204.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function c13257204.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler():GetEquipTarget()
	if chkc then return chkc:IsOnField() and chkc:IsFaceup() and chkc:IsControler(1-tp) end
	if chk==0 then return ec and Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c13257204.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-500)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		if tc:IsFaceup() and (tc:GetAttack()==0 or (tc:GetDefense()==0 and not tc:IsType(TYPE_LINK))) then
			if Duel.Destroy(tc,REASON_EFFECT)~=0 then
				Duel.Damage(1-tp,1000,REASON_EFFECT)
			end
		end
	end
end
