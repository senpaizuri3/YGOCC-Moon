--card owner: saikufunction c11227793.initial_effect(c)       --pend.summon	aux.EnablePendulumAttribute(c)	--atkdeff	local e2=Effect.CreateEffect(c)	e2:SetType(EFFECT_TYPE_FIELD)	e2:SetCode(EFFECT_UPDATE_ATTACK)	e2:SetRange(LOCATION_MZONE)	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x26E7))	e2:SetValue(c11227793.value)	c:RegisterEffect(e2)	local e3=e2:Clone()	e3:SetCode(EFFECT_UPDATE_DEFENSE)	c:RegisterEffect(e3)	--atkdeff2	local e4=Effect.CreateEffect(c)	e4:SetType(EFFECT_TYPE_FIELD)	e4:SetRange(LOCATION_PZONE)	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)	e4:SetCode(EFFECT_UPDATE_ATTACK)	e4:SetTarget(c11227793.atktg)	e4:SetValue(c11227793.atkval)	c:RegisterEffect(e4)	local e5=e4:Clone()	e5:SetCode(EFFECT_UPDATE_DEFENSE)	c:RegisterEffect(e5)endfunction c11227793.filter(c)	return c:IsFaceup() and c:IsSetCard(0x26E7)endfunction c11227793.value(e,c)	returnDuel.GetMatchingGroupCount(c11227793.filter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*150endfunction c11227793.atktg(e,c)	return not c:IsSetCard(0x26E7)endfunction c11227793.vfilter(c)	return c:IsFaceup() and c:IsSetCard(0x26E7)endfunction c11227793.atkval(e,c)	returnDuel.GetMatchingGroupCount(c11227793.vfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*-150end