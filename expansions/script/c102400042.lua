--created & coded by Lyris, art from Cardfight!! Vanguard's "Hades Hypnotist"
local cid,id=GetID()
function cid.initial_effect(c)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_HAND)
	e4:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e4:SetCondition(cid.atkcon)
	e4:SetTarget(cid.atktg)
	e4:SetOperation(cid.atkop)
	c:RegisterEffect(e4)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetDescription(1192)
	e1:SetCondition(function(e) return e:GetHandler():IsSetCard(0x2c74) end)
	e1:SetTarget(cid.target)
	e1:SetOperation(cid.operation)
	c:RegisterEffect(e1)
end
function cid.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttackTarget()
	return a and a:IsControler(tp) and a:IsSetCard(0xc74)
end
function cid.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	if chk==0 then return e:GetHandler():IsCanOverlay(tp) and a:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsType),tp,LOCATION_MZONE,0,1,nil,TYPE_XYZ) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,a,1,0,0)
end
function cid.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,aux.AND(Card.IsFaceup,Card.IsType),tp,LOCATION_MZONE,0,1,1,nil,TYPE_XYZ):GetFirst()
	if not tc then return end
	Duel.Overlay(tc,c)
	local a=Duel.GetAttacker()
	if c:IsLocation(LOCATION_OVERLAY) and a:IsRelateToBattle() and Duel.Remove(a,0,REASON_EFFECT+REASON_TEMPORARY)>0 then
		a:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetCountLimit(1)
		e1:SetCondition(function(ef) return Duel.GetTurnCount()~=ef:GetLabel() and a:GetFlagEffect(id)>0 end)
		e1:SetOperation(function() Duel.ReturnToField(a) end)
		Duel.RegisterEffect(e1,tp)
	end
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(aux.AND(Card.IsDefensePos,Card.IsAbleToRemove),tp,0,LOCATION_MZONE,nil)
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function cid.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,aux.AND(Card.IsDefensePos,Card.IsAbleToRemove),tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
	if tc and Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)>0 then
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetCountLimit(1)
		e1:SetCondition(function(ef) return Duel.GetTurnCount()~=ef:GetLabel() and tc:GetFlagEffect(id)>0 end)
		e1:SetOperation(function() Duel.ReturnToField(tc) end)
		Duel.RegisterEffect(e1,tp)
	end
end
