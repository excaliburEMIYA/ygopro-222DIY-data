--Wings·绪方智绘里
function c81013014.initial_effect(c)
c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,81013000,c81013014.matfilter,1,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c81013014.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81013014,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c81013014.sprcon)
	e2:SetOperation(c81013014.sprop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_PUBLIC)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	c:RegisterEffect(e3)
end
function c81013014.matfilter(c)
	return c:IsFusionType(TYPE_EFFECT) and c:IsFusionType(TYPE_MONSTER) and c:IsAbleToDeckOrExtraAsCost()
end
function c81013014.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c81013014.cfilter(c)
	return (c:IsFusionCode(81013000) or c81013014.matfilter(c))
		and c:IsCanBeFusionMaterial() and c:IsAbleToDeckOrExtraAsCost()
end
function c81013014.spfilter1(c,tp,g)
	return g:IsExists(c81013014.spfilter2,1,c,tp,c)
end
function c81013014.spfilter2(c,tp,mc)
	return (c:IsFusionCode(81013000) and c81013014.matfilter(c) and mc:IsType(TYPE_MONSTER)
		or c81013014.matfilter(c) and c:IsType(TYPE_MONSTER) and mc:IsFusionCode(81013000))
		and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c81013014.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c81013014.cfilter,tp,LOCATION_ONFIELD,0,nil)
	return g:IsExists(c81013014.spfilter1,1,nil,tp,g)
end
function c81013014.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c81013014.cfilter,tp,LOCATION_ONFIELD,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=g:FilterSelect(tp,c81013014.spfilter1,1,1,nil,tp,g)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=g:FilterSelect(tp,c81013014.spfilter2,1,1,mc,tp,mc)
	g1:Merge(g2)
	local cg=g1:Filter(Card.IsFacedown,nil)
	if cg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,cg)
	end
	Duel.SendtoDeck(g1,nil,2,REASON_COST)
end
