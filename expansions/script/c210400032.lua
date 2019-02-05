--created & coded by Lyris, art at http://static3.bigstockphoto.com/thumbs/6/5/1/large1500/156160115.jpg
--S・VINEの姫オサ
c210400032.spt_other_space=210400097
function c210400032.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddOrigSpatialType(c,false,true)
	aux.AddSpatialProc(c,nil,4,nil,400,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER))
	local ae1=Effect.CreateEffect(c)
	ae1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	ae1:SetType(EFFECT_TYPE_IGNITION)
	ae1:SetRange(LOCATION_MZONE)
	ae1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	ae1:SetCountLimit(1)
	ae1:SetCost(c210400032.cost)
	ae1:SetTarget(c210400032.target)
	ae1:SetOperation(c210400032.op)
	c:RegisterEffect(ae1)
end
function c210400032.cfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckOrExtraAsCost() and Duel.IsExistingTarget(c210400032.filter,tp,LOCATION_REMOVED,0,3,c)
end
function c210400032.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x285b) and c:IsAbleToGrave()
end
function c210400032.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c210400032.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c210400032.filter(chkc) end
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c210400032.cfilter,tp,LOCATION_REMOVED,0,1,nil,tp) and Duel.IsPlayerCanDraw(tp,1)
	end
	local g=Duel.SelectMatchingCard(tp,c210400032.cfilter,tp,LOCATION_REMOVED,0,1,1,nil,tp)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	Duel.ShuffleDeck(tp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(210400032,4))
	local g=Duel.SelectTarget(tp,c210400032.filter,tp,LOCATION_REMOVED,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c210400032.op(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end
	Duel.SendtoGrave(tg,REASON_EFFECT+REASON_RETURN)
	local g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
	if ct==g:GetCount() then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
