--前线阵地 水晶惑星
function c13257215.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c13257215.operation)
	c:RegisterEffect(e1)
	--battle indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c13257215.etarget)
	e2:SetValue(c13257215.efilter)
	c:RegisterEffect(e2)
	--roll and destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13257215,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c13257215.rdtg)
	e3:SetOperation(c13257215.rdop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(13257215,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetCondition(c13257215.spcon)
	e4:SetCost(c13257215.spcost)
	e4:SetTarget(c13257215.sptg)
	e4:SetOperation(c13257215.spop)
	c:RegisterEffect(e4)
	
end
function c13257215.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(11,0,aux.Stringid(13257215,4))
end
function c13257215.etarget(e,c)
	return c:IsAttribute(ATTRIBUTE_EARTH)
end
function c13257215.efilter(e,re)
	return re:GetHandler()==e:GetHandler()
end
function c13257215.rdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(eg:GetFirst():GetSummonPlayer())
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,eg:GetFirst():GetSummonPlayer(),1)
end
function c13257215.desfilter(c)
	return c:GetSequence()>4
end
function c13257215.rdop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local d1=Duel.TossDice(p,1)
	if d1<6 then
		local tc=Duel.GetFieldCard(p,LOCATION_MZONE,d1-1)
		if tc then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	elseif d1==6 then
		local tc=Duel.GetMatchingGroup(c13257215.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c13257215.spfilter(c,e,tp)
	return c:IsCode(13257214) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c13257215.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.GetTurnPlayer()~=tp
end
function c13257215.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,13257215)==0 end
	Duel.RegisterFlagEffect(tp,13257215,RESET_CHAIN,0,1)
end
function c13257215.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c13257215.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c13257215.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c13257215.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.Hint(11,0,aux.Stringid(13257215,5))
	end
end
