--群星万华镜-伊莉雅
local m=4231004
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:EnableReviveLimit()
    iFunc(c).c("RegisterEffect",iFunc(c)
        .e("SetType",EFFECT_TYPE_SINGLE)
        .e("SetProperty",EFFECT_FLAG_SINGLE_RANGE)
        .e("SetRange",LOCATION_MZONE)
        .e("SetCode",EFFECT_BATTLE_DESTROY_REDIRECT)
        .e("SetValue",LOCATION_REMOVED)
    .Return()).c("RegisterEffect",iFunc(c)
        .e("SetType",EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
        .e("SetCode",EVENT_BATTLED)
        .e("SetCondition",function(e,tp,eg,ep,ev,re,r,rp) 
            local c=e:GetHandler()
            local bc=c:GetBattleTarget()
            return bc and bc:IsStatus(STATUS_BATTLE_DESTROYED) and not c:IsStatus(STATUS_BATTLE_DESTROYED) end)
        .e("SetOperation",function(e,tp,eg,ep,ev,re,r,rp)
            local c=e:GetHandler()
            local bc=c:GetBattleTarget()
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_DISABLE)
            e1:SetReset(RESET_EVENT+0x1660000)
            bc:RegisterEffect(e1)
            local e2=Effect.CreateEffect(c)
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetCode(EFFECT_DISABLE_EFFECT)
            e2:SetReset(RESET_EVENT+0x1660000)
            bc:RegisterEffect(e2) 
            Duel.Damage(1-tp,bc:GetTextAttack()/2,REASON_BATTLE)
            end)
    .Return()).c("RegisterEffect",iFunc(c)
        .e("SetType",EFFECT_TYPE_SINGLE)
        .e("SetCode",EFFECT_SET_ATTACK_FINAL)
        .e("SetProperty",EFFECT_FLAG_SINGLE_RANGE)
        .e("SetRange",LOCATION_MZONE)
        .e("SetCondition",function(e) local c = e:GetHandler() return 
                c:GetEquipGroup():IsExists(function(c) return c:IsCode(4231006) end,1,nil) 
            and c:GetEquipGroup():IsExists(function(c) return c:IsCode(4231007) end,1,nil) end)
        .e("SetValue",function(e,c) return c:GetAttack()*2 end)
    .Return()).c("RegisterEffect",iFunc(c)
        .e("SetType",EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        .e("SetCode",EVENT_CHAINING)
        .e("SetProperty",EFFECT_FLAG_CANNOT_DISABLE)
        .e("SetRange",LOCATION_MZONE)
        .e("SetOperation",aux.chainreg)
    .Return()).c("RegisterEffect",iFunc(c)
        .e("SetDescription",aux.Stringid(51481927,0))
        .e("SetType",EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        .e("SetCode",EVENT_CHAIN_SOLVED)
        .e("SetRange",LOCATION_MZONE)
        .e("SetCondition",function(e,tp,eg,ep,ev,re,r,rp)
            return re and re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
            and re:GetHandler()~=e:GetHandler() and e:GetHandler():GetFlagEffect(1)>0 end)
        .e("SetOperation",function(e,tp,eg,ep,ev,re,r,rp)
            if ep~=tp then return end
            if Duel.Damage(tp,100,REASON_EFFECT) and c:IsFaceup() then 
                local e1=Effect.CreateEffect(e:GetHandler())
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_UPDATE_ATTACK)
                e1:SetValue(100)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
                e:GetHandler():RegisterEffect(e1)             
            end end)
    .Return())
end
function iFunc(c,x)
    local __this = (aux.GetValueType(c) == "Card" and {(x == nil and {Effect.CreateEffect(c)} or {x})[1]} or {x})[1] 
    local fe = function(name,...) (type(__this[name])=="function" and {__this[name]} or {""})[1](__this,...) return iFunc(c,__this) end
    local fc = function(name,...) this = (type(c[name])=="function" and {c[name]} or {""})[1](c,...) return iFunc(c,c) end  
    local func ={e = fe,c = fc,g = fc,v = function() return this end,Return = function() return __this:Clone() end}
    return func
end