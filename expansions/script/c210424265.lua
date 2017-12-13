--Moon Burst's Big Bang
function c210424265.initial_effect(c)
	c:EnableCounterPermit(0x5)
	c:SetCounterLimit(0x5,3)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c210424265.accon)
	e2:SetTarget(c210424265.damtg)
	e2:SetOperation(c210424265.acop)
	c:RegisterEffect(e2)
	--remove counters
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(63092423,2))
    e3:SetCategory(CATEGORY_COUNTER)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e3:SetCountLimit(1)
    e3:SetRange(LOCATION_SZONE)
    e3:SetOperation(c210424265.ctop2)
    c:RegisterEffect(e3)
		--destroy&damage
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(210424265,0))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EVENT_CUSTOM+210424265)
	e5:SetCost(c210424265.descost)
	e5:SetTarget(c210424265.destg)
	e5:SetOperation(c210424265.desop)
	c:RegisterEffect(e5)
end

function c210424265.ctop2(e,tp,eg,ep,ev,re,r,rp)
 
    local c=e:GetHandler()
    local ct=c:GetCounter(0x5)

    c:RemoveCounter(tp,0x5,ct,REASON_EFFECT) 
end

function c210424265.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler() and e:GetHandler():GetCounter(0x5)==3 end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	e:GetHandler():RemoveCounter(tp,0x5,3,REASON_COST)
end
function c210424265.desfilter(c)
	return c:IsDestructable()
end
function c210424265.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_ONFIELD and c210424265.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c210424265.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c210424265.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c210424265.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
		
	   end
	end












function c210424265.filter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x666)
end
function c210424265.accon(e,tp,eg,ep,ev,re,r,rp)
		if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c210424265.filter,1,nil,tp)
end
function c210424265.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(200)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,200)
end

function c210424265.acop(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
	e:GetHandler() c:AddCounter(0x5,1)
			if c:GetCounter(0x5)==3 then
			Duel.RaiseSingleEvent(c,EVENT_CUSTOM+210424265,re,0,0,p,0)
end
end