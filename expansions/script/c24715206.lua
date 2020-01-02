--created by manu, coded by Lyris
local cid,id=GetID()
function cid.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cid.spcon)
	e1:SetOperation(cid.spop)
	c:RegisterEffect(e1)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e9)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(cid.target)
	e2:SetOperation(cid.operation)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_DECK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(function(e,tp,eg) return eg:IsExists(cid.cfilter,1,e:GetHandler(),1-tp) and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS)) end)
	e3:SetOperation(cid.op)
	c:RegisterEffect(e3)
	local g=Group.CreateGroup()
	g:KeepAlive()
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetRange(LOCATION_MZONE)
	e5:SetLabelObject(g)
	e5:SetCondition(function(e,tp,eg) return eg:IsExists(cid.cfilter,1,e:GetHandler(),1-tp) and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS) end)
	e5:SetOperation(function(e) e:GetLabelObject():Merge(eg) end)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e6:SetCode(EVENT_CHAIN_SOLVED)
	e6:SetLabelObject(e5)
	e6:SetOperation(cid.op2)
	e6:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e6)
end
function cid.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x70b) and not c:IsPublic()
end
function cid.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cid.filter,c:GetControler(),LOCATION_HAND,0,3,e:GetHandler())
end
function cid.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,cid.filter,tp,LOCATION_HAND,0,3,3,c)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsFaceup() and chkc:IsSetCard(0x70b) and chkc~=e:GetHandler() end
	if chk==0 then return true end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,aux.AND(Card.IsFaceup,Card.IsSetCard),tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c,0x70b)
end
function cid.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	for tc in aux.Next(g) do
		if tc:IsFaceup() and tc:IsRelateToEffect(e) then
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_CHAINING)
			e2:SetOperation(cid.chainop)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2,true)
		end
	end
end
function cid.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsSetCard(0x70b) then
		Duel.SetChainLimit(function(fe,frp,ftp) return ftp==frp end)
	end
end
function cid.cfilter(c,p)
	return c:IsFaceup() and c:IsSetCard(0x70b) and c:IsControler(p)
end
function cid.spfilter(c,e,tp,t)
	return not t[c:GetCode()] and c:IsSetCard(0x70b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cid.op(e,tp,eg,ep,ev,re,r,rp)
	local t={}
	for ec in aux.Next(eg) do t[ec:GetCode()]=true end
	local g=Duel.GetMatchingGroup(cid.spfilter,tp,LOCATION_DECK,0,nil,e,tp,t)
	if #g>0 then
		Duel.Hint(HINT_CARD,0,id)
		Duel.SpecialSummon(g:Select(tp,1,1,nil),0,tp,tp,false,false,POS_FACEUP)
	end
end
function cid.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject():GetLabelObject()
	cid.op(e,tp,g,ep,ev,re,r,rp)
	g:Clear()
end
