--Silent Star Dragomir, the Skydian's Radiance
function c997569826.initial_effect(c)
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,c997569826.mfilter,2,2)
    --to hand
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(997569826,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
    e1:SetCode(CATEGORY_REMOVE)
    e1:SetCountLimit(1,997569826)
    e1:SetTarget(c997569826.thtg)
    e1:SetOperation(c997569826.thop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCondition(c997569826.thcon)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,997569826)
    e3:SetCategory(CATEGORY_TOGRAVE)
    e3:SetCost(c997569826.tgcost)
    e3:SetTarget(c997569826.tgtg)
    e3:SetOperation(c997569826.tgop)
    c:RegisterEffect(e3)
end
function c997569826.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c997569826.thfilter(c)
    return c:IsSetCard(0xd0a1) or c:IsSetCard(0x223) and c:IsAbleToHand()
end
function c997569826.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local dg=Duel.GetMatchingGroup(c997569826.thfilter,tp,LOCATION_DECK,0,nil)
        return dg:GetClassCount(Card.GetCode)>=3
    end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c997569826.thop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c997569826.thfilter,tp,LOCATION_DECK,0,nil)
    if g:GetClassCount(Card.GetCode)>=3 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
        local sg1=g:Select(tp,1,1,nil)
        g:Remove(Card.IsCode,nil,sg1:GetFirst():GetCode())
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
        local sg2=g:Select(tp,1,1,nil)
        g:Remove(Card.IsCode,nil,sg2:GetFirst():GetCode())
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
        local sg3=g:Select(tp,1,1,nil)
        sg1:Merge(sg2)
        sg1:Merge(sg3)
        Duel.ConfirmCards(1-tp,sg1)
        Duel.ShuffleDeck(tp)
        Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
        local cg=sg1:Select(1-tp,1,1,nil)
        local tc=cg:GetFirst()
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
    end
end
function c997569826.rmfil(c)
    return c:IsSetCard(0x223) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c997569826.tgfilter(c)
    return c:IsSetCard(0xd0a1) or c:IsSetCard(0x223) and c:IsAbleToGrave()
end
function c997569826.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c997569826.rmfil,tp,LOCATION_EXTRA,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c997569826.rmfil,tp,LOCATION_EXTRA,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c997569826.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c997569826.tgfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c997569826.tgop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c997569826.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end