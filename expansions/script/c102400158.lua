--created & coded by Lyris, art from Shadowverse's "Lishenna, Omen of Destruction"
--滅却神リシェンナ
local cid,id=GetID()
function cid.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,4,2)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetCost(cid.cost)
	e3:SetTarget(cid.tg)
	e3:SetOperation(cid.op)
	c:RegisterEffect(e3)
	local s1=Effect.CreateEffect(c)
	s1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	s1:SetCode(EVENT_SPSUMMON)
	s1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	s1:SetOperation(function() Duel.Hint(HINT_SOUND,0,aux.Stringid(id,10)) end)
	c:RegisterEffect(s1)
	local s2=s1:Clone()
	s2:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(s2)
	local s5=Effect.CreateEffect(c)
	s5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	s5:SetCode(EVENT_ATTACK_ANNOUNCE)
	s5:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	s5:SetOperation(function() Duel.Hint(HINT_SOUND,0,aux.Stringid(id,12)) end)
	c:RegisterEffect(s5)
	local s6=Effect.CreateEffect(c)
	s6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	s6:SetCode(EVENT_DESTROYED)
	s6:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	s6:SetOperation(function() Duel.Hint(HINT_SOUND,0,aux.Stringid(id,13)) end)
	c:RegisterEffect(s6)
end
function cid.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) and #e:GetHandler():GetOverlayGroup()>1 end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cid.filter(c,tp)
	return (c:IsCode(102400148) or c:IsCode(102400149)) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function cid.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(cid.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SOUND,0,aux.Stringid(id,11))
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler():GetOverlayGroup(),1,0,0)
end
function cid.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	if Duel.Destroy(e:GetHandler():GetOverlayGroup():Select(tp,1,1,nil),REASON_EFFECT)==0 or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local sg=Duel.SelectMatchingCard(tp,cid.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp)
	local tc=sg:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		Duel.Hint(HINT_SOUND,0,aux.Stringid(tc:GetCode(),10))
	end
end
