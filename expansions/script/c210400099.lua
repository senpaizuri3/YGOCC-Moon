--created & coded by Lyris
--S－VINEの騎士クライッシャ(アナザー宙)
function c210400099.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddOrigSpatialType(c)
	aux.AddSpatialProc(c,nil,8,300,nil,aux.TRUE,aux.TRUE)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,210400099)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE)
	e3:SetHintTiming(0,0x1e0)
	e3:SetCost(c210400099.descost)
	e3:SetTarget(c210400099.destg)
	e3:SetOperation(c210400099.desop)
	c:RegisterEffect(e3)
end
function c210400099.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c210400099.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c210400099.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsPreviousPosition(POS_FACEUP) then
		tc:RegisterFlagEffect(210400099,RESET_EVENT+0x3fc0000+RESET_PHASE+PHASE_END,0,2)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(1102)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabelObject(tc)
		e1:SetCondition(c210400099.con)
		e1:SetOperation(c210400099.op)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
	end
end
function c210400099.con(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:GetFlagEffect(210400099)~=0 and Duel.GetTurnCount()~=tc:GetTurnID()
end
function c210400099.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_HAND+LOCATION_EXTRA,LOCATION_HAND+LOCATION_EXTRA,nil,tc:GetPreviousCodeOnField())
	Duel.Hint(HINT_CARD,0,210400099)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
