--禁忌飞球·妒忌
function c13254073.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,13254062,aux.FilterBoolFunction(c13254073.ffilter),1,true,false)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c13254073.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c13254073.sprcon)
	e2:SetOperation(c13254073.sprop)
	c:RegisterEffect(e2)
	--splimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c13254073.psplimit)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c13254073.sptg)
	e4:SetOperation(c13254073.spop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(13254073,3))
	e5:SetCategory(CATEGORY_TODECK)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetTarget(c13254073.pentg)
	e5:SetOperation(c13254073.penop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_HANDES)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCode(EVENT_RELEASE)
	e6:SetCountLimit(1,23254073)
	e6:SetCondition(c13254073.hdcon)
	e6:SetTarget(c13254073.hdtg)
	e6:SetOperation(c13254073.hdop)
	c:RegisterEffect(e6)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e10:SetCode(EFFECT_CHANGE_LEVEL)
	e10:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e10:SetValue(1)
	c:RegisterEffect(e10)
	
end
function c13254073.ffilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1)
end
function c13254073.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c13254073.cfilter(c)
	return (c:IsFusionCode(13254062) or (c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1)) and c:IsType(TYPE_MONSTER))
		and c:IsCanBeFusionMaterial() and c:IsReleasable()
end
function c13254073.fcheck(c,sg)
	return c:IsFusionCode(13254062) and sg:IsExists(c13254073.fcheck2,1,c)
end
function c13254073.fcheck2(c)
	return c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1)
end
function c13254073.fselect(c,tp,mg,sg)
	sg:AddCard(c)
	local res=false
	if sg:GetCount()<2 then
		res=mg:IsExists(c13254073.fselect,1,sg,tp,mg,sg)
	elseif Duel.GetLocationCountFromEx(tp,tp,sg)>0 then
		res=sg:IsExists(c13254073.fcheck,1,nil,sg)
	end
	sg:RemoveCard(c)
	return res
end
function c13254073.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c13254073.cfilter,tp,LOCATION_ONFIELD,0,nil)
	local sg=Group.CreateGroup()
	return mg:IsExists(c13254073.fselect,1,nil,tp,mg,sg)
end
function c13254073.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c13254073.cfilter,tp,LOCATION_ONFIELD,0,nil)
	local sg=Group.CreateGroup()
	while sg:GetCount()<2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=mg:FilterSelect(tp,c13254073.fselect,1,1,sg,tp,mg,sg)
		sg:Merge(g)
	end
	local cg=sg:Filter(Card.IsFacedown,nil)
	if cg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,cg)
	end
	Duel.Release(sg,REASON_COST)
end
function c13254073.psplimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0x356) and c:IsType(TYPE_MONSTER) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c13254073.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c13254073.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13254073.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c13254073.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 or not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c13254073.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,nil,e,tp)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c13254073.filter1(c)
	return (c:IsCode(13254036) or c:IsCode(13254062)) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c13254073.pentg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c13254073.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c13254073.filter1,tp,LOCATION_GRAVE,0,1,nil) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,c13254073.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,1,0,0)
end
function c13254073.penop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)~=1 then return end
	Duel.BreakEffect()
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	--Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(13254073,4))
	--local sel=Duel.SelectOption(tp,70,71,72)
	--if sel==0 then
	--  Duel.ConfirmCards(tp,g)
	--  local dg=g:Filter(Card.IsType,nil,TYPE_MONSTER)
	--  local ct=Duel.Destroy(dg,REASON_EFFECT)
	--  Duel.ShuffleHand(1-tp)
	--  local g=Duel.GetMatchingGroup(Card.IsType,1-tp,LOCATION_DECK,0,nil,TYPE_MONSTER)
	--  if ct>0 and g:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(13254073,8)) then
	--  Duel.BreakEffect()
	--  Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DESTROY)
	--  local dg=g:Select(1-tp,1,3,nil)
	--  Duel.Destroy(dg,REASON_EFFECT)
	--  end
	--elseif sel==1 then
	--  Duel.ConfirmCards(tp,g)
	--  local dg=g:Filter(Card.IsType,nil,TYPE_SPELL)
	--  local ct=Duel.Destroy(dg,REASON_EFFECT)
	--  Duel.ShuffleHand(1-tp)local g=Duel.GetMatchingGroup(Card.IsType,1-tp,LOCATION_DECK,0,nil,TYPE_SPELL)
	--  if ct>0 and g:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(13254073,8)) then
	--  Duel.BreakEffect()
	--  Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DESTROY)
	--   local dg=g:Select(1-tp,1,3,nil)
	--  Duel.Destroy(dg,REASON_EFFECT)
	--  end
	--else
	--  Duel.ConfirmCards(tp,g)
	--  local dg=g:Filter(Card.IsType,nil,TYPE_TRAP)
	--  local ct=Duel.Destroy(dg,REASON_EFFECT)
	--  Duel.ShuffleHand(1-tp)local g=Duel.GetMatchingGroup(Card.IsType,1-tp,LOCATION_DECK,0,nil,TYPE_TRAP)
	--  if ct>0 and g:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(13254073,8)) then
	--  Duel.BreakEffect()
	--  Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DESTROY)
	--  local dg=g:Select(1-tp,1,3,nil)
	--  Duel.Destroy(dg,REASON_EFFECT)
	--  end
	--end
end
function c13254073.hdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
end
function c13254073.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)~=0 end
end
function c13254073.hdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(13254073,9))
		Duel.ConfirmCards(tp,g)
		local sg=hg:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,tp,REASON_EFFECT)
		Duel.ShuffleHand(1-tp)
	end
end

